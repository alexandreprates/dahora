//
//  NEPHistoryViewController.m
//  Da Hora
//
//  Created by Alexandre Prates on 22/12/13.
//  Copyright (c) 2013 MyAppLab. All rights reserved.
//

#import "NEPHistoryViewController.h"
#import "NEPWorkDay.h"
#import "NEPEditDayViewController.h"
#import "NEPHistoryCell.h"

static NSArray *monthNames;

@interface NEPHistoryViewController ()

@property (strong, nonatomic) NSMutableArray *history;
@property (strong, nonatomic) NSArray *monthHistory;

@property int monthIndex;
@property int yearIndex;

@property (strong, nonatomic) NEPWorkDay *selectedDay;

@end

@implementation NEPHistoryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    monthNames = [[[NSDateFormatter alloc] init] monthSymbols];
    
    _history = NEPWorkDay.history;
    
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSCalendarUnit units = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *components = [calendar components:units fromDate:now];
    
    _monthIndex = (int) [components month];
    _yearIndex = (int) [components year];
    
    [self filterHistory];
    [self.tableView reloadData];
}

- (void)filterHistory {
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"beginningMonth = %i AND beginningYear = %i", _monthIndex, _yearIndex];
    _monthHistory = [_history filteredArrayUsingPredicate:resultPredicate];
    
    NSString *readableFilter = [[NSString alloc] initWithFormat:@"%@ %i", monthNames[_monthIndex - 1], _yearIndex];
    _filterLabel.text = [readableFilter capitalizedString];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_monthHistory count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"day";
    NEPHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NEPWorkDay *day = _monthHistory[indexPath.row];
    
    [cell workDay:day.beginning to:day.ending];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _selectedDay = _monthHistory[indexPath.row];
    [self performSegueWithIdentifier:@"EditDay" sender:self];
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_history removeObject:_monthHistory[indexPath.row]];
        [NEPWorkDay saveHistory];
        [self filterHistory];
        
        [self.tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"EditDay"]) {
        NEPEditDayViewController *editDay = segue.destinationViewController;
        editDay.delegate = self;
        editDay.beginning = _selectedDay.beginning;
        editDay.ending    = _selectedDay.ending;
    }
}

#pragma mark Edit workday protocol

- (void)didUpdateWorkDay:(NSDate *)beginning to:(NSDate *)ending {
    _selectedDay.beginning = beginning;
    _selectedDay.ending = ending;
    [NEPWorkDay saveHistory];
    [self.tableView reloadData];
}

#pragma mark - View Actions

- (IBAction)filterPriorMonthButtonAction:(id)sender {
    _monthIndex -= 1;
    if (_monthIndex < 1) {
        _monthIndex = 12;
        _yearIndex -= 1;
    }
    [self filterHistory];
    [self.tableView reloadData];
}

- (IBAction)filterNextMonthButtonAction:(id)sender {
    _monthIndex += 1;
    if (_monthIndex > 12) {
        _monthIndex = 1;
        _yearIndex += 1;
    }
    [self filterHistory];
    [self.tableView reloadData];
}

- (IBAction)backButtonAction:(id)sender {
    [self dismissViewControllerAnimated:false completion:nil];
}

@end
