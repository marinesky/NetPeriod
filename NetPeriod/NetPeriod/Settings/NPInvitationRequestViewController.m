//
//  NPInvitationRequestViewController.m
//  NetPeriod
//
//  Created by Ye Xianjin on 7/21/13.
//  Copyright (c) 2013 NetEase. All rights reserved.
//

#import "NPInvitationRequestViewController.h"
#import "AFNetworking.h"
#import "CommonData.h"
#import "KeychainItemWrapper.h"
#import "MBProgressHUD.h"

@interface NPInvitationRequestViewController ()

@end

@implementation NPInvitationRequestViewController
@synthesize invitationInfoText;
NSString *invitationEmail;

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
    invitationEmail = [[NSUserDefaults standardUserDefaults] objectForKey:@"invitationEmail"];
    invitationEmail = invitationEmail?invitationEmail:@"aa@163.com";
    NSString *infoText = [NSString stringWithFormat:@"用户%@向您发起了添加伴侣请求，请确认是否同意。", invitationEmail];
    invitationInfoText.numberOfLines = 0;
    invitationInfoText.text = infoText;
    [invitationInfoText sizeToFit];
} 

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setInvitationInfoText:nil];
    [super viewDidUnload];
}
- (IBAction)userResponseAction:(UIButton *)sender {
    [sender setEnabled:NO];
    NSString *confirm = [sender tag]?@"yes":@"no";
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:BaseWebServerUrl]];
    [httpClient setParameterEncoding:AFFormURLParameterEncoding];
    KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"NetPeriod" accessGroup:nil];
    NSString * username = [keychain objectForKey:(id)CFBridgingRelease(kSecAttrAccount)];
    NSString * uid = [keychain objectForKey:(id)CFBridgingRelease(kSecValueData)];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST"
                                                            path:@"/np-web/acceptpartner"
                                                      parameters:@{@"email":username, @"uid":uid, @"partneremail":invitationEmail, @"confirm":confirm}];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        // Print the response body in text
        //NSLog(@"Response: %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        id payload = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"Fetched: %@", payload);
        if ([payload[@"status"] isEqualToString:@"Error"]){ //确认失败
            if ([sender tag]) {
                [self showResponseInfo:@"确认失败，对方已有伴侣"];
                [[NSUserDefaults standardUserDefaults] setInteger:hasnolover forKey:@"loverStatus"];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else {
                [self showResponseInfo:@"拒绝发生错误，请稍后再试"];
            }
        }
        else { // 确认成功
            if ([sender tag]) {
                [self showResponseInfo:@"确认成功"];
                [[NSUserDefaults standardUserDefaults] setInteger:addedlover forKey:@"loverStatus"];
                [[NSUserDefaults standardUserDefaults] setObject:invitationEmail forKey:@"loverEmail"];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else {
                [self showResponseInfo:@"拒绝成功"];
                [[NSUserDefaults standardUserDefaults] setInteger:hasnolover forKey:@"loverStatus"];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
     [sender setEnabled:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [self showResponseInfo:@"和服务器交互错误，请稍后"];
        [sender setEnabled:YES];
    }];
    [operation start];

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
@end
