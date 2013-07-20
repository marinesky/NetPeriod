//
//  NPSettingPeriodViewController.m
//  NetPeriod
//
//  Created by Dafeng Jin on 13-7-20.
//  Copyright (c) 2013年 NetEase. All rights reserved.
//

#import "NPSettingPeriodViewController.h"
#import "AFNetworking.h"
#import "NPUser.h"
#import "UIView+FindAndResignFirstResponder.h"

@interface NPSettingPeriodViewController () {
    BOOL isDatePickerShowing;
    BOOL isKeyboardShowing;
    NSInteger anonymousCount;
    NSDateFormatter* dateFormatter;
}

@property (weak, nonatomic) IBOutlet UITextField *birthdayTextFiled;
@property (weak, nonatomic) IBOutlet UITextField *lastMensesTextField;
@property (weak, nonatomic) IBOutlet UITextField *mensesPeriodTextField;
@property (weak, nonatomic) IBOutlet UITextField *totalPeriodTextField;

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@end

@implementation NPSettingPeriodViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self customSubviews];
}

- (void)customSubviews
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if(![defaults objectForKey:@"userbaseindex"]){
        anonymousCount = 10000;
        [defaults setObject:[NSString stringWithFormat:@"%d", anonymousCount] forKey:@"userbaseindex"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        anonymousCount = [(NSString *)[defaults objectForKey:@"userbaseindex"] intValue];
        anonymousCount++;
        [defaults setObject:[NSString stringWithFormat:@"%d", anonymousCount] forKey:@"userbaseindex"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    //User默认值
    
    self.theUser.birthday = @"1990-07-01";
    self.theUser.startMenses = @"2013-07-18";
    self.theUser.mensesPeriod = @"4";
    self.theUser.totalPeriod = @"28";
    
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    self.birthdayTextFiled.inputView = self.datePicker;
    self.lastMensesTextField.inputView = self.datePicker;
    self.mensesPeriodTextField.keyboardType = UIKeyboardTypeDecimalPad;
    self.totalPeriodTextField.keyboardType = UIKeyboardTypeDecimalPad;
    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)finishSettingButtonClicked:(id)sender {
    [self sendUserBasicInfo];
//    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)datePickerValueChanged:(id)sender {
    if ([self.birthdayTextFiled isFirstResponder]) {
        self.birthdayTextFiled.text = [dateFormatter stringFromDate:self.datePicker.date];
    } else if ([self.lastMensesTextField isFirstResponder]) {
        self.lastMensesTextField.text = [dateFormatter stringFromDate:self.datePicker.date];
    }
}

- (IBAction)handleTap:(id)sender {
    [self.view findAndResignFirstResponder];
}

- (NSString *)addDaysToDate:(NSString *)date days:(NSString *)days{
    
    
    // Retrieve NSDate instance from stringified date presentation
    NSDate *dateFromString = [dateFormatter dateFromString:date];
    
    // Create and initialize date component instance
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:[days intValue]];
    
    // Retrieve date with increased days count
    NSDate *newDate = [[NSCalendar currentCalendar]
                       dateByAddingComponents:dateComponents
                       toDate:dateFromString options:0];
    
    return [dateFormatter stringFromDate:newDate];
}

- (void)sendUserBasicInfo
{
    self.theUser.birthday = self.birthdayTextFiled.text;
    self.theUser.startMenses = self.lastMensesTextField.text;
    self.theUser.mensesPeriod = self.mensesPeriodTextField.text;
    self.theUser.endMenses = [self addDaysToDate:self.theUser.startMenses days:self.theUser.mensesPeriod];
    self.theUser.totalPeriod = self.totalPeriodTextField.text;
    self.theUser.username = [NSString stringWithFormat:@"no_%d@163.com", anonymousCount];
    
    anonymousCount++;
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://10.242.8.72:8080/"]];
    [httpClient setParameterEncoding:AFFormURLParameterEncoding];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST"
                                                            path:@"http://10.242.8.72:8080/np-web/sync"
                                                      parameters:@{
                                                                @"email":self.theUser.username,
                                                                @"gender":self.theUser.gender,
                                                                @"birthday":self.theUser.birthday,
                                                                @"starttime":self.theUser.startMenses,
                                                                @"endtime":self.theUser.endMenses,
                                                                @"period":self.theUser.totalPeriod}];
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

- (void)viewDidUnload {
    [self setBirthdayTextFiled:nil];
    [self setLastMensesTextField:nil];
    [self setMensesPeriodTextField:nil];
    [self setTotalPeriodTextField:nil];
    [self setDatePicker:nil];
    [super viewDidUnload];
}

@end
