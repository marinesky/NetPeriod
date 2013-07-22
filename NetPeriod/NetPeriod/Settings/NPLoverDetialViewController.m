//
//  NPLoverDetialViewController.m
//  NetPeriod
//
//  Created by Ye Xianjin on 7/21/13.
//  Copyright (c) 2013 NetEase. All rights reserved.
//

#import "NPLoverDetialViewController.h"
#import "CommonData.h"
#import "AFNetworking.h"
#import "KeychainItemWrapper.h"
#import "MBProgressHUD.h"

@interface NPLoverDetialViewController ()

@end

@implementation NPLoverDetialViewController
@synthesize selfDetailTableViewCell;
@synthesize loverDetailTableViewCell;

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
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userGender = [defaults valueForKey:@"gender"];
    if (!userGender){
        userGender = @"m";
    }
    userGender = [userGender uppercaseString];
    NSString *loverGender = [userGender isEqualToString:@"M"]?@"F":@"M";
    NSString *selfNickname = [defaults valueForKey:@"nickname"];
    selfNickname = selfNickname?selfNickname:@"ooxx";
    NSString *loverNickname = @"xxoo";
//    UIImageView *selfHeaderPictureView = [[UIImageView alloc]initWithFrame:
//                                          CGRectMake(selfDetailTableViewCell.frame.origin.x + 20, selfDetailTableViewCell.frame.origin.y,
//                                                     60, 75)];
//    UIImageView *loverHeaderPictureView = [[UIImageView alloc]initWithFrame:
//                                      CGRectMake(loverDetailTableViewCell.frame.origin.x + 20, loverDetailTableViewCell.frame.origin.y,
//                                                 60, 75)];
//    selfHeaderPictureView.image = [UIImage imageNamed:[userGender uppercaseString]];
//    loverHeaderPictureView.image = [UIImage imageNamed:[loverGender uppercaseString]];
//    [selfDetailTableViewCell addSubview:selfHeaderPictureView];
//    [loverDetailTableViewCell addSubview:loverHeaderPictureView];
    selfDetailTableViewCell.imageView.image   = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg", userGender]];
    loverDetailTableViewCell.imageView.image  = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg", loverGender]];
    selfDetailTableViewCell.textLabel.text = selfNickname;
    loverDetailTableViewCell.textLabel.text = loverNickname;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"解除" style:UIBarButtonItemStylePlain
                                                                                           target:self
                                                                                           action:@selector(userUntieAction)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self   setSelfDetailTableViewCell:nil];
    [self   setLoverDetailTableViewCell:nil];
    [super viewDidUnload];
}

- (void)userUntieAction {
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:BaseWebServerUrl]];
    [httpClient setParameterEncoding:AFFormURLParameterEncoding];
    KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"NetPeriod" accessGroup:nil];
    NSString * username = [keychain objectForKey:(id)CFBridgingRelease(kSecAttrAccount)];
    NSString * uid = [keychain objectForKey:(id)CFBridgingRelease(kSecValueData)];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST"
                                                            path:@"/np-web/untiepartner"
                                                      parameters:@{@"email":username, @"uid":uid}];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        // Print the response body in text
        //NSLog(@"Response: %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        id payload = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"Fetched: %@", payload);
        if ([payload[@"status"] isEqualToString:@"Error"]){ //确认失败
                [self showResponseInfo:@"解除失败"];
                [self.navigationController popViewControllerAnimated:YES];          
        }
        else { // 确认成功
                [self showResponseInfo:@"解除成功"];
                [[NSUserDefaults standardUserDefaults] setInteger:hasnolover forKey:@"loverStatus"];
                [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [self showResponseInfo:@"和服务器交互错误，请稍后"];
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
