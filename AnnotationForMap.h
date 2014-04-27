//
//  AnnotationForMap.h
//  CrimeFiles
//
//  Created by Sopan, Awalin on 4/10/14.
//  Copyright (c) 2014 __mstr__. All rights reserved.
//


#import <MapKit/MapKit.h>

#import <Foundation/Foundation.h>
@class CustomAnnotationView;
@class CrimeData;

@interface AnnotationForMap : NSObject<MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, copy) NSString *subtitle;
@property NSString* offenseType;
@property CrimeData* record;


- (id)initWithLocation:(CLLocationCoordinate2D)coord ofType:(id) offenseType;
// Other methods and properties.

@end
