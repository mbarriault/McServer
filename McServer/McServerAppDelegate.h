//
//  McServerAppDelegate.h
//  McServer
//
//  Created by Michael Barriault on 11-09-12.
//  Copyright 2011 University of Guelph. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface McServerAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
}

@property (assign) IBOutlet NSWindow *window;

@end
