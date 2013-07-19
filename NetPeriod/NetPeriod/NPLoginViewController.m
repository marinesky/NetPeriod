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
@synthesize textLoginOnlyUsername;
@synthesize textLoginOnlyPassword;

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
    BOOL validateInput = [self validateInputEmail:[textUsername text]] && [self validateInputPassword:[textPassword text]];
    BOOL validateLoginOnlyInput = [self validateInputEmail:[textLoginOnlyUsername text]] && [self validateInputPassword:[textLoginOnlyPassword text]];
    NSString *username, *password;
    if (validateInput || validateLoginOnlyInput ) {
        if (validateInput){
            username = [textUsername text];
            password = [textPassword text];
        }
        else {
            username = [textLoginOnlyUsername text];
            password = [textLoginOnlyPassword text];
        }
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *userGender = [defaults valueForKey:@"gender"];
        if (!userGender){
            userGender = @"m";
        }
        NSLog(@"username:%@, password:%@, usergender:%@",username,password,userGender);
        RSA *rsa = [[RSA alloc] init];
        NSLog(@"rsa encrypted password:%@", [rsa encryptToString:password]);
        password = [rsa encryptToString:password];
        AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://10.242.8.72:8080/"]];
        [httpClient setParameterEncoding:AFFormURLParameterEncoding];
        NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST"
                                                                path:@"http://10.242.8.72:8080/np-web/register"
                                                          parameters:@{@"email":username, @"password":password, @"gender":userGender}];
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
    else {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"错误" message:@"请输入正确的邮箱和合理的密码" delegate:Nil cancelButtonTitle:@"确定" otherButtonTitles:Nil];
        [message show];
    }
}

- (IBAction)userLoginAction:(UIButton *)sender {
    BOOL validateInput = [self validateInputEmail:[textUsername text]] && [self validateInputPassword:[textPassword text]];
    BOOL validateLoginOnlyInput = [self validateInputEmail:[textLoginOnlyUsername text]] && [self validateInputPassword:[textLoginOnlyPassword text]];
    NSString *username, *password;
    if (validateInput || validateLoginOnlyInput ) {
          if (validateInput){
        username = [textUsername text];
        password = [textPassword text];
        }
        else {
            username = [textLoginOnlyUsername text];
            password = [textLoginOnlyPassword text];
        }
        NSLog(@"useaname:%@, password:%@", username, password);
        RSA *rsa = [[RSA alloc] init];
        NSLog(@"rsa encrypted password:%@", [rsa encryptToString:password]);
        password = [rsa encryptToString:password];
        AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://10.242.8.72:8080/"]];
        [httpClient setParameterEncoding:AFFormURLParameterEncoding];
        NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST"
                                                                path:@"http://10.242.8.72:8080/np-web/login"
                                                          parameters:@{@"email":username, @"password":password}];
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
    else {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"错误" message:@"请输入正确的邮箱和合理的密码" delegate:Nil cancelButtonTitle:@"确定" otherButtonTitles:Nil];
        [message show];
    }
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
    if (![self validateInputEmail:[textUsername text]]   && [sender tag] == 0 ) {
            emailInputHint.text = @"请输入合法的邮箱地址";
    } else {
        emailInputHint.text = @"";
    }
    [textPassword resignFirstResponder];
    if (![self validateInputPassword:[textPassword text]] && [sender tag] == 11) {
        passwordInputHint.text = @"密码长度至少为6";
    } else {
        passwordInputHint.text = @"";
    }
    [textLoginOnlyUsername resignFirstResponder];
    if (![self validateInputEmail:[textLoginOnlyUsername text]]   && [sender tag] == 0 ) {
        emailLoginOnlyInputHint.text = @"请输入合法的邮箱地址";
    } else {
        emailLoginOnlyInputHint.text = @"";
    }
    [textLoginOnlyPassword resignFirstResponder];
    if (![self validateInputPassword:[textLoginOnlyPassword text]] && [sender tag] == 11) {
        passwordLoginOnlyInputHint.text = @"密码长度至少为6";
    } else {
        passwordLoginOnlyInputHint.text = @"";
    }

}

- (IBAction)userGoBackAction:(UIBarButtonItem *)sender {
//    [self presentViewController:self.presentedViewController animated:YES completion:Nil];
    [self dismissViewControllerAnimated:YES completion:Nil];
}
@end
