//
//  NPSettingViewController.h
//  NetPeriod
//
//  Created by Ye Xianjin on 7/20/13.
//  Copyright (c) 2013 NetEase. All rights reserved.
//

#import "IASKAppSettingsViewController.h"

@interface NPSettingViewController : IASKAppSettingsViewController <IASKSettingsDelegate>{
    
}

- (void)didReceiveRequest:(NSString *)type email:(NSString *)email;

@end
