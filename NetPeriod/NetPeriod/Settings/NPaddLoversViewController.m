//
//  NPaddLoversViewController.m
//  NetPeriod
//
//  Created by Ye Xianjin on 7/20/13.
//  Copyright (c) 2013 NetEase. All rights reserved.
//

#import "NPaddLoversViewController.h"
#import "AFNetworking.h"
#import "CommonData.h"
#import "KeychainItemWrapper.h"
#import "MBProgressHUD.h"

@interface NPaddLoversViewController ()

@end

@implementation NPaddLoversViewController
@synthesize textLoverEmail;
@synthesize userEmailHint;

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

- (IBAction)userSendAddLoverAction:(UIButton *)sender {
    NSString *regexForEmailAddress = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailValidation = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regexForEmailAddress];
    if ([emailValidation evaluateWithObject:[textLoverEmail text]] ){
        AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:BaseWebServerUrl]];
        [httpClient setParameterEncoding:AFFormURLParameterEncoding];
        KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"NetPeriod" accessGroup:nil];
        NSString * username = [keychain objectForKey:(id)CFBridgingRelease(kSecAttrAccount)];
        NSString * uid = [keychain objectForKey:(id)CFBridgingRelease(kSecValueData)];
        NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST"
                                                                path:@"/np-web/addpartner"
                                                          parameters:@{@"email":username, @"uid":uid, @"partneremail":[textLoverEmail text]}];
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            // Print the response body in text
            //NSLog(@"Response: %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
            id payload = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"Fetched: %@", payload);
            if ([payload[@"status"] isEqualToString:@"Error"]){
            }
            else { // ok
    //            if ([[UIApplication sharedApplication].keyWindow.rootViewController isKindOfClass:[UITabBarController class]] )
    //            {
    //                ((UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController).selectedIndex = 3;
    //            }
    //            [self dismissViewControllerAnimated:YES completion:Nil];
                [self.navigationController popViewControllerAnimated:YES];
                //NSLog(@"added request success!");
            }
           
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            NSLog(@"Error: %@", error);
            [self showResponseInfo:@"和服务器的交互发生错误"];
        }];
        [operation start];
    } else {
        [self showResponseInfo:@"请输入合法的邮箱地址"];
    }
}
-(void)showResponseInfo : (NSString *)infoString {
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.mode = MBProgressHUDModeText;
    //HUD.delegate = self;
    HUD.labelText = infoString;
    [HUD show:YES];
    [HUD hide:YES afterDelay:0.5];
}

- (void)viewDidUnload {
    [self setTextLoverEmail:nil];
    [self setUserEmailHint:nil];
    [super viewDidUnload];
}
- (IBAction)backgroundClick:(id)sender {
    [textLoverEmail resignFirstResponder];
    NSString *regexForEmailAddress = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailValidation = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regexForEmailAddress];
    if (![emailValidation evaluateWithObject:[textLoverEmail text]]) {
        userEmailHint.text = @"请输入合法的邮箱地址";
    }
    else {
        userEmailHint.text =@"";
    }
}
@end
