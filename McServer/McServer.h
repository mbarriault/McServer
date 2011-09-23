//
//  McServer.h
//  McServer
//
//  Created by Michael Barriault on 11-09-12.
//  Copyright 2011 University of Guelph. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface McServer : NSObject {
    NSTask* serverTask;
    NSPipe* inPipe;
    NSPipe* outPipe;
    NSFileHandle* readHandle;
    NSFileHandle* writeHandle;
    NSArray* command;
    id Controller;
}
-(void)startServer;
-(void)stopServer;
-(void)sendCommand:(NSString*)cmd;
@property (retain) id Controller;

@end
