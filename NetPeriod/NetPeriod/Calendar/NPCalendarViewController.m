#import <CoreGraphics/CoreGraphics.h>
#import "NPCalendarViewController.h"
#import "NPCalendarView.h"
#import "MBProgressHUD.h"

@interface NPCalendarViewController () <NPCalendarDelegate, MBProgressHUDDelegate> {
    MBProgressHUD *HUD;
}

@property (nonatomic, weak) NPCalendarView *calendarView;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSDate *minimumDate;
@property (nonatomic, strong) NSArray *disabledDates;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, assign) NSInteger lastDays;
@property (nonatomic, assign) NSInteger period;

@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet UIButton *yimaButton;
@property (weak, nonatomic) IBOutlet UIButton *fluxButton;
@property (weak, nonatomic) IBOutlet UIButton *moodButton;
@property (weak, nonatomic) IBOutlet UIButton *symptombutton;
@property (weak, nonatomic) IBOutlet UIView *yimaView;
@property (weak, nonatomic) IBOutlet UIView *fluxView;
@property (weak, nonatomic) IBOutlet UIView *moodView;
@property (weak, nonatomic) IBOutlet UIView *symptomView;

@property (weak, nonatomic) IBOutlet UIButton *yimaComeButton;
@property (weak, nonatomic) IBOutlet UIButton *yimaLeaveButton;
@end

@implementation NPCalendarViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)awakeFromNib
{
    NPCalendarView *calendar = [[NPCalendarView alloc] initWithStartDay:startMonday];
    self.calendarView = calendar;
    calendar.delegate = self;
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"dd/MM/yyyy"];
    self.minimumDate = [self.dateFormatter dateFromString:@"20/09/2012"];
//    self.disabledDates = @[
//                           [self.dateFormatter dateFromString:@"05/01/2013"],
//                           [self.dateFormatter dateFromString:@"06/01/2013"],
//                           [self.dateFormatter dateFromString:@"07/01/2013"]
//                           ];
    self.period = 28;
    self.startDate = [self.dateFormatter dateFromString:@"15/07/2013"];
    self.lastDays = 4;
    
    calendar.onlyShowCurrentMonth = NO;
    calendar.adaptHeightToNumberOfWeeksInMonth = YES;
    
    calendar.frame = CGRectMake(10, 10, 300, 320);
    [self.view addSubview:calendar];
    
//    self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(calendar.frame) + 4, self.view.bounds.size.width, 24)];
//    [self.view addSubview:self.dateLabel];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localeDidChange) name:NSCurrentLocaleDidChangeNotification object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self disableAllButtons];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (void)localeDidChange {
    [self.calendarView setLocale:[NSLocale currentLocale]];
}

- (BOOL)dateIsInMensesPeriod:(NSDate *)date {
    NSInteger intervalDays = [date timeIntervalSinceDate:self.startDate] / 86400 ;
    if (intervalDays % self.period >= 0) {
        if (intervalDays % self.period < self.lastDays) {
            return YES;
        }
    } else if (intervalDays % self.period + 28 < self.lastDays) {
        return YES;
    }
    return NO;
}

- (BOOL)dateIsInOvulatePeriod:(NSDate *)date {
    NSInteger intervalDays = [date timeIntervalSinceDate:self.startDate] / 86400 + 19;
    if (intervalDays % self.period >= 0) {
        if (intervalDays % self.period < 10) {
            return YES;
        }
    } else if (intervalDays % self.period + 28 < 10) {
        return YES;
    }
    
    return NO;
}

- (BOOL)dateIsDisabled:(NSDate *)date {
    for (NSDate *disabledDate in self.disabledDates) {
        if ([disabledDate isEqualToDate:date]) {
            return YES;
        }
    }
    return NO;
}

#pragma mark -
#pragma mark - CKCalendarDelegate

- (void)calendar:(NPCalendarView *)calendar configureDateItem:(NPDateItem *)dateItem forDate:(NSDate *)date {
    // TODO: play with the coloring if we want to...
    if ([self dateIsInMensesPeriod:date]) {
        dateItem.backgroundColor = [UIColor redColor];
        dateItem.textColor = [UIColor whiteColor];
    }
    
    if ([self dateIsInOvulatePeriod:date]) {
        dateItem.backgroundColor = [UIColor yellowColor];
        dateItem.textColor = [UIColor blackColor];
    }
//    if ([self dateIsDisabled:date]) {
//        dateItem.backgroundColor = [UIColor redColor];
//        dateItem.textColor = [UIColor whiteColor];
//    }
}

- (BOOL)calendar:(NPCalendarView *)calendar willSelectDate:(NSDate *)date {
    if (!calendar.selectedDate) {
        [self enableAllButtons];
    }
    return ![self dateIsDisabled:date];
}

- (void)calendar:(NPCalendarView *)calendar didSelectDate:(NSDate *)date {
//    self.dateLabel.text = [self.dateFormatter stringFromDate:date];
    if (!calendar.selectedDate) {
        [self disableAllButtons];
    }
}

- (BOOL)calendar:(NPCalendarView *)calendar willChangeToMonth:(NSDate *)date {
    if ([date laterDate:self.minimumDate] == date) {
//        self.calendarView.backgroundColor = [UIColor blueColor];
        return YES;
    } else {
//        self.calendarView.backgroundColor = [UIColor redColor];
        return NO;
    }
}

- (void)calendar:(NPCalendarView *)calendar didLayoutInRect:(CGRect)frame {
//    NSLog(@"calendar layout: %@", NSStringFromCGRect(frame));
    self.bottomView.frame = CGRectMake(0, frame.size.height + 14, 320, 160);
    UIScrollView *scrollView = (UIScrollView *)self.view;
    [scrollView setContentSize:CGSizeMake(320, frame.size.height + 172)];
}

#pragma mark - Button Actions

- (void)disableAllButtons {
    self.yimaButton.enabled = NO;
    self.fluxButton.enabled = NO;
    self.moodButton.enabled = NO;
    self.symptombutton.enabled = NO;
    
    self.yimaView.hidden = YES;
    self.fluxView.hidden = YES;
    self.moodView.hidden = YES;
    self.symptomView.hidden = YES;
}

- (void)enableAllButtons {
    self.yimaButton.enabled = YES;
    self.fluxButton.enabled = YES;
    self.moodButton.enabled = YES;
    self.symptombutton.enabled = YES;
}

- (IBAction)YimaClicked:(id)sender {
    self.yimaButton.enabled = NO;
    self.fluxButton.enabled = YES;
    self.moodButton.enabled = YES;
    self.symptombutton.enabled = YES;
        
    self.yimaView.hidden = NO;
    self.fluxView.hidden = YES;
    self.moodView.hidden = YES;
    self.symptomView.hidden = YES;

}

- (IBAction)fluxClicked:(id)sender {
    self.yimaButton.enabled = YES;
    self.fluxButton.enabled = NO;
    self.moodButton.enabled = YES;
    self.symptombutton.enabled = YES;
    
    self.yimaView.hidden = YES;
    self.fluxView.hidden = NO;
    self.moodView.hidden = YES;
    self.symptomView.hidden = YES;
}

- (IBAction)moodClicked:(id)sender {
    self.yimaButton.enabled = YES;
    self.fluxButton.enabled = YES;
    self.moodButton.enabled = NO;
    self.symptombutton.enabled = YES;
    
    self.yimaView.hidden = YES;
    self.fluxView.hidden = YES;
    self.moodView.hidden = NO;
    self.symptomView.hidden = YES;
}

- (IBAction)symptomClicked:(id)sender {
    self.yimaButton.enabled = YES;
    self.fluxButton.enabled = YES;
    self.moodButton.enabled = YES;
    self.symptombutton.enabled = NO;
    
    self.yimaView.hidden = YES;
    self.fluxView.hidden = YES;
    self.moodView.hidden = YES;
    self.symptomView.hidden = NO;
}

- (IBAction)yimaCome:(id)sender {
    self.startDate = self.calendarView.selectedDate;
    [self.calendarView layoutSubviews];
}

- (IBAction)yimaleave:(id)sender {
    NSInteger intervalDays = [self.calendarView.selectedDate timeIntervalSinceDate:self.startDate] / 86400 ;
    if (intervalDays % self.period >= 0) {
        if (intervalDays % self.period < 7) {
            self.lastDays = intervalDays % self.period;
            [self.calendarView layoutSubviews];
        } else {
            [self showErrorInfo];
        }
    } else if (intervalDays % self.period + 28 < 7) {
        self.lastDays = intervalDays % self.period + 28;
        [self.calendarView layoutSubviews];
    } else {
        [self showErrorInfo];
    }
}

- (void)showErrorInfo {
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.mode = MBProgressHUDModeText;
    HUD.delegate = self;
    HUD.labelText = @"您的大姨妈有点不正常吧";
    [HUD show:YES];
    [HUD hide:YES afterDelay:1];
}

#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
	// Remove HUD from screen when the HUD was hidded
	[HUD removeFromSuperview];
	HUD = nil;
}

@end