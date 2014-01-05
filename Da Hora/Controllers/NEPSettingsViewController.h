//
//  NEPSettingsViewController.h
//  Da Hora
//
//  Created by Alexandre Prates on 14/12/13.
//  Copyright (c) 2013 MyAppLab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NEPTimeIntervalPickerProtocol.h"
#import "NEPEditBeforehandProtocol.h"

@interface NEPSettingsViewController : UITableViewController <NEPTimeIntervalPickerProtocol, NEPEditBeforehandProtocol>

@property (weak, nonatomic) IBOutlet UITableViewCell *dailyWorkingTimeCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *beforehandAlertCell;

@property (weak, nonatomic) IBOutlet UISwitch *alertBeforeSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *alertOnTimeSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *alertAfterSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *alertOvertimeLimit;

- (IBAction)saveBarButtonAction:(id)sender;

@end
