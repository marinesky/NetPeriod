//
//  NPComposeViewController.m
//  NetPeriod
//
//  Created by Dafeng Jin on 13-7-18.
//  Copyright (c) 2013年 NetEase. All rights reserved.
//

#import "NPComposeViewController.h"
#import "AFNetworking.h"
#import <QuartzCore/QuartzCore.h>
#import "MBProgressHUD.h"

@interface NPComposeViewController () <MBProgressHUDDelegate>{
    MBProgressHUD *HUD;
}

@property (weak, nonatomic) IBOutlet UITextField *titleTextfield;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;

@end

@implementation NPComposeViewController

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
    self.contentTextView.layer.borderWidth = 0.8;
    self.contentTextView.layer.borderColor = [UIColor colorWithRed:29.0/255.0 green:196.0/255.0 blue:135.0/255.0 alpha:0.5].CGColor;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)postArticle
{
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://192.168.130.50:8080/"]];
    [httpClient setParameterEncoding:AFFormURLParameterEncoding];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST"
                                                            path:@"http://192.168.130.50:8080/np-web/newpost"
                                                      parameters:@{
                                    @"email":@"aa@163.com",
                                    @"uid":@"fdssfsfsdsad",
                                    @"title":self.titleTextfield.text,
                                    @"article":self.contentTextView.text
                                    }];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        // Print the response body in text
        NSLog(@"Response: %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        [self dismissModalViewControllerAnimated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    [operation start];
}

#pragma mark -
#pragma mark - Actions

- (IBAction)handleTap:(id)sender {
    [self.titleTextfield resignFirstResponder];
    [self.contentTextView resignFirstResponder];
}

- (IBAction)cancelEdit:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)postButtonClicked:(id)sender {
    if ([self.titleTextfield.text isEqualToString:@""] || [self.contentTextView.text isEqualToString:@""]) {
        [self showErrorInfo];
    }
    [self postArticle];
}

- (void)showErrorInfo {
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.mode = MBProgressHUDModeText;
    HUD.delegate = self;
    HUD.labelText = @"标题和内容都不能为空，谢谢！";
    [HUD show:YES];
    [HUD hide:YES afterDelay:1];
}

#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
	// Remove HUD from screen when the HUD was hidded
	[HUD removeFromSuperview];
	HUD = nil;
}

- (void)viewDidUnload {
    [self setTitleTextfield:nil];
    [self setContentTextView:nil];
    [super viewDidUnload];
}
@end
