//
//  McServerController.m
//  McServer
//
//  Created by Michael Barriault on 11-09-12.
//  Copyright 2011 University of Guelph. All rights reserved.
//

#import "McServerController.h"

@implementation McServerController

- (id)init
{
    self = [super init];
    if (self) {
        theServer = [[McServer alloc] init];
        theServer.Controller = self;
    }
    
    return self;
}

-(void)dealloc {
    [theServer dealloc];
}

-(IBAction)startServer:(id)sender {
    [theServer startServer];
}

-(IBAction)stopServer:(id)sender {
    [theServer stopServer];
    [consoleView setString:@""];
}

- (IBAction)sendCommand:(id)sender {
    [theServer sendCommand:[commandField stringValue]];
    [commandField setStringValue:@""];
}

-(IBAction)help:(id)sender {
    [theServer sendCommand:@"help"];
}

-(void)consoleOutput:(NSString*)output {
//    NSLog(@"%@", output);
    [consoleView setString:[[consoleView string] stringByAppendingString:output]];
    [consoleView scrollRangeToVisible:NSMakeRange([[consoleView textStorage] length], 0)];
/*    NSClipView* clip = (NSClipView*)[consoleView superview];
    NSScrollView* scroll = (NSScrollView*)[clip superview];
    NSPoint bottomOffset = NSMakePoint(0, [scroll contentSize].height);
    [clip scrollToPoint:bottomOffset];
    [scroll reflectScrolledClipView:clip];*/
}

@end
