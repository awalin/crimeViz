//
//  DataTable.h
//  CrimeFiles
//
//  Created by Sopan, Awalin on 4/8/14.
//  Copyright (c) 2014 __mstr__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CrimeData;
@class NSTableView;

@interface DataTable :NSObject


@property (strong) NSArray  *dataRows;
@property (strong) NSArray *columnHeaders;




-(void) createColumnHeaders;

-(void) printRows;


@end
