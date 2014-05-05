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
    
//    NSArray* colors = [NSArray arrayWithObjects: [NSColor redColor], [NSColor blueColor],
//                       [NSColor greenColor],  [NSColor orangeColor], [NSColor magentaColor],[NSColor grayColor],
//                       [NSColor purpleColor], [NSColor brownColor],[NSColor blackColor],
//                       [NSColor lightGrayColor], [NSColor cyanColor], [NSColor yellowColor],
//                       nil];
    
    NSArray* colors = [NSArray arrayWithObjects:@"8dd3c7",
                                                @"ffffb3",
                                @"bebada",
                                @"fb8072",
                                @"80b1d3",
                                @"fdb462",
                                @"b3de69",
                                @"fccde5", nil];//Color brewer
    
    NSMutableDictionary *colorMap = [[NSMutableDictionary alloc] init];
    
    int i=0;
    
    for(NSString *item in dataRows){
        [colorMap setObject: [self colorWithHexColorString:[colors objectAtIndex:i]] forKey:item];
        i++;
    }
    
    return colorMap;
    
}

+ (NSColor*)colorWithHexColorString:(NSString*)inColorString
{
    NSColor* result = nil;
    unsigned colorCode = 0;
    unsigned char redByte, greenByte, blueByte;
    
    if (nil != inColorString)
    {
        NSScanner* scanner = [NSScanner scannerWithString:inColorString];
        (void) [scanner scanHexInt:&colorCode]; // ignore error
    }
    redByte = (unsigned char)(colorCode >> 16);
    greenByte = (unsigned char)(colorCode >> 8);
    blueByte = (unsigned char)(colorCode); // masks off high bits
    
    result = [NSColor
              colorWithCalibratedRed:(CGFloat)redByte / 0xff
              green:(CGFloat)greenByte / 0xff
              blue:(CGFloat)blueByte / 0xff
              alpha:1.0];
    return result;
}

@end
