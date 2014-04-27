//
//  TableViewControllerDelegate.m
//  CrimeFiles
//
//  Created by Sopan, Awalin on 4/10/14.
//  Copyright (c) 2014 __mstr__. All rights reserved.
//

#import "TableViewControllerDelegate.h"
#import "DataTable.h"


@implementation TableViewControllerDelegate

-(NSInteger)numberOfRowsInTableView: (NSTableView *) aTableView{
    return [[_dataSource dataRows] count];
}
@end
