//
//  NPUser.h
//  NetPeriod
//
//  Created by Dafeng Jin on 13-7-20.
//  Copyright (c) 2013年 NetEase. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NPUser : NSObject

@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *gender;
@property (nonatomic, copy) NSString *birthday;
@property (nonatomic, copy) NSString *startMenses;
@property (nonatomic, copy) NSString *endMenses;
@property (nonatomic, copy) NSString *mensesPeriod;
@property (nonatomic, copy) NSString *totalPeriod;

@end
