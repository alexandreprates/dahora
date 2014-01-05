//
//  NEPHistoryCell.m
//  Da Hora
//
//  Created by Alexandre Prates on 25/12/13.
//  Copyright (c) 2013 MyAppLab. All rights reserved.
//

#import "NEPHistoryCell.h"
#import "NEPUserSettings.h"

static double MAXWIDTH = 234;

@interface NEPHistoryCell ()

@property (strong, nonatomic) NSDateFormatter *weekDayFormatter;
@property (strong, nonatomic) NSDateFormatter *monthDayFormatter;
@property (strong, nonatomic) NSDateFormatter *hourFormatter;
@property (strong, nonatomic) NSDateFormatter *counterFormatter;

@end

@implementation NEPHistoryCell

- (NSDateFormatter *)weekDayFormatter {
    if (!_weekDayFormatter) {
        _weekDayFormatter = [[NSDateFormatter alloc] init];
        [_weekDayFormatter setDateFormat:@"EEE"];
    }
    return _weekDayFormatter;
}

- (NSDateFormatter *)monthDayFormatter {
    if (!_monthDayFormatter) {
        _monthDayFormatter = [[NSDateFormatter alloc] init];
        [_monthDayFormatter setDateFormat:@"d"];
    }
    return _monthDayFormatter;
}

- (NSDateFormatter *)hourFormatter {
    if (!_hourFormatter) {
        _hourFormatter = [[NSDateFormatter alloc] init];
        [_hourFormatter setDateFormat:@"HH:mm"];
    }
    return  _hourFormatter;
}

- (NSDateFormatter *)counterFormatter {
    if (!_counterFormatter) {
        _counterFormatter = [[NSDateFormatter alloc] init];
        [_counterFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
        [_counterFormatter setDateFormat:@"HH'h'mm"];
    }
    return _counterFormatter;
}

- (int)positionByInterval:(double)interval max:(int)maximum min:(int)minimum {
    double position = interval * maximum / NEPUserSettings.settings.workTime;
    
    if (position > maximum) position = maximum;
    if (position < minimum) position = minimum;
    
    return (int) position;
}

- (CGRect)widthByTimeInterval:(CGRect)frame for:(double)worktime minimum:(int)minValue {
    double width = worktime * MAXWIDTH / NEPUserSettings.settings.workTime;
    if (width < minValue) {
        width = minValue;
    }
    
    return CGRectMake(frame.origin.x, frame.origin.y, (int)width, frame.size.height);
}

- (void)workDay:(NSDate *)beginning to:(NSDate *)ending {
    
    for(UIView *subview in [[self subviews][0] subviews]) {
        if (subview.tag == 1) {
            [subview removeFromSuperview];
        }
    }
    
    _beginningLabel.text = [self.hourFormatter stringFromDate:beginning];
    _weekDayLabel.text = [self.weekDayFormatter stringFromDate:beginning];
    _monthDayLabel.text = [self.monthDayFormatter stringFromDate:beginning];
    
    _endingLabel.text = [self.hourFormatter stringFromDate:ending];

    NSTimeInterval workTime = [ending timeIntervalSinceDate:beginning];
    NSDate *countDownDate = [NSDate dateWithTimeIntervalSince1970:workTime];
    
    int labelX = [self positionByInterval:workTime max:240 min:50];
    int workBarWidth = [self positionByInterval:workTime max:238 min:10];

    UIView *workBar = [[UIView alloc] init];
    workBar.alpha = 0.8;
    workBar.frame = CGRectMake(48, 20, 10, 25);
    workBar.tag = 1;
    if (workTime < (NEPUserSettings.settings.workTime - 900)) {
        workBar.backgroundColor = [UIColor redColor];
    } else if (workTime > (NEPUserSettings.settings.workTime - 900) && workTime < (NEPUserSettings.settings.workTime + 900)) {
        workBar.backgroundColor = [UIColor greenColor];
    } else {
        workBar.backgroundColor = [UIColor orangeColor];
    }
    [self addSubview:workBar];
   
   
    _worktimeLabel.text = [self.counterFormatter stringFromDate:countDownDate];
    _worktimeLabel.frame = CGRectMake(50, 25, 45, 16);
    _worktimeLabel.tag = 1;
    [self addSubview:_worktimeLabel];

    [UIView animateWithDuration:1.0
                          delay:1.0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         workBar.frame = CGRectMake(48, 20, workBarWidth, 25);
                        _worktimeLabel.frame = CGRectMake(labelX, _worktimeLabel.frame.origin.y, _worktimeLabel.frame.size.width, _worktimeLabel.frame.size.height);
                         
                     } completion:nil];
}

@end
