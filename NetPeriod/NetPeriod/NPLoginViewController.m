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
@synthesize emailInputHint;
@synthesize passwordInputHint;
@synthesize loginOnlyView;
@synthesize emailLoginOnlyInputHint;
@synthesize passwordLoginOnlyInputHint;

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
    if ([self validateInputEmail:[textUsername text]] && [self validateInputPassword:[textPassword text]]) {
        ;
    }
}

- (IBAction)userLoginAction:(UIButton *)sender {
}

- (IBAction)userRestPassword:(UIButton *)sender {
    
}

- (BOOL)validateInputEmail:(NSString *)emailAddress {
    NSString *regexForEmailAddress = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailValidation = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regexForEmailAddress];
    return [emailValidation evaluateWithObject:emailAddress];
}

- (BOOL)validateInputPassword:(NSString *)password {
    return [password length] >= 6;
}

- (IBAction)backgroundClick:(id)sender {
    [textUsername resignFirstResponder];
    if (![self validateInputEmail:[textUsername text]]  /* && [sender tag] == 0 */) {
            emailInputHint.text = @"请输入合法的邮箱地址";
            emailLoginOnlyInputHint.text = @"请输入合法的邮箱地址";
    } else {
        emailInputHint.text = @"";
    }
    [textPassword resignFirstResponder];
    if (![self validateInputPassword:[textPassword text]] && [sender tag] == 11) {
        passwordInputHint.text = @"密码长度至少为6";
        passwordLoginOnlyInputHint.text = @"密码长度至少为6";
    } else {
        passwordInputHint.text = @"";
    }
}

- (IBAction)userGoBackAction:(UIBarButtonItem *)sender {
//    [self presentViewController:self.presentedViewController animated:YES completion:Nil];
    [self dismissViewControllerAnimated:YES completion:Nil];
}
@end
