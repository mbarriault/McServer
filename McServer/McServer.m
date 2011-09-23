//
//  McServer.m
//  McServer
//
//  Created by Michael Barriault on 11-09-12.
//  Copyright 2011 University of Guelph. All rights reserved.
//

#import "McServer.h"

@implementation McServer

@synthesize Controller;

- (id)init {
    if ((self = [super init])) {
        command = [[NSArray alloc] initWithObjects:@"-Xmx1024M", @"-Xms1024M", @"-jar", [[NSBundle mainBundle] pathForResource:@"minecraft_server" ofType:@"jar"], @"nogui", nil];
        
    }
    
    return self;
}

-(void)dealloc {
    if ( [serverTask isRunning] ) [self stopServer];
    [command release];
}

-(void)startServer {
    inPipe = [[NSPipe alloc] init];
    dup2([[inPipe fileHandleForReading] fileDescriptor], fileno(stdin));
    //        dup2(fileno(stdin), [[inPipe fileHandleForReading] fileDescriptor]);
    writeHandle = [inPipe fileHandleForWriting];
    
    outPipe = [[NSPipe alloc] init];
    dup2([[outPipe fileHandleForWriting] fileDescriptor], fileno(stdout));
    //        dup2(fileno(stdout), [[outPipe fileHandleForWriting] fileDescriptor]);
    readHandle = [outPipe fileHandleForReading];
    
    NSNotificationCenter* dnc = [NSNotificationCenter defaultCenter];
    [dnc addObserver:self selector:@selector(handleNotification:) name:NSFileHandleReadCompletionNotification object:readHandle];
    [readHandle readInBackgroundAndNotify];
    
    serverTask = [[NSTask alloc] init];
    [serverTask setLaunchPath:@"/usr/bin/java"];
    [serverTask setArguments:command];
    [serverTask setStandardInput:inPipe];
    [serverTask setStandardOutput:outPipe];
    [serverTask setStandardError:outPipe];
    [serverTask launch];
}

-(void)stopServer {
    [self sendCommand:@"stop"];
    [serverTask terminate];
    [serverTask release];
    [inPipe release];
    [outPipe release];
    [readHandle release];
    [writeHandle release];
}

-(void)sendCommand:(NSString*)cmd {
    [writeHandle writeData:[[cmd stringByAppendingString:@"\n"] dataUsingEncoding:NSASCIIStringEncoding]];
}

-(void)handleNotification:(NSNotification*)notification {
    NSString *str = [[NSString alloc] initWithData: [[notification userInfo] objectForKey: NSFileHandleNotificationDataItem] encoding: NSASCIIStringEncoding] ;
    [Controller consoleOutput:str];
    [str release];
    [readHandle readInBackgroundAndNotify];
}


@end
