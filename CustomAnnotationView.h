//
//  CustomAnnotationView.h
//  CrimeFiles
//
//  Created by Sopan, Awalin on 4/15/14.
//  Copyright (c) 2014 __mstr__. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h>

@class AnnotationForMap;


@interface CustomAnnotationView : MKAnnotationView

@property NSPoint mapPoint;
@property NSColor* color;

- (id)initWithAnnotation:(id <MKAnnotation>)annotation andPoint:(NSPoint)aPoint
               withColor:(NSDictionary*)colors
               reuseIdentifier:(NSString *)reuseIdentifier;

-(void) showCallout;

@end
