//
//  NEPWorkDay.m
//  Da Hora
//
//  Created by Alexandre Prates on 16/12/13.
//  Copyright (c) 2013 MyAppLab. All rights reserved.
//

#import "NEPWorkDay.h"

static NEPWorkDay *currentWorkDay;
static NSMutableArray *history;

//const int allowanceSeconds = 60;
const int allowanceSeconds = 900;
//const int maximumOvertime = 60;
const int maximumOvertime = 7200;

@interface NEPWorkDay ()

@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) NSDateFormatter *timerFormatter;

@end

@implementation NEPWorkDay

#pragma mark Class methods

+ (NEPWorkDay *)current {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentWorkDay"];
    currentWorkDay = [NSKeyedUnarchiver unarchiveObjectWithData:data];

    if (!currentWorkDay) currentWorkDay = [[NEPWorkDay alloc] init];
    return currentWorkDay;
}

+ (void)saveCurrent {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:currentWorkDay];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"currentWorkDay"];
}

+ (void)resetCurrent {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"currentWorkDay"];
    currentWorkDay = [[NEPWorkDay alloc] init];
}

+ (NSMutableArray *)history {
    NSArray *userDirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDir = [userDirs objectAtIndex:0];
    NSString *fileName = [NSString stringWithFormat:@"%@/History", documentDir];
    
    history = [NSKeyedUnarchiver unarchiveObjectWithFile:fileName];
    if (!history) history = [[NSMutableArray alloc] init];
    return history;
}

+ (void)addToHistory:(NEPWorkDay *)workday {
    [[self history] addObject:workday];
    [self saveHistory];
}

+ (void)saveHistory {
    NSArray *userDirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDir = [userDirs objectAtIndex:0];
    NSString *fileName = [NSString stringWithFormat:@"%@/History", documentDir];
    
    [NSKeyedArchiver archiveRootObject:history toFile:fileName];
}

#pragma mark getters override

- (NSDateFormatter *) dateFormatter {
    if (!_dateFormatter) _dateFormatter = [[NSDateFormatter alloc] init];
    return _dateFormatter;
}

- (NSDateFormatter *)timerFormatter {
    if (!_timerFormatter) {
        _timerFormatter = [[NSDateFormatter alloc] init];
        [_timerFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    }
    return _timerFormatter;
}

- (NSDate *)beginning {
    return [self roundedDate:_beginning];
}

- (NSDate *)ending {
    return [self roundedDate:_ending];
}

#pragma mark Public methods

- (NSDate *)plannedEnding {
    return [self.beginning dateByAddingTimeInterval:NEPUserSettings.settings.workTime];
}

- (int)beginningMonth {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSCalendarUnit units = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *components = [calendar components:units fromDate:self.beginning];
    return (int) [components month];
}

- (int)beginningYear {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSCalendarUnit units = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *components = [calendar components:units fromDate:self.beginning];
    return (int) [components year];
}

- (NSTimeInterval)worktime {
    NSTimeInterval interval;
    if (!_ending) {
        interval = [self.beginning timeIntervalSinceNow];
    } else {
        interval = [self.beginning timeIntervalSinceDate:self.ending];
    }
    
    return interval;
}

- (NSString *)beginningLongDate {
    [self.dateFormatter setDateFormat:@"dd/MM/yyy HH:mm"];
    return [self.dateFormatter stringFromDate:self.beginning];
}

- (NSString *)endingLongDate {
    [self.dateFormatter setDateFormat:@"dd/MM/yyy HH:mm"];
    NSDate *endDate;
    if (_ending) {
        endDate = self.ending;
    }
    else {
        endDate = [self plannedEnding];
    }
    return [self.dateFormatter stringFromDate:endDate];
}

- (NSString *)beginningVerboseDate {
    [self.dateFormatter setDateFormat:@"EEEE, dd 'de' MMMM"];
    return [self.dateFormatter stringFromDate:self.beginning];
}

- (NSString *)endingVerboseDate {
    [self.dateFormatter setDateFormat:@"EEEE, dd 'de' MMMM"];
    NSDate *endDate;
    if (_ending) {
        endDate = self.ending;
    }
    else {
        endDate = [self plannedEnding];
    }
    return [self.dateFormatter stringFromDate:endDate];
}

- (NSString *)beginningHour {
    [self.dateFormatter setDateFormat:@"HH:mm"];
    return [self.dateFormatter stringFromDate:self.beginning];
}

- (NSString *)endingHour {
    [self.dateFormatter setDateFormat:@"HH:mm"];
    NSDate *endDate;
    if (_ending) {
        endDate = self.ending;
    }
    else {
        endDate = [self plannedEnding];
    }
    return [self.dateFormatter stringFromDate:endDate];
}

- (NSString *)workCountdown {
    int interval = self.workDuration - self.secondsInWork;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    [self.timerFormatter setDateFormat:@"HH:mm:ss"];
    return [self.timerFormatter stringFromDate:date];
}

- (NSString *)allowanceCountdow {
    int interval = self.allowanceDuration - self.secondsInAllowance;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    [self.timerFormatter setDateFormat:@"HH:mm:ss"];
    return [self.timerFormatter stringFromDate:date];
}

- (NSString *)overtimeCountdown {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.secondsInOvertime];
    [self.timerFormatter setDateFormat:@"HH:mm:ss"];
    return [self.timerFormatter stringFromDate:date];
}

- (BOOL)started {
    return _beginning != nil;
}

- (BOOL)onWork {
    NSDate *workLimit = [self.beginning dateByAddingTimeInterval:NEPUserSettings.settings.workTime - allowanceSeconds];
    int workSeconds = (int) [workLimit timeIntervalSince1970];
    int current = (int) [[NSDate date] timeIntervalSince1970];
    return workSeconds > current;
}

- (BOOL)onAllowance {
    NSDate *workLimit = [self.beginning dateByAddingTimeInterval:NEPUserSettings.settings.workTime - allowanceSeconds];
    NSDate *allowanceLimit = [self.beginning dateByAddingTimeInterval:NEPUserSettings.settings.workTime + allowanceSeconds];
    int workSeconds = (int) [workLimit timeIntervalSince1970];
    int allowanceSeconds = (int) [allowanceLimit timeIntervalSince1970];
    int current = (int) [[NSDate date] timeIntervalSince1970];
    return (current >= workSeconds) && (current <= allowanceSeconds);
}

- (BOOL)onOvertime {
    NSDate *workLimit = [self.beginning dateByAddingTimeInterval:NEPUserSettings.settings.workTime + allowanceSeconds];
    int workSeconds = (int) [workLimit timeIntervalSince1970];
    int current = (int) [[NSDate date] timeIntervalSince1970];
    return workSeconds > current;
}

- (int)workDuration {
    return NEPUserSettings.settings.workTime - allowanceSeconds;
}

- (int)allowanceDuration {
    return allowanceSeconds * 2;
}

- (int)overtimeDuration {
    return maximumOvertime;
}

- (int)secondsInWork {
    return (int) [[NSDate date] timeIntervalSinceDate:self.beginning];
}

- (int)secondsInAllowance {
    int worktime = NEPUserSettings.settings.workTime;
    return self.secondsInWork - (worktime - allowanceSeconds);
}

- (int)secondsInOvertime {
    int worktime = NEPUserSettings.settings.workTime;
    return self.secondsInWork - (worktime + allowanceSeconds);
}

- (int)secondsToAllowance {
    return self.workDuration - self.secondsInWork;
}

- (int)secondsToEnding {
    return self.workDuration + allowanceSeconds - self.secondsInWork;
}

- (int)secondsToOvertime {
    return self.workDuration + (allowanceSeconds * 2) - self.secondsInWork;
}

- (int)secondsToOvertimeLimit {
    return self.workDuration + (allowanceSeconds * 2) + maximumOvertime - self.secondsInWork;
}

#pragma mark Private methods

- (NSDate *)minimumToAllowance {
    int interval = NEPUserSettings.settings.workTime - allowanceSeconds;
    return [self.beginning dateByAddingTimeInterval:interval];
}

- (NSDate *)overtimeBeginning {
    int interval = NEPUserSettings.settings.workTime + allowanceSeconds;
    return [self.beginning dateByAddingTimeInterval:interval];
}

- (NSDate *)overtimeMax {
    int interval = NEPUserSettings.settings.workTime + maximumOvertime;
    return [self.beginning dateByAddingTimeInterval:interval];
}

- (NSDate *)roundedDate:(NSDate *)date {
    NSTimeInterval time = floor([date timeIntervalSinceReferenceDate] / 60.0) * 60.0;
    return  [NSDate dateWithTimeIntervalSinceReferenceDate:time];
}

#pragma mark NSCoding delegate

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    
    if (self) {
        _beginning = [aDecoder decodeObjectForKey:@"beginning"];
        _ending    = [aDecoder decodeObjectForKey:@"ending"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_beginning forKey:@"beginning"];
    [aCoder encodeObject:_ending forKey:@"ending"];
}

@end
