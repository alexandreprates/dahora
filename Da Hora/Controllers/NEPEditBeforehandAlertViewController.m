//
//  NEPEditBeforehandAlertViewController.m
//  Da Hora
//
//  Created by Alexandre Prates on 02/01/14.
//  Copyright (c) 2014 MyAppLab. All rights reserved.
//

#import "NEPEditBeforehandAlertViewController.h"

static NSArray *beforehandTimes;

@interface NEPEditBeforehandAlertViewController ()


@end

@implementation NEPEditBeforehandAlertViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    beforehandTimes = @[@120, @300, @600];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [beforehandTimes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int index = (int) indexPath.row;
    int value = (int) [beforehandTimes[index] integerValue];

    static NSString *CellIdentifier = @"beforehandCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%i minutos", value / 60];

    if (value == _currentSeconds) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    int index = (int) indexPath.row;
    int interval = (int) [beforehandTimes[index] integerValue];
    self.currentSeconds = interval;
    
    if (_delegate) {
        [_delegate newBeforeand:interval];
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - NEPEditBeforehandProtocol

- (void)newBeforeand:(int)seconds {
}

- (void)selectedDate:(NSDate *)date {
}

@end
