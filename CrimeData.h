//
//  CrimeData.h
//  CrimeFiles
//
//  Created by Sopan, Awalin on 4/7/14.
//  Copyright (c) 2014 __mstr__. All rights reserved.
//

#import <Foundation/Foundation.h>
//@class CLLocationDegrees;
@interface CrimeData : NSObject

@property NSString *crimeId;
@property NSDate *reportDate;
@property NSString *month;
@property NSString *weekDay;
@property NSString *week;
@property NSString *shift;
@property NSString *offense;
@property NSString *method;
@property NSString *district;
@property double latitude;
@property double longitude;
@property NSString *ward;



-(CrimeData*) createCrimeDataObject:(NSArray *)fromFile;
-(void) printRow;



@end
