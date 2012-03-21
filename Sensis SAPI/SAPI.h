//
//  SAPI.h
//  Sensis SAPI
//
//  Created by Mark Aufflick on 21/03/12.
//  Copyright (c) 2012 Pumptheory Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    SAPIEnvironmentTest,
    SAPIEnvironmentProd
} SAPIEnvironment;

@interface SAPI : NSObject

+ (void)setKey:(NSString *)key;
+ (NSString *)key;

+ (void)setEnvironment:(SAPIEnvironment)environment;
+ (SAPIEnvironment)environement;
+ (NSString *)environmentString;
+ (NSString *)scheme;
+ (NSString *)host;
+ (NSString *)pathPrefix;


@end
