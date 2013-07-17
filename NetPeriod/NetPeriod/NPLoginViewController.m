//
//  NPLoginViewController.m
//  NetPeriod
//
//  Created by Ye Xianjin on 7/17/13.
//  Copyright (c) 2013 NetEase. All rights reserved.
//

#import "NPLoginViewController.h"

@interface NPLoginViewController ()

@end

@implementation NPLoginViewController
@synthesize textUsername;
@synthesize textPassword;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSLog(@"Login view controller inits!");
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

- (IBAction)userRegisterAction:(UIButton *)sender {
}

- (IBAction)userLoginAction:(UIButton *)sender {
}

- (IBAction)userRestPassword:(UIButton *)sender {
}

- (IBAction)backgroundClick:(id)sender {
    [textUsername resignFirstResponder];
    [textPassword resignFirstResponder];
//    NSLog(@"password:%@", textPassword.text);
    
}

- (IBAction)userGoBackAction:(UIBarButtonItem *)sender {
//    [self presentViewController:self.presentedViewController animated:YES completion:Nil];
    [self dismissViewControllerAnimated:YES completion:Nil];
}
@end
