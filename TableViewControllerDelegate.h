//
//  TableViewControllerDelegate.h
//  CrimeFiles
//
//  Created by Sopan, Awalin on 4/10/14.
//  Copyright (c) 2014 __mstr__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DataTable;

@interface TableViewControllerDelegate : NSObject<NSTableViewDelegate, NSTableViewDataSource>

@property (weak) IBOutlet NSTableView *offenseTable;
@property (strong) DataTable *dataSource;

-(NSInteger)numberOfRowsInTableView: (NSTableView *) aTableView;
//-(NSView *)tableView: (NSTableView *)tableView
//viewForTableColumn:(NSTableColumn *) tableColumn
//row:(NSInterger)row


//tableView:objectValueForTableColumn:row:
//tableView:setObjectValue:forTableColumn:row: (cell-based tables only)



@end
