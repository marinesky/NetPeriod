//
//  NPComposeViewController.m
//  NetPeriod
//
//  Created by Dafeng Jin on 13-7-18.
//  Copyright (c) 2013年 NetEase. All rights reserved.
//

#import "NPComposeViewController.h"
#import "AFNetworking.h"

@interface NPComposeViewController ()

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)postArticle
{
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://10.242.8.72:8080/"]];
    [httpClient setParameterEncoding:AFFormURLParameterEncoding];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST"
                                                            path:@"http://10.242.8.72:8080/np-web/newpost"
                                                      parameters:@{
                                    @"email":@"aa@163.com",
                                    @"uid":@"fdssfsfsdsad",
                                    @"title":@"告诉大家一个秘密",
                                    @"article":@"告诉大家一个秘密，告诉大家一个秘密，告诉大家一个秘密"
                                    }];
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

#pragma mark -
#pragma mark - Actions

- (IBAction)cancelEdit:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)postButtonClicked:(id)sender {
    [self postArticle];
}

@end
