//
//  AppDelegate.h
//  CrimeFiles
//
//  Created by Sopan, Awalin on 4/7/14.
//  Copyright (c) 2014 __mstr__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class FileBrowser;
@class FileReader;
@class DataTable;
@class MetricsCalculator;
@class ColorMapper;
@class AnnotationForMap;
@class CustomAnnotationView;
@class GraphView;
@class CustomCellView;
@class WeekDayView;


#import <MapKit/MapKit.h>
//the protocols should be in data model ,not in controller//Fix it later//

@interface AppDelegate : NSObject <NSTableViewDataSource, NSTableViewDelegate, MKMapViewDelegate>



@property (strong) FileBrowser *fileBrowser;
@property (strong) FileReader  *fileReader;
@property (strong) DataTable *dataTable;
@property (strong) NSMutableArray *dataOnView;
@property (strong) NSMutableDictionary *offenseDist;
@property (strong) NSMutableDictionary *weeklyDist;
@property (strong) NSMutableDictionary* colorMap;
@property (strong) NSArray *keys;
@property (strong) NSArray *values;
@property (strong) NSArray *mapCoordinates;
@property (weak) MKAnnotationView *anotView;
@property NSInteger selectedRow;
@property NSMutableDictionary *graphViews;
@property  GraphView* firstGraph;
@property  GraphView* secondGraph;
@property  GraphView* thirdGraph;
@property NSMutableDictionary *predicates;
@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet MKMapView *offenseMapView;
//@property (weak) IBOutlet NSScrollView* graphPane;
@property (weak) IBOutlet NSComboBox* firstBox;
@property (weak) IBOutlet NSComboBox* secondBox;
@property (weak) IBOutlet NSComboBox* thirdBox;


-(void) updateGraphView;

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id < MKAnnotation >)annotation;

-(void) updateMapView;
-(IBAction) addGraph:(id)sender;
-(IBAction) openFileBrowser:(id)sender;
-(void) rowClicked:(NSString*)attr withValue:(NSString*) val;


@end
