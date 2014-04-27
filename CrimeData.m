//
//  CrimeData.m
//  CrimeFiles
//
//  Created by Sopan, Awalin on 4/7/14.
//  Copyright (c) 2014 __mstr__. All rights reserved.
//

#import "CrimeData.h"

@implementation CrimeData



-(CrimeData*) createCrimeDataObject:(NSArray *)fromFile {
    
    [self setCrimeId:[fromFile objectAtIndex:0] ];
    [self setReportDate:[fromFile objectAtIndex:1] ];
    [self setMonth:[fromFile objectAtIndex:2] ];
    [self setWeekDay:[[fromFile objectAtIndex:3] substringFromIndex:2]];
    [self setWeek:[fromFile objectAtIndex:4]];
    [self setShift:[fromFile objectAtIndex:5]];
    [self setOffense:[fromFile objectAtIndex:6] ];
    [self setMethod:[fromFile objectAtIndex:7] ];
    [self setLatitude:[[fromFile objectAtIndex:8]  doubleValue]];
    [self setLongitude:[[fromFile objectAtIndex:9] doubleValue]];
    [self setDistrict:[fromFile objectAtIndex:10] ];
    
    return self;
}


-(void) printRow{



}



@end
