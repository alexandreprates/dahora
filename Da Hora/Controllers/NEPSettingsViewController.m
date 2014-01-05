//
//  NEPSettingsViewController.m
//  Da Hora
//
//  Created by Alexandre Prates on 14/12/13.
//  Copyright (c) 2013 MyAppLab. All rights reserved.
//

#import "NEPSettingsViewController.h"
#import "NEPUserSettings.h"
#import "NEPEditWorkPeriodViewController.h"
#import "NEPEditBeforehandAlertViewController.h"

#import "NEPWorkDay.h"

@interface NEPSettingsViewController ()

@property NSTimeInterval workTime;
@property int beforehandSeconds;
@property NSDateFormatter *dateFormater;

@end

@implementation NEPSettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _dateFormater = [[NSDateFormatter alloc] init];
    [_dateFormater setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [_dateFormater setDateFormat:@"HH'h'mm"];

    _workTime              = NEPUserSettings.settings.workTime;
    _beforehandSeconds     = NEPUserSettings.settings.beforehandSeconds;
    _alertBeforeSwitch.on  = NEPUserSettings.settings.alertBefore;
    _alertOnTimeSwitch.on  = NEPUserSettings.settings.alertOnTime;
    _alertAfterSwitch.on   = NEPUserSettings.settings.alertAfter;
    _alertOvertimeLimit.on = NEPUserSettings.settings.alertOvertime;

    NSDate *countDownDate = [NSDate dateWithTimeIntervalSince1970:_workTime];
    _dailyWorkingTimeCell.detailTextLabel.text = [_dateFormater stringFromDate:countDownDate];
    
    _beforehandAlertCell.textLabel.text = [NSString stringWithFormat:@"%i minutos", _beforehandSeconds / 60];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        [self performSegueWithIdentifier:@"changeWorkTime" sender:self];
    }
    if (indexPath.section == 1 && indexPath.row == 0) {
        [self performSegueWithIdentifier:@"changeBeforehandAlarm" sender:self];
    }
}

- (IBAction)saveBarButtonAction:(id)sender {
    NEPUserSettings.settings.workTime          = _workTime;
    NEPUserSettings.settings.beforehandSeconds = _beforehandSeconds;
    NEPUserSettings.settings.alertBefore       = _alertBeforeSwitch.on;
    NEPUserSettings.settings.alertOnTime       = _alertOnTimeSwitch.on;
    NEPUserSettings.settings.alertAfter        = _alertAfterSwitch.on;
    NEPUserSettings.settings.alertOvertime     = _alertOnTimeSwitch.on;
    
    [NEPUserSettings saveSettings];
    
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"changeWorkTime"]) {
        NEPEditWorkPeriodViewController *editPeriod = segue.destinationViewController;
        editPeriod.delegate = self;
        editPeriod.currentPeriod = _workTime;
    }
    if ([segue.identifier isEqualToString:@"changeBeforehandAlarm"]) {
        NEPEditBeforehandAlertViewController *beforehand = segue.destinationViewController;
        beforehand.delegate = self;
        beforehand.currentSeconds = _beforehandSeconds;
    }
}

#pragma mark - NEPTimeIntervalPickerProtocol

- (void)selectedTimeInterval:(NSTimeInterval)interval {
    _workTime = interval;
    NSDate *countDownDate = [NSDate dateWithTimeIntervalSince1970:interval];
    _dailyWorkingTimeCell.detailTextLabel.text = [_dateFormater stringFromDate:countDownDate];
}

- (void)selectedDate:(NSDate *)date {
}

#pragma mark NEPEditBeforehandProtocol

-(void)newBeforeand:(int)seconds {
    _beforehandSeconds = seconds;
    _beforehandAlertCell.textLabel.text = [NSString stringWithFormat:@"%i minutos", _beforehandSeconds / 60];
}

@end
