//
//  NPaddLoversViewController.h
//  NetPeriod
//
//  Created by Ye Xianjin on 7/20/13.
//  Copyright (c) 2013 NetEase. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NPaddLoversViewController : UIViewController
- (IBAction)userSendAddLoverAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *textLoverEmail;
@property (weak, nonatomic) IBOutlet UILabel *userEmailHint;

- (IBAction)backgroundClick:(id)sender;

@end
