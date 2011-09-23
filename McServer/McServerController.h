//
//  McServerController.h
//  McServer
//
//  Created by Michael Barriault on 11-09-12.
//  Copyright 2011 University of Guelph. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "McServer.h"

@interface McServerController : NSObject {
    McServer* theServer;
    IBOutlet NSTextField *commandField;
    IBOutlet NSTextView* consoleView;
}
- (IBAction)startServer:(id)sender;
- (IBAction)stopServer:(id)sender;
- (IBAction)sendCommand:(id)sender;
- (IBAction)help:(id)sender;
@end
