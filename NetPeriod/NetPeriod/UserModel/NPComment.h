//
//  NPComment.h
//  NetPeriod
//
//  Created by Dafeng Jin on 13-7-21.
//  Copyright (c) 2013年 NetEase. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NPComment : NSObject

@property (copy, nonatomic) NSString *pkid;
@property (copy, nonatomic) NSString *replay;
@property (copy, nonatomic) NSString *topicId;
@property (copy, nonatomic) NSString *email;
@property (copy, nonatomic) NSString *replyTime;
@property (copy, nonatomic) NSString *username;

@end
