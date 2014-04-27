//
//  FileBrowser.m
//  CrimeFiles
//
//  Created by Sopan, Awalin on 4/7/14.
//  Copyright (c) 2014 __mstr__. All rights reserved.
//

#import "FileBrowser.h"

@implementation FileBrowser

-(int) openFileBrowserWindow {
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
    
    // Enable options in the dialog.
    
    [openDlg setCanChooseFiles:YES];
    
    [openDlg setAllowsMultipleSelection:FALSE];
    
    // Display the dialog box. If the OK pressed, process the files.
    
    if ([openDlg runModal] == NSOKButton ) {
        
        // Gets list of all files selected
        
        NSArray *files = [openDlg URLs];
        [openDlg close];
        
        // Loop through the files and process them.
        
        [self setFilePath: [files objectAtIndex:0]];
        
        return 1;
    }
    
    [openDlg close];
    
    return 0;

}

@end
