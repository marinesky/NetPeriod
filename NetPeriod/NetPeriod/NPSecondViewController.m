//
//  NPSecondViewController.m
//  NetPeriod
//
//  Created by Dafeng Jin on 13-7-14.
//  Copyright (c) 2013年 NetEase. All rights reserved.
//

#import "NPSecondViewController.h"
#import "NPLoginViewController.h"

@interface NPSecondViewController ()

@end

@implementation NPSecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonclicked:(id)sender {
    NPLoginViewController* loginController = [[NPLoginViewController alloc] initWithNibName:@"NPLoginViewController" bundle:Nil];
    //    [self.parentViewController addChildViewController:loginController];
    [self presentViewController:loginController animated:YES completion:Nil];
}
@end
