//
//  NEPAppDelegate.m
//  Da Hora
//
//  Created by Alexandre Prates on 14/12/13.
//  Copyright (c) 2013 MyAppLab. All rights reserved.
//

#import "NEPAppDelegate.h"
#import "NEPWorkDay.h"
#import "NEPNoWorkingViewController.h"
#import "NEPWorkingViewController.h"

@implementation NEPAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication]registerForRemoteNotificationTypes: UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound];
//    self.window.tintColor = [UIColor colorWithRed:0.26 green:0.26 blue:0.26 alpha:1.0];
    
    return YES;
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    UIApplicationState state = [application applicationState];
    if (state == UIApplicationStateActive) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Atenção" message:notification.alertBody delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    application.applicationIconBadgeNumber = 0;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    application.applicationIconBadgeNumber = 0;
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [NEPWorkDay saveCurrent];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [NEPWorkDay saveCurrent];
}

@end
