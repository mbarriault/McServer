//
//  McUser.m
//  McServer
//
//  Created by Michael Barriault on 11-09-24.
//  Copyright 2011 University of Guelph. All rights reserved.
//

#import "McUser.h"

@implementation McUser

@synthesize banned, op, gamemode;

+(McServer*)defaultServer {
    return theServer;
}

+(void)setDefaultServer:(McServer*)server {
    if ( theServer == server )
        return;
    if ( theServer != nil )
        [theServer release];
    theServer = server;
}

-(id)init {
    return [self initFromUser:@""];
}

- (id)initFromUser:(NSString*)user {
    self = [super init];
    if (self) {
        username = [user retain];
        banned = NO;
        op = NO;
        gamemode = 0;
    }
    return self;
}

-(NSString*)description {
    return username;
}

@end
