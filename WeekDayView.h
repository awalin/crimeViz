//
//  WeekDayView.h
//  CrimeFiles
//
//  Created by Sopan, Awalin on 4/18/14.
//  Copyright (c) 2014 __mstr__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface WeekDayView : NSView
@property int max;
//@property int sum;
@property NSDictionary* graphValues;
@property NSDictionary* colorMap;
@property NSArray* layers;

-(void) setValues:(NSDictionary*) dist;
-(void) animate:(id)layer toHeight:(int) height;

@end
