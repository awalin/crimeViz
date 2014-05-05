//
//  GraphView.m
//  CrimeFiles
//
//  Created by Sopan, Awalin on 4/17/14.
//  Copyright (c) 2014 __mstr__. All rights reserved.
//

#import "GraphView.h"
#import "AppDelegate.h"

@implementation GraphView

@synthesize  highlights;
@synthesize attr;



-(void) drawRect:(NSRect)dirtyRect{
    
    [[NSColor whiteColor] setFill];
    NSRectFill(dirtyRect);
    [super drawRect:dirtyRect];
    
    
    if(![self graphValues]){
        NSLog(@"no values");
        return;
    }
    else{
        [self graphLayer].sublayers = nil;
    }
    NSLog(@"redraw");
    [self  drawLayerContent];
    
    if([self highlights]){
        [self drawHighlights];
    }
    

}

-(void) drawHighlights{
    
    if(![self highlights]){
        NSLog(@"no highlights");
        return;
    } else {
        
        NSLog(@"total highlights in %@ graph, total: %lu", [self attr], [[self highlights] count]);
        
        //         CGColorRef colort = CGColorCreateGenericRGB(0.8, 0.8, 0.8, 0.5);
        
        float barDist = ([self frame].size.height-(3*[_graphValues count]))/[_graphValues count];
        float start = [self layer].frame.size.height-barDist;
        float width = [self frame].size.width*1.0 -80.0;
        
        
        float barDistV = ([self frame].size.width-(3*[_graphValues count]))/[_graphValues count];
        float startV = 0.0;//[self layer].frame.size.width-barDistV;
        float height = [self frame].size.height*1.0 -40.0;
        
    
        [self highlightLayer].sublayers=nil;
        
        for(id key in _sortedKeys){
            
            int val = (int)[[self highlights] objectForKey:key];
            
            
            NSColor *color ;
            if(![self colorMap]){
                color = [NSColor blueColor];
            }else{
                color = [[self colorMap] objectForKey:key];
            }
            
            CAShapeLayer *sublayer = [CAShapeLayer layer];
            sublayer.backgroundColor = color.CGColor;
            sublayer.cornerRadius = 0.5;
            sublayer.anchorPoint = CGPointMake(0.0,0.0);

            
            if( ([[self attr] isEqual:@"month"]) || ([[self attr] isEqual:@"week"]) || ([[self attr] isEqual:@"weekDay"]) ){
                
                float eachHeight = (height/_max)*(1.0*val);
                
            //    NSLog(@"values %@: is %d, height %f\n", key, val, eachHeight);
                
          
                [sublayer setPosition: CGPointMake(startV, 20.0)];
                [sublayer setBounds:CGRectMake(startV, 20.0, barDistV, 1.0)];//initially, width is just 1.0, animates to the actual width
                
                [[self highlightLayer] addSublayer:sublayer];
                [self animate:sublayer withHeight: eachHeight];
                
                
                startV+= (barDistV+3);
                
            }else{
                
                float eachWidth = (width/_max)*(1.0*val);
                
                //            NSLog(@"values %@: is %d, height %f\n", key, val, eachWidth);

                [sublayer setPosition: CGPointMake(80.0, start)];
                [sublayer setBounds:CGRectMake(80.0, start, 1.0, barDist)];//initially, width is just 1.0, animates to the actual width

                [[self highlightLayer] addSublayer:sublayer];
                [self animate:sublayer withWidth: eachWidth];
                
                
                start-= (barDist+3);
            }
            
        }
    }
    
}

-(void) drawLayerContent{
  
    if(![self graphValues]){
        NSLog(@"no values");
        return;
    } else {
        
        NSLog(@"drawing layers: max: %d", _max);
        NSLog(@"height = %f",[self frame].size.height);
        
        NSLog(@"width = %f",[self frame].size.width);
        
        [[self graphLayer] setSublayers:nil] ;
        [[self highlightLayer] setSublayers:nil] ;

    
        float barDist = ([self frame].size.height-(3*[_graphValues count]))/[_graphValues count];
        float start = [self layer].frame.size.height-barDist;
        float width = [self frame].size.width*1.0 -80.0;
        
        
        float barDistV = ([self frame].size.width-(3*[_graphValues count]))/[_graphValues count];
        float startV = 0.0;//[self layer].frame.size.width-barDistV;
        float height = [self frame].size.height*1.0 -40.0;
        
        _sortedKeys = [[NSArray alloc] init];
        
        //sort by key
        if( ([[self attr] isEqual:@"month"]) || ([[self attr] isEqual:@"week"]) || ([[self attr] isEqual:@"weekDay"] )){
            
            _sortedKeys = [[_graphValues allKeys] sortedArrayUsingSelector: @selector(caseInsensitiveCompare:)];
            }
        else{
            _sortedKeys = [[_graphValues allKeys] sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
                NSString *first = [_graphValues objectForKey:a];
                NSString *second = [_graphValues objectForKey:b];
                return [first compare:second];
            }];
        }
        
        if([[self attr] isEqualToString:@"weekDay"]){
            _sortedKeys = [NSArray arrayWithObjects:@"Mon",@"Tue",@"Wed",@"Thu",@"Fri",@"Sat",@"Sun",nil];
        }
  
        for(id key in _sortedKeys){
            int val = (int)[_graphValues objectForKey:key];
  
            NSColor *color ;
            if(![self colorMap]){
                color = [NSColor lightGrayColor];
            }else{
                color = [[self colorMap] objectForKey:key];
            }
            
            CALayer *barLayer = [CALayer layer];
            [barLayer setAnchorPoint : CGPointMake(0.0,0.0)];
            
            CATextLayer *label = [CATextLayer layer];
            label.string = key;
            
            [label setFontSize:10.0];
            [label setForegroundColor:[NSColor blackColor].CGColor];
            label.anchorPoint = CGPointMake(0.0,0.0);
            label.alignmentMode = kCAAlignmentRight;
            
            label.anchorPoint = CGPointMake(0.0,0.0);
            label.alignmentMode = kCAAlignmentRight;
            
    
            CAShapeLayer *sublayer = [CAShapeLayer layer];
            sublayer.backgroundColor = color.CGColor;
            sublayer.cornerRadius = 0.5;
            
            
            if( ([[self attr] isEqual:@"month"]) || ([[self attr] isEqual:@"week"]) || ([[self attr] isEqual:@"weekDay"]) ){

                float eachHeight = (height/_max)*(1.0*val);
               
                [barLayer setPosition:CGPointMake(startV, 0.0)];
                [barLayer setBounds:CGRectMake(startV, 0.0, barDistV,[self frame].size.height)];
                
                label.geometryFlipped=YES;
                label.position = CGPointMake(startV, 0.0);
                [label setBounds:CGRectMake(startV, 0.0, barDistV, 20.0)];
                
                
                [barLayer addSublayer:label];
                
                sublayer.anchorPoint = CGPointMake(0.0,0.0);
                [sublayer setPosition: CGPointMake(startV, 20.0)];
                [sublayer setBounds:CGRectMake(startV, 20.0, barDistV, 1.0)];//initially, width is just 1.0, animates to the actual width
                
                [barLayer addSublayer:sublayer];
                
                
                [[self graphLayer] addSublayer:barLayer];
                [self animate:sublayer withHeight: eachHeight];
                
                
                startV+= (barDistV+3);

            }else{
                
            float eachWidth = (width/_max)*(1.0*val);
                
            NSLog(@"values %@: is %d, height %f\n", key, val, eachWidth);
            
            [barLayer setPosition:CGPointMake(0.0, start)];
            [barLayer setBounds:CGRectMake(0.0, start, [self frame].size.width, barDist)];
            
            label.position = CGPointMake(0.0, start);

           
            [label setBounds:CGRectMake(0.0, start, 76.0, barDist)];
            
            [barLayer addSublayer:label];
        
 
            sublayer.anchorPoint = CGPointMake(0.0,0.0);
            [sublayer setPosition: CGPointMake(80.0, start)];
            [sublayer setBounds:CGRectMake(80.0, start, 1.0, barDist)];//initially, width is just 1.0, animates to the actual width
            
            [barLayer addSublayer:sublayer];
            
            [[self graphLayer] addSublayer:barLayer];
            [self animate:sublayer withWidth: eachWidth];
            
            
            start-= (barDist+3);
            }
            
        }
    }

}

- (id) initWithFrame:(NSRect)frame
             values:(NSMutableDictionary*)values
               name:(NSString*) name
           colorMap:(NSMutableDictionary*) colors
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        
        [self setGraphValues:nil];
        
        
        [self setGraphLayer:[CALayer layer]];
        [self setHighlightLayer:[CALayer layer]];
        
        [self setWantsLayer:YES];//enable the default layer
        
        [[self graphLayer] setDelegate:self];
        [[self highlightLayer] setDelegate:self];
        
        CGColorRef color = CGColorCreateGenericRGB(1.0, 1.0, 1.0, 1);
        
        [[self graphLayer] setBackgroundColor:color];
        
        [[self graphLayer] setBounds:CGRectMake(0.0, 0.0, [self frame].size.width, [self frame].size.height )];
        
       
        
        [[self graphLayer] setPosition: CGPointMake(self.frame.size.width/2,
                                                    self.frame.size.height/2)];
        
        
        
        [[self layer] addSublayer:[self graphLayer]];//add the graph layer as a sublayer to the defualt layer of this view
        
        
//        [[self highlightLayer] setBackgroundColor:color];
        [[self highlightLayer] setOpacity:1.0];
        
        [[self highlightLayer] setBounds:CGRectMake(0.0, 0.0, [self frame].size.width, [self frame].size.height )];
        
        
        
        [[self highlightLayer] setPosition: CGPointMake(self.frame.size.width/2,
                                                    self.frame.size.height/2)];
        
        
        [[self layer] addSublayer:[self highlightLayer]];//add the graph layer as a sublayer to the defualt layer of this view
        
        
        
        [self setGraphValues: values];
 
        NSArray* values = [_graphValues allValues];
        [self setAttr: name];
        [self setColorMap:colors];
        [self setMax: (int)[values valueForKeyPath: @"@max.self"]];
//        NSLog(@"graph name:  %@", [self attr]);
        
        [self drawLayerContent];

        
    
  }
    return self;
}

-(void) animate:(CAShapeLayer*)shape withOpacity:(float) opaque {
    
    CABasicAnimation *animateBar = [CABasicAnimation animationWithKeyPath:@"opacity"];
    
//    [animateBar setFromValue: [shape.opacity]];
    
//    NSRect startRect = [shape frame];
    
//    NSRect endRect = NSMakeRect(startRect.origin.x, startRect.origin.y, startRect.size.width, height);
    
//    [animateBar setToValue: (id*)opaque];
    
    [animateBar setDuration:0.5];
    
    
    [shape setOpacity: opaque];
    
    
    [shape addAnimation:animateBar forKey:nil];
    
}

-(void) animate:(CAShapeLayer*)shape withHeight:(float) height {
    
    CABasicAnimation *animateBar = [CABasicAnimation animationWithKeyPath:@"bounds"];
    
    [animateBar setFromValue: [NSValue valueWithRect:[shape frame]]];
    
    NSRect startRect = [shape frame];
    
    NSRect endRect = NSMakeRect(startRect.origin.x, startRect.origin.y, startRect.size.width, height);
    
    [animateBar setToValue: [NSValue valueWithRect:endRect]];
    
    [animateBar setDuration:0.5];
    
    
    [shape setBounds:endRect];
    
    
    [shape addAnimation:animateBar forKey:nil];
    
}



-(void) animate:(CAShapeLayer*)shape withWidth:(float) width {
    
    CABasicAnimation *animateBar = [CABasicAnimation animationWithKeyPath:@"bounds"];

    [animateBar setFromValue: [NSValue valueWithRect:[shape frame]]];
    
    NSRect startRect = [shape frame];
    
    NSRect endRect = NSMakeRect(startRect.origin.x, startRect.origin.y, width, startRect.size.height);
    
    [animateBar setToValue: [NSValue valueWithRect:endRect]];
    
    [animateBar setDuration:0.5];
    
    
    [shape setBounds:endRect];
    
    
    [shape addAnimation:animateBar forKey:nil];
    
}

- (BOOL)acceptsFirstResponder {
    return YES;
}


-(void) updateValues:(NSMutableDictionary*)values
               name:(NSString*) name
            colorMap:(NSMutableDictionary*) colors{
    
    
    [self setGraphValues: values];
    
    NSArray* val = [_graphValues allValues];
    [self setAttr: name];
    [self setColorMap:colors];
    [self setMax: (int)[val valueForKeyPath: @"@max.self"]];
    //        NSLog(@"graph name:  %@", [self attr]);

    
    


}

- (void)mouseDown:(NSEvent *)event {
    // determine if I handle theEvent
    // if not... [[self nextResponder] mouseDown:theEvent];
    NSLog(@"Mouse clicked");
    
    NSPoint eventLocation = [event locationInWindow];
    NSPoint locationInCurrentView = [self convertPoint:eventLocation fromView:nil];

    int height = (int)[self frame].size.height;
    NSLog(@"view height %d", height);
    
    long row = ([_sortedKeys count]-1)- [_sortedKeys count]*(int)locationInCurrentView.y/height; // got the bar that is clicked
    
    if( ([[self attr] isEqual:@"month"]) || ([[self attr] isEqual:@"week"]) || ([[self attr] isEqual:@"weekDay"]) ){
        row = [_sortedKeys count]*(int)locationInCurrentView.x/(int)[self frame].size.width;
    }
    
    NSLog(@"which bar %ld", row);
    CALayer *modLayer = (CALayer*)[[[self graphLayer] sublayers] objectAtIndex: row];

    [modLayer setBorderWidth : 1.0];
    [modLayer setOpacity: 0.3];
 
    
    [modLayer setBorderColor:[NSColor greenColor].CGColor];
    
    NSString *rowKey = [_sortedKeys objectAtIndex:row];
    
    NSLog(@"Selected Row %ld, type: %@",row, [_sortedKeys objectAtIndex:row]);
    
    AppDelegate* appDelegate = [NSApp delegate];//get the app delegate of this View, very useful!
    
    [appDelegate rowClicked:[self attr] withValue:rowKey];
    
}

@end
