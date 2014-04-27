//
//  AnnotationForMap.m
//  CrimeFiles
//
//  Created by Sopan, Awalin on 4/10/14.
//  Copyright (c) 2014 __mstr__. All rights reserved.
//

#import "AnnotationForMap.h"
#import "CrimeData.h"
#import "CustomAnnotationView.h"

@implementation AnnotationForMap

@synthesize coordinate;
@synthesize title;
@synthesize offenseType;
@synthesize subtitle;
@synthesize record;

- (id)initWithLocation:(CLLocationCoordinate2D)coord ofType:(id)report{
    self = [super init];
    if (self) {
        coordinate = coord;
        CrimeData *rec = ((CrimeData *)report);
        [self setRecord:rec];
        
        offenseType = [rec offense];
        title = [NSString stringWithFormat:@"%@", [rec offense]];
        
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
//        NSString *formattedDateString = [dateFormatter stringFromDate:[rec reportDate]];
//        NSLog(@"formattedDateString: %@", formattedDateString);
        // Output for locale en_US: "formattedDateString: Jan 2, 2001".

        subtitle = [NSString stringWithFormat:@"%@, %@day",  [rec reportDate], [rec weekDay]];
        
    }
    return self;
}


@end
