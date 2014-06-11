//
// RMAAppDelegateTests.m
// MarvelBrowser
//
// Created by Raphael MOR on 22/05/2014.
// Copyright (c) 2014 Raphael MOR. All rights reserved.
//

#import <OCMock/OCMock.h>
#import <XCTest/XCTest.h>

#import <Marvelous/Marvelous.h>

#import "RMAAppDelegate.h"

@interface RMAAppDelegateTests : XCTestCase

@end

@implementation RMAAppDelegateTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testDidFinishLoadingShouldSetupAPIKey
{
    id marvelAPI = [OCMockObject niceMockForClass:[RCMarvelAPI class]];
    [[[marvelAPI stub] andReturn:marvelAPI] api];

    [[marvelAPI expect] setPublicKey:OCMOCK_ANY];
    [[marvelAPI expect] setPrivateKey:OCMOCK_ANY];

    RMAAppDelegate *appDelegate = [[RMAAppDelegate alloc] init];
    [appDelegate application:nil didFinishLaunchingWithOptions:nil];

    [marvelAPI verify];
    [marvelAPI stopMocking];
}

@end