//
//  McServerController.h
//  McServer
//
//  Created by Michael Barriault on 11-09-12.
//  Copyright 2011 University of Guelph. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "McServer.h"
#import <CocoaMondoKit/CocoaMondoKit.h>

@interface McServerController : NSObject {
    McServer* theServer;
    
    IBOutlet NSTextField* commandField;
    IBOutlet NSTextView* consoleView;
    
    IBOutlet MondoSwitch* bigSwitch;
    IBOutlet NSProgressIndicator* progressIndicator;

    IBOutlet NSTextField* chatField;
    IBOutlet NSTextView* chatView;
    
}
- (IBAction)sendCommand:(id)sender;

- (IBAction)startServer:(id)sender;
- (IBAction)stopServer:(id)sender;
- (IBAction)startStopServer:(id)sender;

- (IBAction)sendChat:(id)sender;
@end
