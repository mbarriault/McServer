//
//  McUser.h
//  McServer
//
//  Created by Michael Barriault on 11-09-24.
//  Copyright 2011 University of Guelph. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "McServer.h"

static McServer* theServer = nil;

@interface McUser : NSObject {
    NSString* username;
    BOOL banned;
    BOOL op;
    NSUInteger gamemode;
}
+(McServer*)defaultServer;
+(void)setDefaultServer:(McServer*)server;

-(id)initFromUser:(NSString*)user;

-(NSString*)description;

@property (readwrite) BOOL banned;
@property (readwrite) BOOL op;
@property (readwrite) NSUInteger gamemode;

@end
