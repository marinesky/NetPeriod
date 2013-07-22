//
//  NPPushNotificationViewController.h
//  NetPeriod
//
//  Created by Dafeng Jin on 13-7-18.
//  Copyright (c) 2013年 NetEase. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NPPushNotificationViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

- (void)handlePushNotification:(NSDictionary *)userInfo;

@end
