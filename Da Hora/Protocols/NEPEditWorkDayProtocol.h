//
//  NEPEditWorkDayProtocol.h
//  Da Hora
//
//  Created by Alexandre Prates on 25/12/13.
//  Copyright (c) 2013 MyAppLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NEPEditWorkDayProtocol <NSObject>

- (void)didUpdateWorkDay:(NSDate *)beginning to:(NSDate *)ending;

@end
