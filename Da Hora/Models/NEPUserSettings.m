//
//  NEPUserSettings.m
//  Da Hora
//
//  Created by Alexandre Prates on 14/12/13.
//  Copyright (c) 2013 MyAppLab. All rights reserved.
//

#import "NEPUserSettings.h"

static NEPUserSettings *currentSettings;

@implementation NEPUserSettings

- (void)defaultSettings {
    _workTime    = 35280;
    _beforehandSeconds = 300;
    _alertBefore   = true;
    _alertOnTime   = true;
    _alertAfter    = true;
    _alertOvertime = true;
}

#pragma mark - NSCoding Protocol

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    
    if (self) {
        _workTime          = [aDecoder decodeDoubleForKey:@"dayWorkingTime"];
        _beforehandSeconds = [aDecoder decodeIntForKey:@"beforehandSeconds"];
        _alertBefore       = [aDecoder decodeBoolForKey:@"alertBefore"];
        _alertOnTime       = [aDecoder decodeBoolForKey:@"alertOnTime"];
        _alertAfter        = [aDecoder decodeBoolForKey:@"alertAfter"];
        _alertOvertime     = [aDecoder decodeBoolForKey:@"alertOvertime"];
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeDouble:_workTime forKey:@"dayWorkingTime"];
    [aCoder encodeInt:_beforehandSeconds forKey:@"beforehandSeconds"];
    [aCoder encodeBool:_alertBefore forKey:@"alertBefore"];
    [aCoder encodeBool:_alertOnTime forKey:@"alertOnTime"];
    [aCoder encodeBool:_alertAfter forKey:@"alertAfter"];
    [aCoder encodeBool:_alertOvertime forKey:@"alertOvertime"];
}

#pragma mark - Class Methods

+ (NEPUserSettings *)settings {
    if (!currentSettings) {
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"userSetting"];
        currentSettings = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    if (!currentSettings) {
        currentSettings = [[NEPUserSettings alloc] init];
        [currentSettings defaultSettings];
    }
    
    return currentSettings;
}

+ (void)saveSettings {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:currentSettings];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"userSetting"];
}

@end
