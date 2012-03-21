//
//  SAPI.m
//  Sensis SAPI
//
//  Created by Mark Aufflick on 21/03/12.
//  Copyright (c) 2012 Pumptheory Pty Ltd. All rights reserved.
//

#import "SAPI.h"

@implementation SAPI

static NSString * _key = nil;
static SAPIEnvironment _environment = SAPIEnvironmentTest;

+ (void)setKey:(NSString *)key
{
    @synchronized(self)
    {
        if (![key isEqualToString:_key])
        {
            [_key release];
            _key = [key copy];
        }
    }
}

+ (NSString *)key
{
    @synchronized(self)
    {
        return [[_key retain] autorelease];
    }
}

+ (void)setEnvironment:(SAPIEnvironment)environment
{
    @synchronized(self)
    {
        _environment = environment;
    }
}

+ (SAPIEnvironment)environement
{
    @synchronized(self)
    {
        return _environment;
    }
}


@end
