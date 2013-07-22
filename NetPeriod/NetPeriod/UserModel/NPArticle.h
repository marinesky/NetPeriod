//
//  NPArticle.h
//  NetPeriod
//
//  Created by Dafeng Jin on 13-7-21.
//  Copyright (c) 2013年 NetEase. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NPArticle : NSObject

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *date;
@property (copy, nonatomic) NSString *content;
@property (copy, nonatomic) NSString *commentNum;
@property (copy, nonatomic) NSArray *comments;
@property (copy, nonatomic) NSString *topicId;

@end
