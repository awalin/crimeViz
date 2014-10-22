//
//  GraphView.m
//  CrimeFiles
//
//  Created by Sopan, Awalin on 4/17/14.
//  Copyright (c) 2014 __mstr__. All rights reserved.
//

#import "GraphView.h"
#import "AppDelegate.h"
#import "ColorMapper.h"

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
        [self highlightLayer].sublayers = nil; // or just redraw the layers, do not make them nil
        return;
    } else {
        
        for(CALayer* cl in [[self graphLayer] sublayers]){
            [(CAShapeLayer*)cl.sublayers[1] setOpacity: 0.6];
            [(CAShapeLayer*)cl.sublayers[0] setOpacity: 0.8];
            //            cl.opacity = 0.3;
        }

        
        float barDist = ([self frame].size.height-(3*(1+[_graphValues count])))/[_graphValues count];
        float start = [self layer].frame.size.height-barDist-3; // 3 is margin
        float width = [self frame].size.width*1.0 -80.0;
        
        
        float barDistV = ([self frame].size.width-(3*(1+[_graphValues count])))/[_graphValues count];
        float startV = 0.0;//[self layer].frame.size.width-barDistV;
        float height = [self frame].size.height*1.0 -40.0;

        
        
        if( ![self highlightLayer].sublayers){
            //    draw the sublayers
            for(id key in _sortedKeys){
                
                NSColor *color ;
                if(![self colorMap]){
                    color = [ColorMapper colorWithHexColorString:@"FFEACC"];
                }else{
                    color = [[self colorMap] objectForKey:key];
                }
                
                CAShapeLayer *sublayer = [CAShapeLayer layer];
                sublayer.backgroundColor = color.CGColor;
                sublayer.cornerRadius = 0.5;
                sublayer.anchorPoint = CGPointMake(0.0,0.0);
                
                int val = (int)[[self highlights] objectForKey:key];
            
                if( !self.horizontal){
                    
                    float eachHeight = (height/_max)*(1.0*val);
                    [sublayer setPosition: CGPointMake(startV, 20.0)];
                    [sublayer setBounds:CGRectMake(startV, 20.0, barDistV, 1.0)];//initially, width is just 1.0, animates to the actual width
                    [[self highlightLayer] addSublayer:sublayer];
                    startV+= (barDistV+3);
                     //else reuse the old one
                    [self animate:sublayer withHeight: eachHeight];
                    
                }else{
                    
                    float eachWidth = (width/_max)*(1.0*val);
                    [sublayer setPosition: CGPointMake(80.0, start)];
                    [sublayer setBounds:CGRectMake(80.0, start, 1.0, barDist)];//initially, width is just 1.0, animates to the actual width
                    [[self highlightLayer] addSublayer:sublayer];
                    start-= (barDist+3);
                    
                    [self animate:sublayer withWidth: eachWidth];
                    
                }
                
            }
            
        }
        else{ //exists
            int i = 0;
            for(id key in _sortedKeys){
                
                CAShapeLayer *sublayer = self.highlightLayer.sublayers[i];
                int val = (int)[[self highlights] objectForKey:key];
                i++;
                if( !self.horizontal ){
                    
                    float eachHeight = (height/_max)*(1.0*val);
                    
                    [self animate:sublayer withHeight: eachHeight];
                }else{
                    float eachWidth = (width/_max)*(1.0*val);
                    [self animate:sublayer withWidth: eachWidth];
                }
            
            }//end of for loop
        
        }//if exists, reuse
        
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

    
        float barDist = ([self frame].size.height-(3*(1+[_graphValues count])))/[_graphValues count];
        float start = [self layer].frame.size.height-barDist-3; // 3 is margin
        float width = [self frame].size.width*1.0 -80.0;
        
        
        float barDistV = ([self frame].size.width-(3*(1+[_graphValues count])))/[_graphValues count];
        float startV = 0.0+3.0;//[self layer].frame.size.width-barDistV;
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
                color = [ColorMapper colorWithHexColorString:@"B1B1B7"];
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
            
    
            CAShapeLayer *sublayer = [CAShapeLayer layer];
            sublayer.backgroundColor = color.CGColor;
            sublayer.cornerRadius = 0.5;
            
            
             if( !self.horizontal ){
                 NSLog(@"vertical");

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
                
                
                startV+=(barDistV+3);

            }else{
                NSLog(@"horizontal");

                
            float eachWidth = (width/_max)*(1.0*val);
                
//            NSLog(@"values %@: is %d, height %f\n", key, val, eachWidth);
            
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
        
        self.selectedRows = [[NSMutableArray alloc] init];
        
        
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
        
 
        
        if( ([[self attr] isEqual:@"month"]) || (values.count>10) ){// ([[self attr] isEqual:@"week"]) || ([[self attr] isEqual:@"weekDay"]) ){
            self.horizontal = NO;
        } else {
            self.horizontal = YES;//horizontal bar charts
        }
   
        
        [self drawLayerContent];

        
    
  }
    return self;
}

-(void) animate:(CAShapeLayer*)shape withOpacity:(float) opaque {
    
    CABasicAnimation *animateBar = [CABasicAnimation animationWithKeyPath:@"opacity"];
    
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

//- (BOOL)acceptsFirstResponder {
//    return YES;
//}


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

-(void) rightMouseDown:(NSEvent *)event{
    NSLog(@"Right mouse down event");
    
    
    NSPoint eventLocation = [event locationInWindow];
   NSPoint locationInCurrentView = [self convertPoint:eventLocation fromView:nil];
    
    int height = (int)[self frame].size.height;
    NSLog(@"view height %d", height);
    
   long row = ([_sortedKeys count]-1)- [_sortedKeys count]*(int)locationInCurrentView.y/height; // got the bar that is clicked
  // NSString *rowKey = [_sortedKeys objectAtIndex:row];
    
   [self setPressed: row];
    
    NSMenu *theMenu = [[NSMenu alloc] initWithTitle:@"Contextual Menu"];
    
    [theMenu insertItemWithTitle:@"Keep only" action:@selector(keep:) keyEquivalent:@"" atIndex:0];
    
    [theMenu insertItemWithTitle:@"Remove" action:@selector(remove:) keyEquivalent:@"" atIndex:1];
    
    [NSMenu popUpContextMenu:theMenu withEvent:event forView:self];
    
    
}

-(void)keep:(id)sender{
//keep only
  
    [self.selectedRows removeAllObjects];
    NSNumber* nm =[NSNumber numberWithLong:[self pressed]];//only this one is the selected one now
    
    [self.selectedRows addObject:nm]; // select row

    
    for(CALayer* cl in [[self graphLayer] sublayers]){
        
        [(CAShapeLayer*)cl.sublayers[1] setOpacity: 0.5];
        [(CAShapeLayer*)cl setBorderWidth: 0.0]; //remove all the borders
    }
    
    NSMutableArray* predicates = [[NSMutableArray alloc] init];

        CALayer *modLayer = (CALayer*)[[[self graphLayer] sublayers] objectAtIndex:[self pressed] ];
        [modLayer setOpacity: 1.0];
        [modLayer setBorderColor:[NSColor lightGrayColor].CGColor];
        [modLayer setBorderWidth: 1.0];
        NSPredicate *bPredicate = [NSPredicate
                                   predicateWithFormat:@"self.%@ like %@",[self attr],[_sortedKeys
                                         objectAtIndex:[self pressed]]];
        [predicates addObject:bPredicate];
    
//    NSLog(@"Selected Row type: %@",[_sortedKeys objectAtIndex:row]);
    
    NSPredicate* cmpPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:predicates];
    if(predicates.count==0){
        cmpPredicate = [NSPredicate predicateWithFormat:@"TRUEPREDICATE"]; // OR FALSE ??
    }
    
    AppDelegate* appDelegate = [NSApp delegate];//get the app delegate of this View, very useful!
    
    [appDelegate rowClicked:[self attr] withValues: cmpPredicate];
    

}

-(void) remove:(id)sender{
    
  //remove, keep everything else
    
    [self.selectedRows removeAllObjects];

    for(int i=0; i< [[self graphValues] count];i++){
        if(i!=[self pressed]){
            
             NSNumber *aobject = [NSNumber numberWithLong:i];
            [self.selectedRows addObject:aobject];
        }
    }

    
    for(CALayer* cl in [[self graphLayer] sublayers]){
        
        [(CAShapeLayer*)cl.sublayers[1] setOpacity: 0.5];
        [(CAShapeLayer*)cl setBorderWidth: 0.0]; //remove all the borders
    }
    
    NSMutableArray* predicates = [[NSMutableArray alloc] init];
    //      NSString *rowKey = [_sortedKeys objectAtIndex:row];
    
    for(int i=0; i< [[self graphValues] count];i++){
    
        
        if(i!=[self pressed]){
       
        CALayer *modLayer = (CALayer*)[[[self graphLayer] sublayers] objectAtIndex:i ];
        [modLayer setOpacity: 1.0];
        [modLayer setBorderColor:[NSColor lightGrayColor].CGColor];
        [modLayer setBorderWidth: 1.0];
        NSPredicate *bPredicate = [NSPredicate
                                   predicateWithFormat:@"self.%@ like %@",[self attr],[_sortedKeys
                                                                                       objectAtIndex:i]];
        [predicates addObject:bPredicate];
     }
    }
    
    //    NSLog(@"Selected Row type: %@",[_sortedKeys objectAtIndex:row]);
    
    NSPredicate* cmpPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:predicates];
    if(predicates.count==0){
        cmpPredicate = [NSPredicate predicateWithFormat:@"TRUEPREDICATE"]; // OR FALSE ??
    }
    
    AppDelegate* appDelegate = [NSApp delegate];//get the app delegate of this View, very useful!
    
    [appDelegate rowClicked:[self attr] withValues: cmpPredicate];

}


-(void)keepSelected:(id)sender{
    //keep only
    
//    NSPoint eventLocation = [event locationInWindow];
//    NSPoint locationInCurrentView = [self convertPoint:eventLocation fromView:nil];
    
    int height = (int)[self frame].size.height;
    NSLog(@"view height %d", height);
    
    
    for(CALayer* cl in [[self graphLayer] sublayers]){
        
        [(CAShapeLayer*)cl.sublayers[1] setOpacity: 0.5];
        [(CAShapeLayer*)cl setBorderWidth: 0.0]; //remove all the borders
    }
    
    NSMutableArray* predicates = [[NSMutableArray alloc] init];
    //      NSString *rowKey = [_sortedKeys objectAtIndex:row];
    
    
    for(NSNumber* sel in self.selectedRows){
        CALayer *modLayer = (CALayer*)[[[self graphLayer] sublayers] objectAtIndex:sel.intValue];
        [modLayer setOpacity: 1.0];
        
        [modLayer setBorderColor:[NSColor lightGrayColor].CGColor];
        [modLayer setBorderWidth: 1.0];
        
        
        NSPredicate *bPredicate = [NSPredicate predicateWithFormat:@"self.%@ like %@",[self attr],[_sortedKeys objectAtIndex:sel.intValue]];
        [predicates addObject:bPredicate];
    }
    
    
    NSPredicate* cmpPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:predicates];
    if(predicates.count==0){
        cmpPredicate = [NSPredicate predicateWithFormat:@"TRUEPREDICATE"]; // OR FALSE ??
    }
    
    AppDelegate* appDelegate = [NSApp delegate];//get the app delegate of this View, very useful!
    
    [appDelegate rowClicked:[self attr] withValues: cmpPredicate];
    
    
}

-(void) removeSelected:(id)sender{
    
    //remove, keep everything else
    
    for(int i=0; i< [[self graphValues] count]; i++){
        
        NSNumber *robject = [NSNumber numberWithLong:i];
        BOOL found =   [self.selectedRows containsObject:robject];
        if(found){
            [[self selectedRows] removeObject:robject];//if selected, deselect
        }else{
          [[self selectedRows] addObject:robject]; //if not selected, select
        }
    }
    
    
    for(CALayer* cl in [[self graphLayer] sublayers]){
        
        [(CAShapeLayer*)cl.sublayers[1] setOpacity: 0.5];
        [(CAShapeLayer*)cl setBorderWidth: 0.0]; //remove all the borders
    }
    
    
    NSMutableArray* predicates = [[NSMutableArray alloc] init];
    //      NSString *rowKey = [_sortedKeys objectAtIndex:row];
    
    
    for(NSNumber* sel in self.selectedRows){
        CALayer *modLayer = (CALayer*)[[[self graphLayer] sublayers] objectAtIndex:sel.intValue];
        [modLayer setOpacity: 1.0];
        
        [modLayer setBorderColor:[NSColor lightGrayColor].CGColor];
        [modLayer setBorderWidth: 1.0];
        
        
        NSPredicate *bPredicate = [NSPredicate predicateWithFormat:@"self.%@ like %@",[self attr],[_sortedKeys objectAtIndex:sel.intValue]];
        [predicates addObject:bPredicate];
    }
    
   // NSLog(@"Selected Row type: %@",[_sortedKeys objectAtIndex:row]);
    
    NSPredicate* cmpPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:predicates];
    if(predicates.count==0){
        cmpPredicate = [NSPredicate predicateWithFormat:@"TRUEPREDICATE"]; // OR FALSE ??
    }
    
    AppDelegate* appDelegate = [NSApp delegate];//get the app delegate of this View, very useful!
    
    [appDelegate rowClicked:[self attr] withValues: cmpPredicate];
    
}




- (void)mouseDown:(NSEvent *)event {
    
    //check if CTRL key is also down
    
    
    NSLog(@"Mouse clicked");
    
    NSPoint eventLocation = [event locationInWindow];
    NSPoint locationInCurrentView = [self convertPoint:eventLocation fromView:nil];

    int height = (int)[self frame].size.height;
    NSLog(@"view height %d", height);
    
    long row = ([_sortedKeys count]-1)- [_sortedKeys count]*(int)locationInCurrentView.y/height; // got the bar that is clicked
    
    if( !self.horizontal ){
        row = [_sortedKeys count]*(int)locationInCurrentView.x/(int)[self frame].size.width;
    }
    NSNumber *robject = [NSNumber numberWithLong:row];
    
    BOOL found =   [self.selectedRows containsObject:robject];
    
//    BOOL found = CFArrayContainsValue ( (__bridge CFArrayRef)self.selectedRows,
//                                          CFRangeMake(0, self.selectedRows.count),
//                                          (CFNumberRef)row );
    
    if(!found){ //new selection
        [self.selectedRows addObject:robject]; // select row
        NSLog(@"select which bar %ld", row);
    }
    else { //deselect
            [self.selectedRows removeObject:robject];//if already selcted, then deselect
        NSLog(@"deselect which bar %ld", row);

        
        }
    
        for(CALayer* cl in [[self graphLayer] sublayers]){
           
            [(CAShapeLayer*)cl.sublayers[1] setOpacity: 0.5];
            [(CAShapeLayer*)cl setBorderWidth: 0.0]; //remove all the borders
        }
        
      NSMutableArray* predicates = [[NSMutableArray alloc] init];
//      NSString *rowKey = [_sortedKeys objectAtIndex:row];

        
      for(NSNumber* sel in self.selectedRows){
        CALayer *modLayer = (CALayer*)[[[self graphLayer] sublayers] objectAtIndex:sel.intValue];
        [modLayer setOpacity: 1.0];
        
          [modLayer setBorderColor:[NSColor lightGrayColor].CGColor];
        [modLayer setBorderWidth: 1.0];
        
          
          NSPredicate *bPredicate = [NSPredicate predicateWithFormat:@"self.%@ like %@",[self attr],[_sortedKeys objectAtIndex:sel.intValue]];
        [predicates addObject:bPredicate];
        }
        
      NSLog(@"Selected Row type: %@",[_sortedKeys objectAtIndex:row]);
        
        NSPredicate* cmpPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:predicates];
        if(predicates.count==0){
           cmpPredicate = [NSPredicate predicateWithFormat:@"TRUEPREDICATE"]; // OR FALSE ??
        }
        
        AppDelegate* appDelegate = [NSApp delegate];//get the app delegate of this View, very useful!
        
        [appDelegate rowClicked:[self attr] withValues: cmpPredicate];
    
    //now check if command is also pressed
    
    if ([event modifierFlags] & NSCommandKeyMask) {
        NSMenu *theMenu = [[NSMenu alloc] initWithTitle:@"Contextual Menu"];
        
        [theMenu insertItemWithTitle:@"Keep selected" action:@selector(keepSelected:) keyEquivalent:@"" atIndex:0];
        
        [theMenu insertItemWithTitle:@"Invert selection" action:@selector(removeSelected:) keyEquivalent:@"" atIndex:1];
        
        [NSMenu popUpContextMenu:theMenu withEvent:event forView:self];
        
        
    }
    
    
}

@end
