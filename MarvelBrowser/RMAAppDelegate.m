//
// RMAAppDelegate.m
// MarvelBrowser
//
// Created by Raphael MOR on 22/05/2014.
// Copyright (c) 2014 Raphael MOR. All rights reserved.
//

#import <Marvelous/Marvelous.h>

#import "RMAAppDelegate.h"

@implementation RMAAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    NSString *apiKeysPath = [[NSBundle mainBundle] pathForResource:@"APIKeys" ofType:@"plist"];
    NSMutableDictionary *plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:apiKeysPath];

    [RCMarvelAPI api].publicKey  = [plistDict objectForKey:@"marvel-public-key"];
    [RCMarvelAPI api].privateKey = [plistDict objectForKey:@"marvel-private-key"];

    return YES;
}

@end