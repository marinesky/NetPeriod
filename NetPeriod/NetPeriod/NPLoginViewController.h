//
//  NPLoginViewController.h
//  NetPeriod
//
//  Created by Ye Xianjin on 7/17/13.
//  Copyright (c) 2013 NetEase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "RSA.h"

@interface NPLoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *loginAndRegisterPasswordTextField;

@property (weak, nonatomic) IBOutlet UITextField *loginAndRegisterUsernameTextField;

@property (weak, nonatomic) IBOutlet UITextField *textUsername;

@property (weak, nonatomic) IBOutlet UITextField *textLoginOnlyUsername;

@property (weak, nonatomic) IBOutlet UITextField *textPassword;

@property (weak, nonatomic) IBOutlet UITextField *textLoginOnlyPassword;

@property (weak, nonatomic) IBOutlet UILabel *emailInputHint;

@property (weak, nonatomic) IBOutlet UILabel *passwordInputHint;

@property (weak, nonatomic) IBOutlet UIView *loginOnlyView;

@property (weak, nonatomic) IBOutlet UILabel *emailLoginOnlyInputHint;

@property (weak, nonatomic) IBOutlet UILabel *passwordLoginOnlyInputHint;

- (IBAction)userRegisterAction:(UIButton *)sender;
- (IBAction)userLoginAction:(UIButton *)sender;
- (IBAction)userRestPassword:(UIButton *)sender;
- (IBAction)backgroundClick:(id)sender;
- (IBAction)userGoBackAction:(UIBarButtonItem *)sender;


@end
