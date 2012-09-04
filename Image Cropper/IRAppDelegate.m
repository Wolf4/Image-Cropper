//
//  IRAppDelegate.m
//  Image Cropper
//
//  Created by Igor Rubanau on 9/3/12.
//  Copyright (c) 2012 Igor Rubanau. All rights reserved.
//

#import "IRAppDelegate.h"
#import "IRRootViewController.h"


@implementation IRAppDelegate
@synthesize window = window_;
@synthesize viewController = viewController_;

- (void)dealloc {
    [window_ release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions
                   :(NSDictionary *)launchOptions {
    self.window = [[[UIWindow alloc] initWithFrame:
                    [[UIScreen mainScreen] bounds]]
                   autorelease];
    self.viewController = [[[IRRootViewController alloc]
                            initWithNibName:nil
                            bundle:nil]
                           autorelease];
    self.viewController.view.backgroundColor = [UIColor grayColor];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

@end
