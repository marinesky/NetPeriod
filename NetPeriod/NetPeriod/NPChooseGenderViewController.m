//
//  NPChooseGenderViewController.m
//  NetPeriod
//
//  Created by Dafeng Jin on 13-7-20.
//  Copyright (c) 2013年 NetEase. All rights reserved.
//

#import "NPChooseGenderViewController.h"
#import "NPSettingPeriodViewController.h"
#import "NPUser.h"
#import "NPRootTabViewController.h"
#import "NPLoginViewController.h"

@interface NPChooseGenderViewController ()

@end

@implementation NPChooseGenderViewController

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
    self.title = @"设置";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)chooseMale:(id)sender {
    NPUser *user = [[NPUser alloc] init];
    user.gender = @"m";
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSDate date] forKey:@"firstRun"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    ((UITabBarItem *)((UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController).tabBar.items[1]).enabled = NO;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)chooseFemale:(id)sender {
    NPSettingPeriodViewController *settingPeriodVC = [[NPSettingPeriodViewController alloc] initWithNibName:@"NPSettingPeriodViewController" bundle:nil];
    settingPeriodVC.theUser = [[NPUser alloc] init];
    settingPeriodVC.theUser.gender = @"f";
    [self.navigationController pushViewController:settingPeriodVC animated:YES];
}

- (IBAction)login:(id)sender {
    NPLoginViewController *loginVC = [[NPLoginViewController alloc] init];
    loginVC.redirectType = LoginRedirectFromUserGuide;
    loginVC.delegate = (NPRootTabViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    [loginVC.view addSubview:loginVC.loginOnlyView];
    loginVC.loginAndRegisterUsernameTextField.hidden = YES;
    loginVC.loginAndRegisterPasswordTextField.hidden = YES;
    [self presentViewController:loginVC animated:YES completion:nil];
}

@end
