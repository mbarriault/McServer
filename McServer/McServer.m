//
//  McServer.m
//  McServer
//
//  Created by Michael Barriault on 11-09-12.
//  Copyright 2011 University of Guelph. All rights reserved.
//

#import "McServer.h"
#import "McUser.h"

@implementation McServer

@synthesize Controller;

- (id)init {
    if ((self = [super init])) {
        command = [[NSArray alloc] initWithObjects:@"-Xmx1024M", @"-Xms1024M", @"-jar", [[NSBundle mainBundle] pathForResource:@"minecraft_server" ofType:@"jar"], @"nogui", nil];
        ready = NO;
        [McUser setDefaultServer:self];
        users = [[NSMutableArray alloc] initWithCapacity:20];
    }
    
    return self;
}

-(void)dealloc {
    if ( [serverTask isRunning] ) [self stopServer];
    [command release];
    [users release];
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
    [Controller startSpinner];
    ready = NO;
    [self sendCommand:@"stop"];
    [serverTask waitUntilExit];
    [Controller stopSpinner];
    [serverTask terminate];
    [serverTask release];
    [inPipe release];
    [outPipe release];
//    [readHandle release];
//    [writeHandle release];
}

-(void)sendCommand:(NSString*)cmd {
    [writeHandle writeData:[[cmd stringByAppendingString:@"\n"] dataUsingEncoding:NSASCIIStringEncoding]];
}

-(void)handleNotification:(NSNotification*)notification {
    NSString *str = [[NSString alloc] initWithData: [[notification userInfo] objectForKey: NSFileHandleNotificationDataItem] encoding: NSASCIIStringEncoding];
    [self processOutput:str];
    [Controller consoleOutput:str];
    [str release];
    [readHandle readInBackgroundAndNotify];
}

-(void)processOutput:(NSString*)str {
    if ( [str rangeOfString:@"[INFO] Starting minecraft server"].location != NSNotFound ) {
        ready = NO;
        [Controller startSpinner];
    }
    else if ( [str rangeOfString:@"[INFO] Done"].location != NSNotFound ) {
        ready = YES;
        [Controller stopSpinner];
    }
    else if ( [str rangeOfString:@"[INFO] <"].location != NSNotFound ) {
        NSRange start = [str rangeOfString:@"[INFO] <"];
        start.location += start.length;
        NSRange stop = [str rangeOfString:@">"];
        start.length = stop.location - start.location;
        stop.location += 2;
        [Controller chatOutput:[str substringFromIndex:stop.location] byUser:[str substringWithRange:start]];
    }
    else if ( [str rangeOfString:@"logged in with entity id"].location != NSNotFound ) {
        NSRange start = [str rangeOfString:@"[INFO] "];
        NSRange stop = [str rangeOfString:@" [/"];
        start.location += start.length;
        start.length = stop.location - start.location;
        McUser* newUser = [[McUser alloc] initFromUser:[str substringWithRange:start]];
        [users addObject:newUser];
        [newUser release];
        NSLog(@"%@", users);
    }
}


@end
