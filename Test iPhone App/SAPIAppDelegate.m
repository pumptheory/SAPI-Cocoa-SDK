//
//  SAPIAppDelegate.m
//  Sensis SAPI
//
//  Created by Mark Aufflick on 21/03/12.
//  Copyright (c) 2012 Pumptheory Pty Ltd. All rights reserved.
//

#import "SAPIAppDelegate.h"

#import "SAPIMasterViewController.h"
#import "SAPI.h"
#import "SAPITestAccountKey.h"

@implementation SAPIAppDelegate

@synthesize window=_window;
@synthesize navigationController=_navigationController;

- (void)dealloc
{
    [_window release];
    [_navigationController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [SAPI setKey:SAPI_TEST_KEY];
    [SAPI setEnvironment:SAPI_TEST_ENVIRONMENT];

    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.

    SAPIMasterViewController *masterViewController = [[[SAPIMasterViewController alloc] initWithNibName:@"SAPIMasterViewController" bundle:nil] autorelease];
    self.navigationController = [[[UINavigationController alloc] initWithRootViewController:masterViewController] autorelease];
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
