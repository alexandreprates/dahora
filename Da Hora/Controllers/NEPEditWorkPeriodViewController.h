//
//  NEPEditWorkPeriodViewController.h
//  Da Hora
//
//  Created by Alexandre Prates on 29/12/13.
//  Copyright (c) 2013 MyAppLab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NEPTimeIntervalPickerProtocol.h"

@interface NEPEditWorkPeriodViewController : UITableViewController

@property (weak) id <NEPTimeIntervalPickerProtocol> delegate;
@property NSTimeInterval currentPeriod;
@property (weak, nonatomic) IBOutlet UITableViewCell *infoCell;
@property (weak, nonatomic) IBOutlet UIDatePicker *timePicker;

- (IBAction)saveButtonAction:(id)sender;
- (IBAction)cancelButtonAction:(id)sender;
- (IBAction)valueChanged:(UIDatePicker *)sender;

@end
