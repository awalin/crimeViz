//
//  GraphPaneView.m
//  CrimeFiles
//
//  Created by Sopan, Awalin on 5/6/14.
//  Copyright (c) 2014 __mstr__. All rights reserved.
//

#import "GraphPaneView.h"
#import "GraphView.h"

@implementation GraphPaneView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        self.graphs = [[NSMutableDictionary alloc] init];
        self.checkBoxes = [[NSMutableDictionary alloc] init];
        }
    return self;
}


-(void) addGraph:(GraphView*) aGraph{
    
    [self.graphs setObject:aGraph forKey:[aGraph attr]];//add to dict
    [self addSubview:[self.graphs objectForKey:[aGraph attr]]]; // add to view 
}


-(void) addCombo:(NSComboBox*) aGraph forKey:(NSString*) attr{
    
    [self.checkBoxes setObject:aGraph forKey:attr];//add to dict
    [self addSubview:[self.checkBoxes objectForKey:attr]]; // add to view
}


- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    // Drawing code here.
    for(GraphView* aGraph in self.subviews){//subviews can be anything
        [aGraph setNeedsDisplay:YES];
    }
    
}

@end
