//
//  NPUser.m
//  NetPeriod
//
//  Created by Dafeng Jin on 13-7-20.
//  Copyright (c) 2013年 NetEase. All rights reserved.
//

#import "NPUser.h"


@implementation NPUser
@synthesize username;//the user's emailname
@synthesize uid;//token from server after login
@synthesize gender;//user's gender after setting or sync from server if user directly logged in
@synthesize nickname;//user's nickname for his/her forum name
@synthesize loverStatus;//user's love status:hasnolover,addinglover,addedlover,hasinvitation
@synthesize loggedIn;//bool value to detect user has logged in or not
@synthesize mensesPeriod;//user's menses period
@synthesize totalPeriod;//user's total period

- (id)init {
    self = [super init];
    if (self) {
        defaults = [NSUserDefaults standardUserDefaults];
        keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"NetPeriod" accessGroup:nil];
    }
    return self;
}

- (NSString *) gender {
  return [defaults valueForKey:@"gender"];
}

- (void) setGender:(NSString *)genderValue {
    [defaults setObject:genderValue forKey:@"gender"];
}

- (NSString *) username {
    return [keychain objectForKey:(id)CFBridgingRelease(kSecAttrAccount)];
}

- (void) setUsername:(NSString *)usernameValue {
  [keychain setObject:usernameValue forKey:(id)CFBridgingRelease(kSecAttrAccount)];
}

- (NSString *) uid {
    return [keychain objectForKey:(id)CFBridgingRelease(kSecValueData)];
}

- (void) setUid:(NSString *)uidValue {
   [keychain setObject:uidValue forKey:CFBridgingRelease(kSecValueData)];
}

- (NSString *) nickname {
    return [defaults valueForKey:@"nickname"];
}

- (void) setNickname:(NSString *)nicknameValue {
    [defaults setObject:nicknameValue forKey:@"nickname"];
}

- (NSString *) loverStatus {
    return [defaults valueForKey:@"loverStatus"];
}

- (void) setLoverStatus:(NSString *)loverStatusValue {
    [defaults setObject:loverStatusValue forKey:@"loverStatus"];
}

- (BOOL) loggedIn {
  return [defaults boolForKey:@"loggedin"];
}

- (void) setLoggedIn:(BOOL)loggedInValue {
    [defaults setBool:loggedInValue forKey:@"loggedin"];
}

- (NSString *) loverEmail {
  return [defaults valueForKey:@"loverEmail"];
}

- (void) setLoverEmail:(NSString *)loverEmailValue {
    [defaults setObject:loverEmailValue forKey:@"loverEmail"];
}

- (NSString *) mensesPeriod {
  return [defaults valueForKey:@"mensesPeriod"];
}

- (void) setMensesPeriod:(NSString *)mensesPeriodValue {
    [defaults setObject:mensesPeriodValue forKey:@"mensesPeriod"];
}


- (NSString *) totalPeriod {
  return [defaults valueForKey:@"totalPeriod"];
}

- (void) settotalPeriod:(NSString *)totalPeriodValue {
    [defaults setObject:totalPeriodValue forKey:@"totalPeriod"];
}
@end
