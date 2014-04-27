//
//  ColorMapper.m
//  CrimeFiles
//
//  Created by Sopan, Awalin on 4/16/14.
//  Copyright (c) 2014 __mstr__. All rights reserved.
//

#import "ColorMapper.h"

@implementation ColorMapper



+(NSMutableDictionary*) colorMapping:(NSArray*)dataRows{
    
    NSArray* colors = [NSArray arrayWithObjects: [NSColor redColor], [NSColor blueColor],
                       [NSColor greenColor],  [NSColor orangeColor], [NSColor magentaColor],[NSColor grayColor],
                       [NSColor purpleColor], [NSColor brownColor],[NSColor blackColor],
                       [NSColor lightGrayColor], [NSColor cyanColor], [NSColor yellowColor],
                       nil];
    
    NSMutableDictionary *colorMap = [[NSMutableDictionary alloc] init];
    
    int i=0;
    
    for(NSString *item in dataRows){
        [colorMap setObject:[colors objectAtIndex:i] forKey:item];
        i++;
    }
    
    return colorMap;
    
}

@end
