//
//  NPAppDelegate.m
//  NetPeriod
//
//  Created by Dafeng Jin on 13-7-14.
//  Copyright (c) 2013年 NetEase. All rights reserved.
//

#import "NPAppDelegate.h"
#import <Parse/Parse.h>

@implementation NPAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navi_bar.png"] forBarMetrics:UIBarMetricsDefault];
    UIImage *tabBackground = [[UIImage imageNamed:@"tab_bar"]
                              resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [[UITabBar appearance] setBackgroundImage:tabBackground];
//    [[UITabBar appearance] setSelectionIndicatorImage:
//     [UIImage imageNamed:@"tab_select_indicator"]];
//    [[UITabBar appearance] setSelectionIndicatorImage:nil];
//    [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
    
    [[UIBarButtonItem appearance] setTintColor:[UIColor colorWithRed:29.0/255.0 green:196.0/255.0 blue:135.0/255.0 alpha:1.0]];
    // ****************************************************************************
    // Uncomment and fill in with your Parse credentials:
    [Parse setApplicationId:@"8s1WvVOoNPqkPcrlKHSv7VNJyIEYYsHxU75uAUwn" clientKey:@"nOV2UAnzYP89bHJ7F4v2Alnr4tBH7QWrZPn83Xah"];
    // ****************************************************************************
    
    // Override point for customization after application launch.
    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound];
    
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    if (error.code == 3010) {
        NSLog(@"Push notifications are not supported in the iOS Simulator.");
    } else {
        // show some alert or otherwise handle the failure to register.
        NSLog(@"application:didFailToRegisterForRemoteNotificationsWithError: %@", error);
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
}

@end
