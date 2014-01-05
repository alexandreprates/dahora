//
//  NEPWorkDay.h
//  Da Hora
//
//  Created by Alexandre Prates on 16/12/13.
//  Copyright (c) 2013 MyAppLab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NEPUserSettings.h"

@interface NEPWorkDay : NSObject <NSCoding>

@property (nonatomic, strong) NSDate *beginning;
@property (nonatomic, strong) NSDate *ending;

+ (NEPWorkDay *)current;
+ (void)saveCurrent;
+ (void)resetCurrent;

+ (NSMutableArray *)history;
+ (void)addToHistory:(NEPWorkDay *)workday;
+ (void)saveHistory;

- (NSDate *)plannedEnding;
- (int)beginningMonth;
- (int)beginningYear;
- (NSTimeInterval)worktime;

- (NSString *)beginningLongDate;
- (NSString *)endingLongDate;
- (NSString *)beginningVerboseDate;
- (NSString *)endingVerboseDate;
- (NSString *)beginningHour;
- (NSString *)endingHour;
- (NSString *)workCountdown;
- (NSString *)allowanceCountdow;
- (NSString *)overtimeCountdown;

- (BOOL)started;

- (BOOL)onWork;
- (BOOL)onAllowance;
- (BOOL)onOvertime;

- (int)workDuration;
- (int)allowanceDuration;
- (int)overtimeDuration;

- (int)secondsInWork;
- (int)secondsInAllowance;
- (int)secondsInOvertime;

- (int)secondsToAllowance;
- (int)secondsToEnding;
- (int)secondsToOvertime;
- (int)secondsToOvertimeLimit;

@end
