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
@class GraphPaneView;


#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h>
//the protocols should be in data model ,not in controller//Fix it later//

@interface AppDelegate : NSObject <NSTableViewDataSource, NSTableViewDelegate, MKMapViewDelegate>

@property (strong) FileBrowser *fileBrowser;
@property (strong) FileReader  *fileReader;
@property (strong) DataTable *dataTable;
@property (strong) GraphPaneView *graphs;
@property (strong) NSMutableArray *dataOnView;
@property (strong) NSMutableDictionary *offenseDist;
@property (strong) NSMutableDictionary *weeklyDist;
@property (strong) NSMutableDictionary* colorMap;
@property (strong) NSArray *keys;
@property (strong) NSArray *values;
@property (strong) NSArray *mapCoordinates;
@property (weak) MKAnnotationView *anotView;
@property NSInteger selectedRow;
@property NSMutableDictionary *predicates;
@property (weak) IBOutlet NSScrollView *scroll;
@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet MKMapView *offenseMapView;
@property (weak) IBOutlet NSView* graphPane;
@property IBOutlet NSComboBox *first;
@property IBOutlet NSComboBox *second;
@property IBOutlet NSComboBox *third;

-(void) changeSettings:(id) sender;
//- (NSInteger)numberOfItemsInComboBox:(NSComboBox *)aComboBox;
-(void) updateGraphView;

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id < MKAnnotation >)annotation;

-(void) updateMapView;
-(IBAction) addGraph:(id)sender;
-(IBAction) openFileBrowser:(id)sender;
-(void) rowClicked:(NSString*)attr withValues:(NSPredicate*) val;


@end
