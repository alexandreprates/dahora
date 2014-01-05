//
//  NEPEditDayViewController.h
//  Da Hora
//
//  Created by Alexandre Prates on 23/12/13.
//  Copyright (c) 2013 MyAppLab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NEPWorkDay.h"
#import "NEPEditWorkDayProtocol.h"

@interface NEPEditDayViewController : UITableViewController <NEPEditWorkDayProtocol>

@property (strong, nonatomic) id <NEPEditWorkDayProtocol> delegate;

@property (strong, nonatomic) NSDate *beginning;
@property (strong, nonatomic) NSDate *ending;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UITableViewCell *beginningCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *endingCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *workTimeCell;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

- (IBAction)saveButtonAction:(id)sender;
- (IBAction)cancelButtonAction:(id)sender;
- (IBAction)datePickerValueChanged:(id)sender;

@end
