//
//  NPUser.m
//  NetPeriod
//
//  Created by Dafeng Jin on 13-7-20.
//  Copyright (c) 2013年 NetEase. All rights reserved.
//

#import "NPUser.h"
#import "AFNetworking.h"
#import "Md5.h"

@implementation NPUser
@synthesize username;//the user's emailname
@synthesize uid;//token from server after login
@synthesize gender;//user's gender after setting or sync from server if user directly logged in
@synthesize nickname;//user's nickname for his/her forum name
@synthesize loverStatus;//user's love status:hasnolover,addinglover,addedlover,hasinvitation
@synthesize loggedIn;//bool value to detect user has logged in or not
@synthesize mensesPeriod;//user's menses period
@synthesize totalPeriod;//user's total period
@synthesize startMenses;
@synthesize endMenses;
@synthesize loverEmail;
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

- (NSInteger ) loverStatus {
    return [defaults integerForKey:@"loverStatus"];
}

- (void) setLoverStatus:(NSInteger )loverStatusValue {
    [defaults setInteger:loverStatusValue forKey:@"loverStatus"];
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
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self syncUserInfo];
}


- (NSString *) totalPeriod {
    return [defaults valueForKey:@"totalPeriod"];
}

- (void) setTotalPeriod:(NSString *)totalPeriodValue {
    [defaults setObject:totalPeriodValue forKey:@"totalPeriod"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self syncUserInfo];
}

- (NSString *) startMenses {
    return [defaults valueForKey:@"startMense"];
}

- (void) setStartMenses:(NSString *)startMensesValue {
    [defaults setObject:startMensesValue forKey:@"startMense"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self syncUserInfo];
}

- (NSString *) endMenses {
    return [defaults valueForKey:@"endMense"];
}

- (void) setEndMenses:(NSString *)endMensesValue {
    [defaults setObject:endMensesValue forKey:@"endMense"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self syncUserInfo];
}

- (void)syncUserInfo
{
    NSLog(@"%@ - %@ - %@ - %@ - %@ - %@", self.username, self.gender, self.birthday, self.startMenses, self.endMenses, self.totalPeriod);
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://192.168.130.50:8080/"]];
    [httpClient setParameterEncoding:AFFormURLParameterEncoding];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST"
                                                            path:@"http://192.168.130.50:8080/np-web/sync"
                                                      parameters:@{
                                    @"email":self.username?self.username:@"",
                                    @"gender":self.gender?self.gender:@"",
                                    @"birthday":self.birthday?self.birthday:@"",
                                    @"starttime":self.startMenses?self.startMenses:@"",
                                    @"endtime":self.endMenses?self.endMenses:@"",
                                    @"period":self.totalPeriod?self.totalPeriod:@"",
                                    @"channels":[NSString stringWithFormat:@"user%@", [Md5 encode:self.username]]}];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        // Print the response body in text
        NSLog(@"Response: %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    [operation start];

}
@end
