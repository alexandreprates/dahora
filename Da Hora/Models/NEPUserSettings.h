//
//  NEPUserSettings.h
//  Da Hora
//
//  Created by Alexandre Prates on 14/12/13.
//  Copyright (c) 2013 MyAppLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NEPUserSettings : NSObject <NSCoding>

@property NSTimeInterval workTime;

@property int beforehandSeconds;

@property BOOL alertBefore;
@property BOOL alertOnTime;
@property BOOL alertAfter;
@property BOOL alertOvertime;

+ (NEPUserSettings *)settings;
+ (void)saveSettings;

@end
