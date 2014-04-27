//
//  GraphView.h
//  CrimeFiles
//
//  Created by Sopan, Awalin on 4/17/14.
//  Copyright (c) 2014 __mstr__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>
@class AppDelegate;

@interface GraphView : NSView
@property int max;
@property CALayer* graphLayer;
@property CALayer* highlightLayer;
@property NSMutableArray* layers;
//@property int sum;
@property NSDictionary* graphValues;
@property NSDictionary* colorMap;
@property NSArray* sortedKeys;
@property NSString* attr;
-(void) setValues:(NSDictionary*) dist forAttr:(NSString*)attr andColorMap:(NSDictionary*) colorMap;

-(void) animate:(CAShapeLayer* )shape withWidth:(float) width;
-(void) drawLayerContent;

@end
