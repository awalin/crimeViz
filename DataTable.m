//
//  DataTable.m
//  CrimeFiles
//
//  Created by Sopan, Awalin on 4/8/14.
//  Copyright (c) 2014 __mstr__. All rights reserved.
//

#import "DataTable.h"
#import "CrimeData.h"

@implementation DataTable

-(void) createColumnHeaders {
    //should be created through File reading
    //TODO: create a dictionary of column names, read the first line of the file
//    
//    _columnHeaders = @{
//                     @"CrimeId":[NSNumber numberWithInt:0],
//                     //                     @"CrimeDate": [NSNumber numberWithInt:13],
//                     @"ReportMonth": [NSNumber numberWithInt:2],
//                     //                     @"":[NSNumber numberWithInt:13],
//                     @"Lattitude":[NSNumber numberWithInt:9],
//                     @"Longitude":[NSNumber numberWithInt:10],
//                     };
    
    
    _columnHeaders = [[NSArray alloc] initWithObjects:
                         @"offense"
                         @"month",
                         @"week",
                         nil];

    
}

-(void) printRows{
    for(CrimeData *item in [self dataRows]){
        NSLog(@"from crime data array in app delegate: %f,%f\n",[item latitude],[item longitude]);
    }
}



@end
