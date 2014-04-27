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
    
    NSDictionary *colors = [[NSDictionary alloc] init];
    [self setColorMap:colors];
    
    self.predicates = [[NSMutableArray alloc] init];
    
    //this is the array of all the crimes. Need to fix the data types.
    DataTable *aTable = [[DataTable alloc] init];
    [self setDataTable:aTable];
    
    }

-(NSInteger)numberOfRowsInTableView: (NSTableView *) aTableView{
    
    return [_offenseDist count];
}


-(id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex{

    if([[aTableColumn identifier]  isEqual: @"OffenseType"]){
        return [_keys objectAtIndex:rowIndex];
    }
    return [_values objectAtIndex:rowIndex];
}



- (IBAction)openFileBrowser:(id)sender {
    NSLog(@"received a open file browser message");
    
    int ifFileChosen = [self.fileBrowser openFileBrowserWindow];
    //NSLog(@"fileChosen %d",ifFileChosen);
    NSLog(@"You have chosen the file %@", [self.fileBrowser filePath]);
    
    if (ifFileChosen==1) {
        
        [self.fileReader setFilePath:[self.fileBrowser filePath]];
        
        [sender removeFromSuperview];//remove the button
        
        [[self dataTable] setDataRows: [self.fileReader readDataFromFileAndCreateObject]];
        
        _dataOnView = [[NSMutableArray alloc] initWithArray:[[self dataTable] dataRows]];
        
//        NSLog(@"%@", _dataOnView);
        
        //TODO: pass the string to create the column names
        [[self dataTable] createColumnHeaders];
       
        ////////Creating Table Data////////////////////
        _offenseDist = [MetricsCalculator calculateHistogram:@"offense" fromRows:[[self dataTable] dataRows]];
        
        _keys = [_offenseDist allKeys];
        _values =[_offenseDist allValues];
        
        [self setColorMap:[ColorMapper colorMapping:_keys]];
        
        [self updateUserInterface];
//         NSLog(@"Updated Interface");
        
       
    }
    
}



-(void) rowClicked:(NSString*)attr withValue:(NSString*) val{
    
//create / update predicate array//create NSCompound Predicate
    NSPredicate *bPredicate = [NSPredicate predicateWithFormat:@"record.%@ like %@", attr, val];
    
    NSLog(@"%@", bPredicate);
    
    NSMutableArray *highlighted = (NSMutableArray*)[self mapCoordinates];
    
  //  id pd = [NSString stringWithFormat:@"%@,%@",attr,val];

    [[self predicates] addObject:bPredicate];
    
//    NSLog(@"%@", [[self predicates] allKeys]);
    
//    for(NSPredicate* aPredicate in [self predicates]){
    
    NSPredicate* aPredicate = bPredicate;
//        NSLog(@"Predicate %@", aPredicate);
        
        highlighted = (NSMutableArray*)[highlighted filteredArrayUsingPredicate:aPredicate];
        
        NSLog(@"Inside %lu annotations are highlighted", (unsigned long)[highlighted count]);
//    }
    
   
    NSLog(@"%lu annotations are highlighted", (unsigned long)[highlighted count]);
    //Now update the views
    
    [[self offenseMapView] removeAnnotations:[[self offenseMapView] annotations]];
    
    [[self offenseMapView] addAnnotations:highlighted];


}


- (void)mapViewWillStartLoadingMap:(MKMapView *)mapView{
    

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
   
    GraphView *gv = [[GraphView alloc] initWithFrame:NSMakeRect(500.0, 300.0, 300, 200)];
    [[self subViews] setObject:gv forKey:@"offense"];
    [gv setValues: [self offenseDist] forAttr:@"offense" andColorMap: _colorMap];
    [gv setHidden: NO];
    [self.window.contentView addSubview: gv];
    [gv setNeedsDisplay:YES];
}

-(IBAction) addGraph:(id)sender{
    
    NSString* attr = (NSString*)[(NSComboBox*) sender objectValueOfSelectedItem];
    NSLog(@"selected comboBox item %@", attr);
    GraphView *gv = [[GraphView alloc] initWithFrame:NSMakeRect(500.0, 50.0, 300, 200)];
    [[self subViews] setObject:gv forKey:attr];
    [gv setValues:[MetricsCalculator calculateHistogram:attr fromRows:[[self dataTable] dataRows]] forAttr:attr andColorMap:nil];
    [gv setHidden: NO];
    [self.window.contentView addSubview: gv];
    [gv setNeedsDisplay:YES];
}


-(void) updateUserInterface {
    
//    [[self offenseTable] setHidden:NO];
    [[self offenseMapView] setHidden:NO];
    [self updateGraphView];
    [self updateMapView];
    //TODO:show loading indication while the data structure is being populated
}


// This method is optional if you use bindings to provide the data
- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {

    
    NSString *identifier = [tableColumn identifier];
    
    if ([identifier isEqualToString:@"OffenseType"]) {
        NSTableCellView *cellView = [tableView makeViewWithIdentifier:identifier owner:self];
//        // Then setup properties on the cellView based on the column
        cellView.textField.stringValue = [_keys objectAtIndex:row];
        return cellView;
        
    } else {
//        NSLog(@"count column");
        
        
        NSTableCellView *cellView = [tableView makeViewWithIdentifier:identifier owner:self];
        //        // Then setup properties on the cellView based on the column
        cellView.textField.stringValue = [_values objectAtIndex:row];
        return cellView;

    }
    
    return nil;
}



@end
