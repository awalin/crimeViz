//
//  FileReader.m
//  CrimeFiles
//
//  Created by Sopan, Awalin on 4/7/14.
//  Copyright (c) 2014 __mstr__. All rights reserved.
//

#import "FileReader.h"
#import "CrimeData.h"

@implementation FileReader

-(id) readDataFromFileAndCreateObject{

    NSURL *URL = self.filePath;
    
    NSLog(@"Reading the file %@", _filePath);
    NSError *error;
    NSString *stringFromFileAtURL = [[NSString alloc]
                                     initWithContentsOfURL:_filePath
                                     encoding:NSUTF8StringEncoding
                                     error:&error];
    if (stringFromFileAtURL == nil) {
        // an error occurred
        NSLog(@"Error reading file at %@\n%@",
              _filePath, [error localizedFailureReason]);
        // implementation continues ...
    }
    
    
    //pull the content from the file into memory
    NSData* data = [NSData dataWithContentsOfURL:URL];
    //convert the bytes from the file into a string
    NSString *fileContent = [NSString stringWithUTF8String:[data bytes]];
    
    //split the string around newline characters to create an array
    NSString* delimiter = @"\n";
    NSArray* items = [fileContent componentsSeparatedByString:delimiter];
    
    NSLog(@"Total rows: %lu", (unsigned long)[items count]);
    
    NSMutableArray *crimeData = [[NSMutableArray alloc] init];
    
 //start  showing progress bar here, sends message to the controller//
 //parse the line and create the objects
    for(int i=2; i<[items count]; i++){ // skip the first two lines of the file, so i = 2//
//        NSLog(@"%d, %@",i,[items objectAtIndex:i]);
        NSString* strsInOneLine = [items objectAtIndex:i];
        
        // choose whatever input identity you have decided. in this case ;
        NSArray* singleStrs = [strsInOneLine componentsSeparatedByCharactersInSet:
                               [NSCharacterSet characterSetWithCharactersInString:@"\t"]];
        
        
        CrimeData *aCrime = [[CrimeData alloc] init];
        //here populate the array objects
        [aCrime createCrimeDataObject: singleStrs];
        [crimeData addObject:aCrime];//adding the new object to the array
     }
    
    //now I have populated the allCrimeData array// as an alternative I can pass the reference to the main array here, and populate the original one
    
    //stop showing progress bar here, sends message to teh controller//
    
    return crimeData;
    

}

@end
