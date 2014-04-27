//
//  WeekDayView.m
//  CrimeFiles
//
//  Created by Sopan, Awalin on 4/18/14.
//  Copyright (c) 2014 __mstr__. All rights reserved.
//

#import "WeekDayView.h"

@implementation WeekDayView



-(void) setValues:(NSDictionary*) dist{
    [self setGraphValues: dist];
    // Drawing code
    NSArray* values = [_graphValues allValues];
    float height = self.frame.size.height*1.0;
    
    [self setMax: (int)[values valueForKeyPath: @"@max.self"]];
    
    float barDist = (self.frame.size.width-(2*[_graphValues count]))/[_graphValues count];
    float start =  0.0;
    for(id key in _graphValues){
        int val = (int)[_graphValues objectForKey:key];
        float eachHeight = (height/_max)*(1.0*val);
        
        NSLog(@"values %@: is %d, height %f\n", key, val, eachHeight);
        NSColor *color= [NSColor lightGrayColor];
        
        //            [color set];
        
        CALayer *sublayer = [CALayer layer];
        sublayer.backgroundColor = color.CGColor;
        
        sublayer.frame = CGRectMake(start, 0.0, barDist, eachHeight);
        
        sublayer.borderColor = [NSColor grayColor].CGColor;
        sublayer.borderWidth = 2.0;
        sublayer.cornerRadius = 5.0;
        [[self layer] addSublayer:sublayer];
        
        //            NSRectFill(aRect);
        
        start+= (barDist+2);
        }
}

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        //        [self setLayer: [CALayer layer]];
        //        [self setWantsLayer:YES];
        
        CGRect  myFrame = self.frame;
        myFrame.size.width = 600;
        myFrame.size.height = 300;
        self.frame = myFrame;
        [self setGraphValues:nil];
        //        _sum = 0;
        
        _max = 0;
        
        
    }
    return self;
}


//- (void)drawRect:(NSRect)dirtyRect {
//    
//   
//    
////    [[NSColor whiteColor] setFill];
//    NSRectFill(dirtyRect);
//    [super drawRect:dirtyRect];
//   
//    [[self layer] setBackgroundColor: [NSColor greenColor].CGColor];
//    [[self layer] setBackgroundColor:[NSColor redColor].CGColor];
//    [[self layer] setBorderWidth: 3.0];
//    
//    float height = self.frame.size.height*1.0;
//    
//    if(![self graphValues]){
//        NSLog(@"no values in weekday ");
//        return;
//    }
//    else{
//        
//        
//        
//        NSLog(@"total:max: %d", _max);
//        
//        float barDist = (self.frame.size.width-(2*[_graphValues count]))/[_graphValues count];
//        float start =  0.0;
//        
//        for(id key in _graphValues){
//            int val = (int)[_graphValues objectForKey:key];
//            float eachHeight = (height/_max)*(1.0*val);
//            
//            NSLog(@"values %@: is %d, height %f\n", key, val, eachHeight);
//            NSColor *color= [NSColor lightGrayColor];
//            
//            CALayer *sublayer = [CALayer layer];
//            sublayer.backgroundColor = color.CGColor;
//            
//            sublayer.frame = CGRectMake(start, 0.0, barDist, eachHeight);
//
//            sublayer.borderColor = [NSColor grayColor].CGColor;
//            sublayer.borderWidth = 2.0;
//            sublayer.cornerRadius = 5.0;
//            [[self layer] addSublayer:sublayer];
//            
////            NSRectFill(aRect);
//            
//            start+= (barDist+2);
//            
//            
//        }
//        
//        
//    }
//    
//}



-(void) animate:(id)layer toHeight:(int) height{
//    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
//    
//    CGPoint endPoint = CGPointMake( 100.0, 100.0);
//    
//    
//    [animation setFromValue: [NSValue valueWit: 0.0]];
//    
//    [animation setToValue:height];
//    [animation setDuration:2.0];
//    
//    
//    [layer setPosition:endPoint];
//    
//    [layer addAnimation:animation forKey:nil];
    
}


@end
