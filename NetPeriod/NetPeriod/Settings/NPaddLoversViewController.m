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
@synthesize addedPartnerInfo;
@synthesize userAddedActionButton;

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
    switch ([[NSUserDefaults standardUserDefaults] integerForKey:@"loverStatus"]) {
        case addinglover:{
            NSString *loverEmail = [[NSUserDefaults standardUserDefaults] objectForKey:@"loverEmail"];
            addedPartnerInfo.text = [NSString stringWithFormat:@"您已经向%@发送请求，请等待确定。",loverEmail];
            addedPartnerInfo.numberOfLines = 0;
//            addedPartnerInfo.frame = CGRectMake(20,20,200,800);
            [addedPartnerInfo sizeToFit];
            [userAddedActionButton setTitle:@"重新添加" forState:UIControlStateNormal];
            [userAddedActionButton setTitle:@"重新添加" forState:UIControlStateSelected];
            [userAddedActionButton sizeToFit];
            userAddedActionButton.frame = CGRectMake(self.view.frame.size.width/2 - userAddedActionButton.frame.size.width/2,  userAddedActionButton.frame.origin.y, userAddedActionButton.frame.size.width, userAddedActionButton.frame.size.height);//fir to origin center.
            break;
        }
        default:
            break;
    }
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
        if ([username isEqualToString:[textLoverEmail text]]) {
            [self showResponseInfo:@"您要添加自己为伴侣？"];
            return ;
        }
        NSLog(@"username:%@, uid:%@, email:%@",username, uid,[textLoverEmail text]);
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
            if ([payload[@"status"] isEqualToString:@"Error"]){ //邀请失败
                if([payload[@"code"] isEqualToString:@"404"]) {
                    [self showResponseInfo:@"用户未注册，请向ta推荐本APP"];
                } else if([payload[@"code"] isEqualToString:@"500"]) {
                    [self showResponseInfo:@"抱歉，该用户已有伴侣"];
                } else {
                     [self showResponseInfo:@"用户未注册，请向ta推荐本APP"];
                }
                
            }
            else { // ok
    //            if ([[UIApplication sharedApplication].keyWindow.rootViewController isKindOfClass:[UITabBarController class]] )
    //            {
    //                ((UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController).selectedIndex = 3;
    //            }
    //            [self dismissViewControllerAnimated:YES completion:Nil];
                [self showResponseInfo:[[NSString alloc] initWithFormat:@"已向%@发送添加请求，请等待确认.",[textLoverEmail text]]];
                [[NSUserDefaults standardUserDefaults] setInteger:addinglover forKey:@"loverStatus"];
                [[NSUserDefaults standardUserDefaults] setObject:[textLoverEmail text] forKey:@"loverEmail"];
                UINavigationController *navController = self.navigationController;
                [navController popViewControllerAnimated:YES];
                //NSLog(@"added request success!");
            }
           
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
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
    [self setAddedPartnerInfo:nil];
    [self setUserAddedActionButton:nil];
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
