//
//  FileReader.h
//  CrimeFiles
//
//  Created by Sopan, Awalin on 4/7/14.
//  Copyright (c) 2014 __mstr__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CrimeData;

@interface FileReader : NSObject

@property NSURL *filePath;

-(id) readDataFromFileAndCreateObject;

@end
