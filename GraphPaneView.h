//
//  GraphPaneView.h
//  CrimeFiles
//
//  Created by Sopan, Awalin on 5/6/14.
//  Copyright (c) 2014 __mstr__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class GraphView;

@interface GraphPaneView : NSView


@property NSMutableDictionary* graphs;
@property NSMutableDictionary* checkBoxes;

-(void) addGraph:(GraphView*) aGraph;
-(void) addCombo:(NSComboBox*) aGraph forKey:(NSString*) attr;
@end
