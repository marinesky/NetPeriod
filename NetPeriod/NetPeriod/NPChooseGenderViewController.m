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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)chooseMale:(id)sender {
    NPSettingPeriodViewController *settingPeriodVC = [[NPSettingPeriodViewController alloc] initWithNibName:@"NPSettingPeriodViewController" bundle:nil];
    settingPeriodVC.theUser = [[NPUser alloc] init];
    settingPeriodVC.theUser.gender = @"m";
    [self.navigationController pushViewController:settingPeriodVC animated:YES];
}

- (IBAction)chooseFemale:(id)sender {
    NPSettingPeriodViewController *settingPeriodVC = [[NPSettingPeriodViewController alloc] initWithNibName:@"NPSettingPeriodViewController" bundle:nil];
    settingPeriodVC.theUser = [[NPUser alloc] init];
    settingPeriodVC.theUser.gender = @"f";
    [self.navigationController pushViewController:settingPeriodVC animated:YES];
}

- (IBAction)login:(id)sender {
    
}

@end
