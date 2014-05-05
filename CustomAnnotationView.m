//
//  CustomAnnotationView.m
//  CrimeFiles
//
//  Created by Sopan, Awalin on 4/15/14.
//  Copyright (c) 2014 __mstr__. All rights reserved.
//

#import "CustomAnnotationView.h"
#import "AnnotationForMap.h"
#import "CrimeData.h"


@implementation CustomAnnotationView

@synthesize color;

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    // Drawing code here.
    [[self color] set];
    
    NSPoint aPoint = [self mapPoint];
    
    NSRect aRect = NSMakeRect(aPoint.x, aPoint.y, 6.0, 6.0);
    
//    NSRectFill(aRect);
    
    NSBezierPath* thePath = [NSBezierPath bezierPath];
    
    [thePath appendBezierPathWithOvalInRect:aRect];
    [thePath fill];
    
    NSGradient* grad = [[NSGradient alloc] initWithColors:[NSArray arrayWithObjects: [self  color], [self color], nil]];
    
    //if selected, highlight the border..increase the size..
    [grad  drawInBezierPath:thePath relativeCenterPosition:NSMakePoint(0.0,0.0)];
    
    
}

- (void)setAnnotation:(id <MKAnnotation>)annotation
{
    [super setAnnotation:annotation];
    
}

- (id)initWithAnnotation:(id <MKAnnotation>)annotation andPoint:(NSPoint)aPoint
               withColor:(NSDictionary*)colors reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        // Set the frame size to the appropriate values.

        CGRect  myFrame = self.frame;
        myFrame.size.width = 6;
        myFrame.size.height = 6;
        self.frame = myFrame;
//        self.mapPoint = aPoint; //Why??
        
        NSString *crimeType = [(AnnotationForMap*)[self annotation] offenseType];
        color = [colors objectForKey:crimeType];
        
        
        CrimeData* rec = [(AnnotationForMap*)[self annotation] record];

        [self setCanShowCallout:YES];
        
//        NSView* calvew = [[NSView alloc] initWithFrame: NSMakeRect(0,0,50, 30)];
        
        NSTextView* textV = [[NSTextView alloc] initWithFrame:NSMakeRect(0,0,80, 30)];
        
        [textV insertText: [NSString stringWithFormat:@"at %@ district, %@, at %@",  [rec district], [rec method], [rec shift]]];
        [textV setFont:[NSFont fontWithName:@"Helvetica" size:8.0]];
        [textV setAlignment: NSLeftTextAlignment];
        [textV setAlphaValue:0.8f];

        
        [self setRightCalloutAccessoryView:textV];
        }
    
    return self;
}

-(void) showCallout{
    
//    NSView* calvew = [[NSView alloc] initWithFrame: NSMakeRect(0,0,50, 30)];
//    
//    CALayer* callout = [CALayer layer];
//    [callout setBounds:CGRectMake(0,0,50, 30)];
//    [callout setOpacity:0.7];
//    [callout setBackgroundColor:[NSColor blueColor].CGColor];
//    CATextLayer* title = [CATextLayer layer];
//    title.string = [[self annotation] title];
//    [callout addSublayer:title];
//    
//    [calvew setWantsLayer:YES];
//    [calvew setLayer: callout];
//    
////    [self setWantsLayer:YES];
//    [self addSubview:calvew];
//    
////    [self setLeftCalloutAccessoryView:calvew];
    
    

}

@end
