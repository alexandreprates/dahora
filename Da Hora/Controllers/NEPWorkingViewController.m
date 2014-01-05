//
//  NEPWorkingViewController.m
//  Da Hora
//
//  Created by Alexandre Prates on 19/12/13.
//  Copyright (c) 2013 MyAppLab. All rights reserved.
//

#import "NEPWorkingViewController.h"
#import "NEPWorkDay.h"
#import "NEPUserSettings.h"
#import "NEPHourInfo.h"

#import "MDRadialProgressView.h"
#import "MDRadialProgressTheme.h"
#import "MDRadialProgressLabel.h"

#define IS_IPHONE5 (([[UIScreen mainScreen] bounds].size.height-568)?NO:YES)

static int progressViewSize;

@interface NEPWorkingViewController ()

@property (weak, nonatomic) NEPWorkDay *current;

@property (strong, nonatomic) MDRadialProgressTheme *theme;
@property (strong, nonatomic) MDRadialProgressView *progressView;

@property (strong, nonatomic) NEPHourInfo *beginningInfo;
@property (strong, nonatomic) NEPHourInfo *endingInfo;

@property NSTimer *timer;

@end

@implementation NEPWorkingViewController

- (void)viewDidLoad {
    _current = NEPWorkDay.current;
    
    progressViewSize = IS_IPHONE5 ? 200 : 180;

    CGRect screenRect = [[UIScreen mainScreen] bounds];
    int screenWidth = screenRect.size.width;
    int screenHeight = screenRect.size.height;
    int xpos = (screenWidth / 2) - (progressViewSize / 2);
    int ypos = (screenHeight / 2) - (progressViewSize / 2);
    
    if (!IS_IPHONE5) {
        ypos += 20;
    }
    
    _progressView = [[MDRadialProgressView alloc] initWithFrame:CGRectMake(xpos, ypos, progressViewSize, progressViewSize) andTheme:self.theme];
	_progressView.progressCounter = 0;
    _progressView.progressTotal = 1;
    _progressView.label.font = [UIFont systemFontOfSize:27];
    _progressView.clockwise = true;
	[self.view addSubview:_progressView];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerUpdate) userInfo:nil repeats:YES];
  
    _beginningInfo = [[NEPHourInfo alloc] viewFromStoryboard];
    [_beginningInfo display:_current.beginning andInfo:@"Entrada"];
    [_scrollView addSubview:_beginningInfo];

    _endingInfo = [[NEPHourInfo alloc] viewFromStoryboard];
    [_endingInfo display:_current.plannedEnding andInfo:@"Saída"];
    _endingInfo.frame = CGRectMake(_scrollView.frame.size.width, 0, _scrollView.frame.size.width, _scrollView.frame.size.height);
    [_scrollView addSubview:_endingInfo];
    
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width * 2, _scrollView.frame.size.height);
        
    [self timerUpdate];
}

- (void)viewDidAppear:(BOOL)animated {
    [self checkNotifications];
    [self timerUpdate];
}

#pragma mark Themes lazy load

- (MDRadialProgressTheme *)theme {
    if (!_theme) {
        _theme = [[MDRadialProgressTheme alloc] init];
        _theme.completedColor = [UIColor colorWithRed:1.00 green:0.00 blue:0.00 alpha:1.0];
        _theme.incompletedColor = [UIColor colorWithRed:1.00 green:0.80 blue:0.80 alpha:1.0];
        _theme.centerColor = [UIColor colorWithRed:1.00 green:0.90 blue:0.90 alpha:1.0];
        _theme.sliceDividerHidden = YES;
        _theme.labelColor = [UIColor blackColor];
        _theme.labelShadowColor = [UIColor whiteColor];
        _theme.thickness = 40;
    }
    return  _theme;
}

- (void)setThemeReadyToGo {
    self.theme.completedColor = [UIColor colorWithRed:0.00 green:1.00 blue:0.00 alpha:1.0];
    self.theme.incompletedColor = [UIColor colorWithRed:0.70 green:1.00 blue:0.70 alpha:1.0];
    self.theme.centerColor = [UIColor colorWithRed:0.95 green:1.00 blue:0.95 alpha:1.0];
    self.theme.labelColor = [UIColor greenColor];
    self.theme.labelColor = [UIColor redColor];
    self.theme.labelShadowColor = [UIColor whiteColor];
}

- (void)setThemeOvertime {
    self.theme.completedColor = [UIColor colorWithRed:1.00 green:0.60 blue:0.00 alpha:1.0];
    self.theme.incompletedColor = [UIColor colorWithRed:1.00 green:0.86 blue:0.65 alpha:1.0];
    self.theme.centerColor = [UIColor colorWithRed:1.00 green:0.96 blue:0.90 alpha:1.0];
    self.theme.labelColor = [UIColor orangeColor];
}

#pragma mark Notifications managment

- (void)checkNotifications {
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    if (NEPUserSettings.settings.alertBefore) [self notificate:@"%i minutos para o horário minimo" in:_current.secondsToAllowance];
    if (NEPUserSettings.settings.alertOnTime) [self notificate:@"%i minutos para o horário normal" in:_current.secondsToEnding];
    if (NEPUserSettings.settings.alertAfter)  [self notificate:@"%i minutos para iniciar hora extra" in:_current.secondsToOvertime];
    if (NEPUserSettings.settings.alertAfter)  [self notificate:@"%i minutos para o maximo de hora extra" in:_current.secondsToOvertimeLimit];

}

- (void)notificate:(NSString *)message in:(int)seconds {
    int alertInSeconds = seconds - NEPUserSettings.settings.beforehandSeconds;
    if (alertInSeconds > 0) {
        NSDate *notificationDate = [NSDate dateWithTimeIntervalSinceNow:alertInSeconds];
        UILocalNotification* localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = notificationDate;
        localNotification.alertBody = [[NSString alloc] initWithFormat:message, NEPUserSettings.settings.beforehandSeconds / 60];
        localNotification.alertAction = @"Visualizar";
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        localNotification.soundName = [@"dahora.caf" copy];
        localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
        
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"notificationDate" forKey:[NSString stringWithFormat:@"alarm-%i", seconds]];
        localNotification.userInfo = userInfo;

        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    }
}

#pragma mark Timer schedule

- (void)timerUpdate {
    if (_current.onWork) {
        _progressView.progressTotal = _current.workDuration;
        _progressView.progressCounter = _current.secondsInWork;
        _progressView.label.text = _current.workCountdown;
    }
    else if (_current.onAllowance) {
        _progressView.progressTotal = _current.allowanceDuration;
        _progressView.progressCounter = _current.secondsInAllowance;
        _progressView.label.text = _current.allowanceCountdow;
        [self setThemeReadyToGo];
    }
    else {
        _progressView.progressTotal = _current.overtimeDuration;
        _progressView.progressCounter = _current.secondsInOvertime;
        _progressView.label.text = _current.overtimeCountdown;
        [self setThemeOvertime];
    }
}

#pragma mark ScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
}

#pragma mark NEPTimeIntervalProtocol

- (void)selectedTimeInterval:(NSTimeInterval)interval {
}

- (void)selectedDate:(NSDate *)date {
    _current.beginning = date;
    [NEPWorkDay saveCurrent];
    [self checkNotifications];
}

#pragma mark Prepare for Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
}

#pragma mark View Actions

- (IBAction)finishWorkButtonAction:(id)sender {
    [_timer invalidate];
    _timer = nil;
    NEPWorkDay *newWorkday = [[NEPWorkDay alloc] init];
    newWorkday.beginning = _current.beginning;
    newWorkday.ending = [NSDate date];
    [NEPWorkDay addToHistory:newWorkday];
    
    [NEPWorkDay resetCurrent];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [self dismissViewControllerAnimated:false completion:nil];
}

- (IBAction)pageChanged:(id)sender {
    CGRect frame;
    frame.origin.x = self.scrollView.frame.size.width * self.pageControl.currentPage;
    frame.origin.y = 0;
    frame.size = self.scrollView.frame.size;
    [self.scrollView scrollRectToVisible:frame animated:YES];    
}

@end
