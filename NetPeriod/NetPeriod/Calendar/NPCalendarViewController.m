#import <CoreGraphics/CoreGraphics.h>
#import "NPCalendarViewController.h"
#import "NPCalendarView.h"
#import "MBProgressHUD.h"
#import "NPUser.h"
#import "AFNetworking.h"
#import "Md5.h"

@interface NPCalendarViewController () <NPCalendarDelegate, MBProgressHUDDelegate> {
    MBProgressHUD *HUD;
    NPUser *user;
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
    user = [[NPUser alloc] init];
    self.period = [user.totalPeriod intValue];
    self.startDate = [self.dateFormatter dateFromString:@"15/07/2013"];
    self.lastDays = [user.mensesPeriod intValue];
    
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
    self.title = @"日历";
    [self disableAllButtons];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.period = [user.totalPeriod intValue];
    self.startDate = [self.dateFormatter dateFromString:@"15/07/2013"];
    self.lastDays = [user.mensesPeriod intValue];
    [self.calendarView layoutSubviews];
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
        dateItem.backgroundColor = [UIColor colorWithRed:254.0/255.0 green:215.0/255.0 blue:211.0/255.0 alpha:1.0];
        dateItem.textColor = [UIColor whiteColor];
    }
    
    if ([self dateIsInOvulatePeriod:date]) {
        dateItem.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:246.0/255.0 blue:216.0/255.0 alpha:1.0];
        dateItem.textColor = [UIColor blackColor];
    }
//    if ([self dateIsDisabled:date]) {
//        dateItem.backgroundColor = [UIColor redColor];
//        dateItem.textColor = [UIColor whiteColor];
//    }
}

- (BOOL)calendar:(NPCalendarView *)calendar willSelectDate:(NSDate *)date {
    if (!calendar.selectedDate) {
        if ([user.gender isEqualToString:@"f"]) {
            [self enableAllButtons];
        }
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
    [scrollView setContentSize:CGSizeMake(320, frame.size.height + 222)];
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
    user.startMenses = [self.dateFormatter stringFromDate:self.startDate];
    user.endMenses = [self addDaysToDate:user.startMenses days:user.mensesPeriod];
    [self.calendarView layoutSubviews];
}

- (IBAction)yimaleave:(id)sender {
    NSInteger intervalDays = [self.calendarView.selectedDate timeIntervalSinceDate:self.startDate] / 86400 ;
    if (intervalDays % self.period >= 0) {
        if (intervalDays % self.period <= 7 && intervalDays % self.period >= 3) {
            self.lastDays = intervalDays % self.period + 1;
            user.mensesPeriod = [NSString stringWithFormat:@"%d", self.lastDays];
            [self.calendarView layoutSubviews];
        } else {
            [self showErrorInfo];
        }
    } else if (intervalDays % self.period + 28 < 7) {
        self.lastDays = intervalDays % self.period + 29;
        user.mensesPeriod = [NSString stringWithFormat:@"%d", self.lastDays];
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

- (NSString *)addDaysToDate:(NSString *)date days:(NSString *)days{
    
    
    // Retrieve NSDate instance from stringified date presentation
    NSDate *dateFromString = [self.dateFormatter dateFromString:date];
    
    // Create and initialize date component instance
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:[days intValue]];
    
    // Retrieve date with increased days count
    NSDate *newDate = [[NSCalendar currentCalendar]
                       dateByAddingComponents:dateComponents
                       toDate:dateFromString options:0];
    
    return [self.dateFormatter stringFromDate:newDate];
}

- (void)syncInfo
{
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://192.168.130.50:8080/"]];
    [httpClient setParameterEncoding:AFFormURLParameterEncoding];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST"
                                                            path:@"http://192.168.130.50:8080/np-web/sync"
                                                      parameters:@{
                                    @"email":user.username,
                                    @"gender":user.gender,
                                    @"birthday":@"",
                                    @"starttime":user.startMenses,
                                    @"endtime":user.endMenses,
                                    @"period":user.totalPeriod,
                                    @"channels":[NSString stringWithFormat:@"user%@", [Md5 encode:user.username]]}];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        // Print the response body in text
        NSLog(@"Response: %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    [operation start];

}
#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
	// Remove HUD from screen when the HUD was hidded
	[HUD removeFromSuperview];
	HUD = nil;
}

@end