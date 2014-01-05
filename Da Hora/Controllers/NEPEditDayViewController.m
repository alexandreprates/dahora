//
//  NEPEditDayViewController.m
//  Da Hora
//
//  Created by Alexandre Prates on 23/12/13.
//  Copyright (c) 2013 MyAppLab. All rights reserved.
//

#import "NEPEditDayViewController.h"

@interface NEPEditDayViewController ()

@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) NSDateFormatter *timerFormatter;
@property int selectedCell;

@end

@implementation NEPEditDayViewController

- (void)viewDidLoad {
    _dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setDateFormat:@"HH:mm"];
    
    _timerFormatter = [[NSDateFormatter alloc] init];
    [_timerFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [_timerFormatter setDateFormat:@"HH:mm"];

    NSDateFormatter *dayFormatter = [[NSDateFormatter alloc] init];
    [dayFormatter setDateFormat:@"EEE d/MM/YYYY"];
    
    _dateLabel.text = [dayFormatter stringFromDate:_beginning];
    _beginningCell.detailTextLabel.text = [_dateFormatter stringFromDate:_beginning];
    _endingCell.detailTextLabel.text    = [_dateFormatter stringFromDate:_ending];
    
    NSTimeInterval workTime = [_ending timeIntervalSinceDate:_beginning];
    _workTimeCell.textLabel.text = [NSString stringWithFormat:@"Horas trabalhadas: %@", [_timerFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:workTime]]];
}

- (void)viewDidAppear:(BOOL)animated {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition: UITableViewScrollPositionNone];
    [self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
}

#pragma mark Table Row selected

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        _selectedCell = (int) indexPath.row;
        if (indexPath.row == 0) {
            _datePicker.date = _beginning;
            _datePicker.maximumDate = _ending;
            _datePicker.minimumDate = nil;
        } else if (indexPath.row == 1) {
            _datePicker.date = _ending;
            _datePicker.maximumDate = nil;
            _datePicker.minimumDate = _beginning;
        }
    }
}

#pragma mark Edit Workday protocol

- (void)didUpdateWorkDay:(NSDate *)beginning to:(NSDate *)ending {
}

#pragma mark View Actions

- (IBAction)saveButtonAction:(id)sender {
    if (_delegate) {
        [_delegate didUpdateWorkDay:_beginning to:_ending];
    }
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)cancelButtonAction:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)datePickerValueChanged:(id)sender {
    if (_selectedCell == 0) {
        _beginning = _datePicker.date;
        _beginningCell.detailTextLabel.text = [_dateFormatter stringFromDate:_beginning];
    } else if (_selectedCell == 1) {
        _ending = _datePicker.date;
        _endingCell.detailTextLabel.text    = [_dateFormatter stringFromDate:_ending];
    }
    NSTimeInterval workTime = [_ending timeIntervalSinceDate:_beginning];
    _workTimeCell.textLabel.text = [NSString stringWithFormat:@"Horas trabalhadas: %@", [_timerFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:workTime]]];

}

@end
