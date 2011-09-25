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

-(void)awakeFromNib {
    [bigSwitch setAction:@selector(startStopServer:)];
    [bigSwitch setTarget:self];
    [progressIndicator setHidden:YES];
}

-(void)dealloc {
    [theServer dealloc];
}

-(IBAction)startServer:(id)sender {
    [consoleView setString:@""];
    [self startSpinner];
    [theServer startServer];
    [self stopSpinner];
}

-(IBAction)stopServer:(id)sender {
    [theServer stopServer];
}

-(void)startSpinner {
    [progressIndicator setHidden:NO];
    [progressIndicator startAnimation:self];
}

-(void)stopSpinner {
    [progressIndicator stopAnimation:self];
    [progressIndicator setHidden:YES];
}

-(IBAction)startStopServer:(id)sender {
    if ( bigSwitch.on ) [self startServer:sender];
    else [self stopServer:sender];
}

- (IBAction)sendCommand:(id)sender {
    NSString* cmd = [commandField stringValue];
    if ( [cmd rangeOfString:@"stop"].location != NSNotFound )
        [bigSwitch setOn:NO];
    [theServer sendCommand:cmd];
    [commandField setStringValue:@""];
}

-(void)consoleOutput:(NSString*)output {
    [consoleView setString:[[consoleView string] stringByAppendingString:output]];
    [consoleView scrollRangeToVisible:NSMakeRange([[consoleView textStorage] length], 0)];
}

- (IBAction)sendChat:(id)sender {
    NSString* chat = [NSString stringWithFormat:@"%@\n", [chatField stringValue]];
    NSString* cmd = [@"say " stringByAppendingString:chat];
    [theServer sendCommand:cmd];
    [self chatOutput:chat byUser:@"Admin"];
    [chatField setStringValue:@""];
}

-(void)chatOutput:(NSString*)message byUser:(NSString*)user {
    NSString* output = [NSString stringWithFormat:@"[%@] %@", user, message];
    [chatView setString:[[chatView string] stringByAppendingString:output]];
    [chatView scrollRangeToVisible:NSMakeRange([[chatView textStorage] length], 0)];
}

@end
