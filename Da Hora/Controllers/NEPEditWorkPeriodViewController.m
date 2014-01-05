//
//  NEPEditWorkPeriodViewController.m
//  Da Hora
//
//  Created by Alexandre Prates on 29/12/13.
//  Copyright (c) 2013 MyAppLab. All rights reserved.
//

#import "NEPEditWorkPeriodViewController.h"

@interface NEPEditWorkPeriodViewController ()

@property (strong, nonatomic) NSDateFormatter *timeFormatter;

@end

@implementation NEPEditWorkPeriodViewController

- (void)viewDidLoad {
    _timeFormatter = [[NSDateFormatter alloc] init];
    [_timeFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [_timeFormatter setDateFormat:@"HH'h'mm"];
    NSLog(@"%@", _timePicker.locale.localeIdentifier);
}

- (void)viewDidAppear:(BOOL)animated {
    _infoCell.detailTextLabel.text = [_timeFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:_currentPeriod]];
    _timePicker.countDownDuration = _currentPeriod;
}

- (void)viewDidDisappear:(BOOL)animated {
    NSTimeInterval interval = _timePicker.countDownDuration;
    if (_delegate) [_delegate selectedTimeInterval:interval];
}

- (IBAction)valueChanged:(UIDatePicker *)sender {
    _infoCell.detailTextLabel.text = [_timeFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:sender.countDownDuration]];
}

#pragma mark - NEPTimeIntervalPickerProtocol

- (void)selectedTimeInterval:(NSTimeInterval)interval {
}

- (void)selectedDate:(NSDate *)date {
}

@end
