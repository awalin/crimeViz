//
//  AppDelegate.m
//  CrimeFiles
//
//  Created by Sopan, Awalin on 4/7/14.
//  Copyright (c) 2014 __mstr__. All rights reserved.
//

#import "AppDelegate.h"
#import "FileBrowser.h"
#import "FileReader.h"
#import "DataTable.h"
#import "MetricsCalculator.h"
#import "ColorMapper.h"
#import "AnnotationForMap.h"
#import "CustomAnnotationView.h"
#import "GraphView.h"
#import "CustomCellView.h"
#import "WeekDayView.h"
#import "CrimeData.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {

    
    FileBrowser *aBrowser = [[FileBrowser alloc] init];
    [self setFileBrowser:aBrowser];
    
    FileReader *aReader = [[FileReader alloc] init];
    [self setFileReader:aReader];
    
    NSMutableDictionary *dist = [[NSMutableDictionary alloc] init];
    [self setOffenseDist:dist];
    
    NSMutableDictionary *colors = [[NSMutableDictionary alloc] init];
    [self setColorMap:colors];
    
    self.predicates = [[NSMutableDictionary alloc] init];
    
    //this is the array of all the crimes. Need to fix the data types.
    DataTable *aTable = [[DataTable alloc] init];
    [self setDataTable:aTable];
    
    NSMutableDictionary* graphs = [[NSMutableDictionary alloc] init];
    [self setGraphViews: graphs];
    
    
    NSURL* path = [[NSURL alloc] initWithString: @"file:///Users/asopan/Desktop/Test.txt"];

        [self.fileReader setFilePath:path];
        
        [[self dataTable] setDataRows: [self.fileReader readDataFromFileAndCreateObject]];
        
        _dataOnView = [[NSMutableArray alloc] initWithArray:[[self dataTable] dataRows]];
        
        _offenseDist = [MetricsCalculator calculateHistogram:@"offense" fromRows:[[self dataTable] dataRows]];
        
        _keys = [_offenseDist allKeys];
        _values =[_offenseDist allValues];
        
        [self setColorMap:[ColorMapper colorMapping:_keys]];
        
        [self updateUserInterface];
        
    
    }

-(NSInteger)numberOfRowsInTableView: (NSTableView *) aTableView{
    
    return [_offenseDist count];
}


- (IBAction)openFileBrowser:(id)sender {
    NSLog(@"received a open file browser message");
    
    int ifFileChosen = [self.fileBrowser openFileBrowserWindow];
    //NSLog(@"fileChosen %d",ifFileChosen);
    NSLog(@"You have chosen the file %@", [self.fileBrowser filePath]);
    
//    NSURL* path = [[NSURL alloc] initWithString: @"/Users/asopan/Desktop/Test.txt"];
    
    if (ifFileChosen==1)
    {
        
        [self.fileReader setFilePath:[self.fileBrowser filePath]];
//         [self.fileReader setFilePath:path];
        
        [sender removeFromSuperview];//remove the button
        
        [[self dataTable] setDataRows: [self.fileReader readDataFromFileAndCreateObject]];
        
        _dataOnView = [[NSMutableArray alloc] initWithArray:[[self dataTable] dataRows]];
        
//        NSLog(@"%@", _dataOnView);
       
        ////////Creating Table Data////////////////////
        _offenseDist = [MetricsCalculator calculateHistogram:@"offense" fromRows:[[self dataTable] dataRows]];
        
        _keys = [_offenseDist allKeys];
        _values =[_offenseDist allValues];
        
        [self setColorMap:[ColorMapper colorMapping:_keys]];
        
        [self updateUserInterface];
//         NSLog(@"Updated Interface");
        
       
    }
    
}



-(void) rowClicked:(NSString*)attrib withValue:(NSString*) val{
    
//create / update predicate array//create NSCompound Predicate
    NSPredicate *bPredicate = [NSPredicate predicateWithFormat:@"self.%@ like %@", attrib, val];
    
    NSLog(@"predicate= %@", bPredicate);
    
    NSMutableArray *highlighted = [[NSMutableArray alloc] init] ;//(NSMutableArray*)[self mapCoordinates];
    
    if(![[self predicates] objectForKey:attrib]){
        [[self predicates] setObject:bPredicate forKey:attrib];
    }
    else{
        NSPredicate* cmp = [NSCompoundPredicate orPredicateWithSubpredicates:[NSArray arrayWithObjects:bPredicate,
                                                                                       [[self predicates] objectForKey:attrib],nil]];
        [[self predicates] setObject:cmp forKey:attrib];
    }
    
    NSMutableArray *viewRecords = (NSMutableArray*)[[self dataTable] dataRows];
 
    for(id pkey in [[self predicates] allKeys]){
        NSPredicate* aPredicate= [[self predicates] objectForKey:pkey];
 
        NSLog(@"%@", aPredicate);
        viewRecords = (NSMutableArray*)[viewRecords filteredArrayUsingPredicate:aPredicate];
    
        NSLog(@"Inside %lu records are selected", (unsigned long)[viewRecords count]);
    }
    
    highlighted = (NSMutableArray*)[MetricsCalculator generateCoordinates:viewRecords forMapView:[self offenseMapView]];
    
    
    [[self offenseMapView] removeAnnotations:[[self offenseMapView] annotations]];
    [[self offenseMapView] addAnnotations:highlighted];
    
    NSLog(@"Total graphs in window: %lu", [[self graphViews] count]);
    
    for(id key in [[self graphViews] allKeys]){
        if([key isEqualToString:attrib]){
            continue;
        }else{
        GraphView* gv = [[self graphViews] objectForKey:key];
        NSLog(@"graph view for %@ ",  key);
        
        NSMutableDictionary *highlightValues = [MetricsCalculator calculateHistogram:key fromRows:viewRecords];

        [gv setHighlights:highlightValues];
    
//       NSLog(@"graph view for %@, #of highlights %lu ",  [gv attr], [ [gv highlights] count]);
//    [(GraphView*)[[self subViews] objectForKey:attr] drawHighlights];
        
            [gv drawHighlights];
            
            
//            [gv setNeedsDisplay:YES];
        }
    }

}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id < MKAnnotation >)annotation {

    
    AnnotationForMap *annot = (AnnotationForMap*)annotation;
    NSPoint mapPoint = [mapView convertCoordinate:[annot coordinate] toPointToView: mapView];
//    CrimeData* cd = [annot record];
    NSColor *color = [[self colorMap] objectForKey:[annot offenseType]];
    
    CustomAnnotationView *annotationView = (CustomAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"crimeReportAnnotation"];
    
    
    if(annotationView == nil){
        
        annotationView = [[CustomAnnotationView alloc]
                                                initWithAnnotation:annot
                                                andPoint:mapPoint
                                                withColor:[self colorMap]
                                                reuseIdentifier:@"crimeReportAnnotation"];        
        annotationView.enabled = YES;
        annotationView.canShowCallout=YES;
//        NSLog(@"Drawing: Color %@, Crime %@", [annotationView color], [(AnnotationForMap*)[annotationView annotation] offenseType]);
        
    }else {
    
        [annotationView setAnnotation: annot];
        [annotationView setColor:color];//why do I need to set the color again?
        
//          NSLog(@"Redrawing: Color %@, Crime %@", [annotationView color], [(AnnotationForMap*)[annotationView annotation] offenseType]);
   
        
    }
    
    return annotationView;

}
-(void) updateMapView {
    
    ///////Creating Map Data ///////
//    NSLog(@"before adding annotation to map");
    CLLocationCoordinate2D center =  CLLocationCoordinate2DMake(-77.0367,38.8951) ;
    MKCoordinateSpan span = MKCoordinateSpanMake(90.00, 90.00);
    MKCoordinateRegion newRegion = MKCoordinateRegionMake(center, span);
    [[self offenseMapView] setRegion: newRegion animated:YES];
    
    [self setMapCoordinates: [MetricsCalculator generateCoordinates:[[self dataTable] dataRows] forMapView:[self offenseMapView]]];
    
    [[self offenseMapView] addAnnotations: [self mapCoordinates]];//or add  them during generation
    
    [[self offenseMapView] showAnnotations: [[self offenseMapView] annotations] animated:YES];
    
    
//    NSLog(@"added annotation to map");
}

-(void) updateGraphView{
   
    GraphView *gv = [[GraphView alloc]
                     initWithFrame:NSMakeRect(750, 650.0, 350, 200)
                                              values:[MetricsCalculator calculateHistogram:@"offense" fromRows:[[self dataTable] dataRows]]
                                             name:@"offense"
                                            colorMap: _colorMap];
    
    [self setFirstGraph:gv];
    [[self graphViews] setObject:[self firstGraph] forKey:@"offense"];
    [self.window.contentView addSubview: [self firstGraph]];
    
    
    GraphView *gv2 = [[GraphView alloc]
                      initWithFrame: NSMakeRect(750.0, 350.0, 350, 200)
                                              values:[MetricsCalculator calculateHistogram:@"weekDay" fromRows:[[self dataTable] dataRows]]
                                                name:@"weekDay"
                                            colorMap: nil];
    [self setSecondGraph:gv2];
    [[self graphViews] setObject:[self secondGraph] forKey:@"weekDay"];
    [self.window.contentView addSubview: [self secondGraph]];
    
   
    
    
    GraphView *gv3 = [[GraphView alloc]
                      initWithFrame:NSMakeRect(750.0, 50.0, 350, 200)
                                              values:[MetricsCalculator calculateHistogram:@"district" fromRows:[[self dataTable] dataRows]]
                                                name:@"district"
                                            colorMap: nil];
    [self setThirdGraph:gv3];
    [[self graphViews] setObject:[self thirdGraph] forKey:@"district"];
    [self.window.contentView addSubview: [self thirdGraph]];
    

}

-(IBAction) addGraph:(id)sender{
    //Change it
    NSString* attr = (NSString*)[(NSComboBox*) sender objectValueOfSelectedItem];
    NSLog(@"selected comboBox item: %@", attr);
    NSMutableDictionary* colors = [[NSMutableDictionary alloc] init];
    
    if([attr isEqualToString:@"offense"]){
        colors = _colorMap;
    }else {
        colors = nil;
    }
    
    if( [[sender identifier] isEqualToString:@"firstBox"]){
        //First remove the graph from the dictionary//
        
//        [self graphViews]
//        [[self graphViews] removeObject:[self firstGraph] ];
        

        [[self firstGraph] updateValues:[MetricsCalculator calculateHistogram:attr fromRows:[[self dataTable] dataRows]]
                                   name:attr
                               colorMap:colors];
        
        [[self graphViews] setObject:[self firstGraph] forKey:attr];
        [[self firstGraph] setNeedsDisplay:YES];
        [[self firstGraph] drawLayerContent];
        
    } else if([[sender identifier] isEqualToString:@"secondBox"] ){
        
        [[self secondGraph] updateValues:[MetricsCalculator calculateHistogram:attr fromRows:[[self dataTable] dataRows]]
                                   name:attr
                               colorMap:colors];
       
        [[self graphViews] setObject:[self secondGraph] forKey:attr];
        [[self secondGraph] setNeedsDisplay:YES];
        [[self secondGraph] drawLayerContent];

        
    }else if([[sender identifier] isEqualToString:@"thirdBox"] ){
        
        
        [[self thirdGraph] updateValues:[MetricsCalculator calculateHistogram:attr fromRows:[[self dataTable] dataRows]]
                                   name:attr
                               colorMap:colors];
        
        [[self graphViews] setObject:[self thirdGraph] forKey:attr];
        [[self thirdGraph] setNeedsDisplay:YES];
        [[self thirdGraph] drawLayerContent];

        
    }
    
}


-(void) updateUserInterface {
    
   [self updateGraphView];
   
//    [[self graphPane] setHidden:NO];
    [[self firstGraph] setNeedsDisplay:YES];
    [[self secondGraph] setNeedsDisplay:YES];
    [[self thirdGraph] setNeedsDisplay:YES];
    
    
//    [[self graphPane] setNeedsDisplay:YES];
    
    [[self offenseMapView] setHidden:NO];
   
    [self updateMapView];
    
    //TODO:show loading indication while the data structure is being populated
}




@end
