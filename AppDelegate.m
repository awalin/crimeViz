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
#import "GraphPaneView.h"

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
    [[self dataTable] createColumnHeaders];
    
//    NSMutableDictionary* graphs = [[NSMutableDictionary alloc] init];
//    [self setGraphViews: graphs];
    
    
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



-(void) rowClicked:(NSString*)attrib withValues:(NSPredicate*) valPredicate{
    
    
    NSLog(@"value of predicate= %@", valPredicate);
    
    NSMutableArray *highlighted = [[NSMutableArray alloc] init] ;//(NSMutableArray*)[self mapCoordinates];

    [[self predicates] setObject:valPredicate forKey:attrib];
    
    NSMutableArray *viewRecords = (NSMutableArray*)[[self dataTable] dataRows];
 
    for(id pkey in [[self predicates] allKeys]){
        NSPredicate* aPredicate= [[self predicates] objectForKey:pkey];
 
        NSLog(@"predicate in app delegate %@", aPredicate);
        viewRecords = (NSMutableArray*)[viewRecords filteredArrayUsingPredicate:aPredicate];
    
        NSLog(@"Inside %lu records are selected", (unsigned long)[viewRecords count]);
    }
    
    highlighted = (NSMutableArray*)[MetricsCalculator generateCoordinates:viewRecords forMapView:[self offenseMapView]];
    
    
    [[self offenseMapView] removeAnnotations:[[self offenseMapView] annotations]];
    [[self offenseMapView] addAnnotations:highlighted];
    
    NSLog(@"Total graphs in window: %lu", [self.graphs.graphs count]);
    
    for(id key in [self.graphs.graphs allKeys]){
     
    
        GraphView* gv = [self.graphs.graphs objectForKey:key];
        NSLog(@"graph view for %@ ", key);
        
        NSMutableDictionary *highlightValues = [MetricsCalculator calculateHistogram:key fromRows:viewRecords];

        [gv setHighlights:highlightValues];
        
        [gv drawHighlights];
            
//        [gv setNeedsDisplay:YES];
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
    
    
    self.graphs = [ [GraphPaneView alloc] initWithFrame:NSMakeRect(600.0, 50.0, 350.0, 750.0)];
   
    GraphView *gv = [[GraphView alloc]
                     initWithFrame:NSMakeRect(10.0, 10.0, 350, 200)
                                              values:[MetricsCalculator calculateHistogram:@"offense" fromRows:[[self dataTable] dataRows]]
                                             name:@"offense"
                                            colorMap: _colorMap];
    
     [self.graphs addGraph:gv];
    
    NSComboBox* cb1 = [[NSComboBox alloc] initWithFrame: NSMakeRect(10.0, 210.0, 100.0, 25.0)];
    [cb1 setIdentifier:@"first"];
    [cb1 addItemsWithObjectValues:[[self dataTable] columnHeaders]];
    [cb1 setNumberOfVisibleItems:4];
    [cb1 selectItemAtIndex:0];
    [cb1 selectItemWithObjectValue:@"offense"];
    
    [cb1 setTarget:self];

    [cb1 setAction:@selector(addGraph:)];
    
//    NSLog(@"%@", [cb1 itemObjectValueAtIndex:0]);
    [self.graphs addCombo:cb1 forKey:@"offenseC"];
    

    
    GraphView *gv2 = [[GraphView alloc]
                      initWithFrame: NSMakeRect(10.0, 250.0, 350, 200)
                                              values:[MetricsCalculator calculateHistogram:@"weekDay" fromRows:[[self dataTable] dataRows]]
                                                name:@"weekDay"
                                            colorMap: nil];
    
     [self.graphs addGraph:gv2];
    NSComboBox* cb2 = [[NSComboBox alloc] initWithFrame: NSMakeRect(10.0, 450.0, 100.0, 25.0)];
    [cb2 setIdentifier:@"second"];
    [cb2 addItemsWithObjectValues:[[self dataTable] columnHeaders]];
    [cb2 setNumberOfVisibleItems:4];
    [cb2 selectItemWithObjectValue:@"weekDay"];
//    NSLog(@"%@", [cb2 itemObjectValueAtIndex:0]);
    [self.graphs addCombo:cb2 forKey:@"weekDayC"];
  
     GraphView *gv3 = [[GraphView alloc]
                      initWithFrame:NSMakeRect(10.0, 500.0, 350, 200)
                                              values:[MetricsCalculator calculateHistogram:@"district" fromRows:[[self dataTable] dataRows]]
                                                name:@"district"
                                            colorMap: nil];
    
     [self.graphs addGraph:gv3];
    
    NSPopUpButton* pop1 = [[NSPopUpButton alloc] initWithFrame:NSMakeRect(250.0, 700.0, 100.0, 25.0) pullsDown:YES];
    [pop1 setTitle:@"settings"];
    [pop1 addItemsWithTitles:[NSArray arrayWithObjects:@"settings",@"colorize", @"vertical",nil ]];
    
    [pop1 setTarget:self];
    [pop1 setAction:@selector(changeSettings:)];
    [pop1 setIdentifier:@"pop3"];
    [self.graphs addSubview:pop1];

    
    NSComboBox* cb3 = [[NSComboBox alloc] initWithFrame: NSMakeRect(10.0, 700.0, 100.0, 25.0)];
    [cb3 setIdentifier:@"third"];
    [cb3 addItemsWithObjectValues:[[self dataTable] columnHeaders]];
    [cb3 setNumberOfVisibleItems:4];
    NSLog(@"%@", [cb3 itemObjectValueAtIndex:0]);
    [cb3 selectItemWithObjectValue:@"district"];
    [self.graphs addCombo:cb3 forKey:@"districtC"];

    //
    // the scroll view should have both horizontal and vertical scrollers
    [self.scroll setHasVerticalScroller:YES];
    [self.scroll setHasHorizontalScroller:YES];
    // set the autoresizing mask so that the scroll view will
    // resize with the window
    [self.scroll setAutoresizingMask:NSViewWidthSizable|NSViewHeightSizable];
    
    // configure the scroller to have no visible border
    [self.scroll setBorderType:NSNoBorder];
    
    [[self scroll] setDocumentView:[self graphs]];
    
    [[self scroll] setNeedsDisplay:YES];
  

}

-(void) changeSettings:(id) sender{
    NSLog(@"selected settings");
    //Change it
    NSString* attr = (NSString*)[(NSPopUpButton*) sender titleOfSelectedItem];
    NSLog(@"selected settings item: %@", attr);
    if( [[sender identifier] isEqualToString:@"pop3"] ){
        NSLog(@"pop3 selected");
        
        NSMutableDictionary* colors = [[NSMutableDictionary alloc] init];
        GraphView* gv=(GraphView*)self.graphs.subviews[4];
        NSString* atrkey = [gv attr];
        
        if([attr isEqualToString:@"colorize"]){
            
           _colorMap = [ColorMapper colorMapping:[[gv graphValues] allKeys]];
            colors = _colorMap;
            [[self offenseMapView] showAnnotations: [[self offenseMapView] annotations] animated:YES];

     
        }else {
            colors = nil;
        }
        
        
      
        
        [gv updateValues:[MetricsCalculator calculateHistogram:atrkey fromRows:[[self dataTable] dataRows]]
                    name:atrkey
                colorMap:colors];
        
        if([attr isEqualToString:@"vertical"]){
            [gv setHorizontal:NO];
        }
        
        [self.graphs.graphs setObject:gv forKey:attr];
        [gv setNeedsDisplay:YES];
        [gv drawLayerContent];
        
    }
    
    
    

}

-(IBAction) addGraph:(NSComboBoxCell*) sender{
    NSLog(@"selected comboBox ");
//    //Change it
    NSString* attr = (NSString*)[(NSComboBox*) sender objectValueOfSelectedItem];
    NSLog(@"selected comboBox item: %@", attr);
    NSMutableDictionary* colors = [[NSMutableDictionary alloc] init];
    
    if([attr isEqualToString:@"offense"]){
        colors = _colorMap;
    }else {
        colors = nil;
    }
    
    if( [[sender identifier] isEqualToString:@"first"]){
        
        GraphView* gv=(GraphView*)self.graphs.subviews[0];

        [gv updateValues:[MetricsCalculator calculateHistogram:attr fromRows:[[self dataTable] dataRows]]
                                   name:attr
                               colorMap:colors];
        
        [self.graphs.graphs setObject:gv forKey:attr];
        [gv setNeedsDisplay:YES];
        [gv drawLayerContent];
        
    } else if([[sender identifier] isEqualToString:@"second"] ){
        
          GraphView* gv=(GraphView*)self.graphs.subviews[1];
         
         [gv updateValues:[MetricsCalculator calculateHistogram:attr fromRows:[[self dataTable] dataRows]]
                     name:attr
                 colorMap:colors];
         
         [self.graphs.graphs setObject:gv forKey:attr];
         [gv setNeedsDisplay:YES];
         [gv drawLayerContent];

        
    }else if([[sender identifier] isEqualToString:@"third"] ){
        
        
        GraphView* gv=(GraphView*)self.graphs.subviews[2];
        
        [gv updateValues:[MetricsCalculator calculateHistogram:attr fromRows:[[self dataTable] dataRows]]
                    name:attr
                colorMap:colors];
        
        [self.graphs.graphs setObject:gv forKey:attr];
        [gv setNeedsDisplay:YES];
        [gv drawLayerContent];
        
    }
    
}


-(void) updateUserInterface {
    
   [self updateGraphView];
   
//    [[self graphPane] setHidden:NO];
    
    [(GraphView*)self.graphs setNeedsDisplay:YES];

    [[self offenseMapView] setHidden:NO];
   
    [self updateMapView];
    
    //TODO:show loading indication while the data structure is being populated
}




@end
