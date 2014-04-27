//
//  CustomCellView.m
//  CrimeFiles
//
//  Created by Sopan, Awalin on 4/18/14.
//  Copyright (c) 2014 __mstr__. All rights reserved.
//

#import "CustomCellView.h"


@implementation CustomCellView


@synthesize color;
@synthesize value;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
  
    return self;
       
}

- (void)drawRect:(NSRect)dirtyRect
{
    [[NSColor whiteColor] setFill];
    NSRectFill(dirtyRect);
    [super drawRect:dirtyRect];
    
    float width = self.frame.size.width*1.0;
    
    if(![self value]){
        NSLog(@"no values");
        return;
    }
    else{
        
        {
            float val = (float)[self value];
            float eachWidth = (width)*(val);//here, value = value/max
            float start = [self frame].size.width - eachWidth;
            
            NSLog(@"values is %f, height%f \n", val, eachWidth);
           
            [[self color] set];
            
            NSRect aRect = NSMakeRect(start, 0.0, eachWidth,[self frame].size.height);
            
            NSRectFill(aRect);
            
            }
        
        
    }
    
}
//
//
//-(void) setValue:(float)aValue andColor:(NSColor*) aColor{
//    [self setValue:value];
//    [self setColor:color];
//
//}
@end
