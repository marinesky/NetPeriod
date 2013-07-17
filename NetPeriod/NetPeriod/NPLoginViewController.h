//
//  NPLoginViewController.h
//  NetPeriod
//
//  Created by Ye Xianjin on 7/17/13.
//  Copyright (c) 2013 NetEase. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NPLoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *textUsername;
@property (weak, nonatomic) IBOutlet UITextField *textPassword;
@property (weak, nonatomic) IBOutlet UILabel *emailInputHint;
@property (weak, nonatomic) IBOutlet UILabel *passwordInputHint;
- (IBAction)userRegisterAction:(UIButton *)sender;
- (IBAction)userLoginAction:(UIButton *)sender;
- (IBAction)userRestPassword:(UIButton *)sender;
- (IBAction)backgroundClick:(id)sender;
- (IBAction)userGoBackAction:(UIBarButtonItem *)sender;


@end
