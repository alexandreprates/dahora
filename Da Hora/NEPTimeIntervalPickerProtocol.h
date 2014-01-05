//
//  NEPTimeIntervalPickerProtocol.h
//  Da Hora
//
//  Created by Alexandre Prates on 14/12/13.
//  Copyright (c) 2013 MyAppLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NEPTimeIntervalPickerProtocol <NSObject>

- (void)selectedTimeInterval:(NSTimeInterval) interval;
- (void)selectedDate:(NSDate *) date;

@end
