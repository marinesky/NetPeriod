//
//  NPUser.h
//  NetPeriod
//
//  Created by Dafeng Jin on 13-7-20.
//  Copyright (c) 2013年 NetEase. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KeychainItemWrapper.h"

@interface NPUser : NSObject {
    NSUserDefaults *defaults;
    KeychainItemWrapper *keychain;
}

@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *gender;
@property (nonatomic) BOOL     loggedIn;
@property (nonatomic, assign) NSInteger loverStatus;
@property (nonatomic, copy) NSString *birthday;
@property (nonatomic, copy) NSString *startMenses;
@property (nonatomic, copy) NSString *endMenses;
@property (nonatomic, copy) NSString *mensesPeriod;
@property (nonatomic, copy) NSString *totalPeriod;
@property (nonatomic, copy) NSString *loverEmail;


@end
