//
//  NPInvitationRequestViewController.h
//  NetPeriod
//
//  Created by Ye Xianjin on 7/21/13.
//  Copyright (c) 2013 NetEase. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NPInvitationRequestViewController : UIViewController {
}
@property (weak, nonatomic) IBOutlet UILabel *invitationInfoText;
- (IBAction)userResponseAction:(UIButton *)sender;

@end
