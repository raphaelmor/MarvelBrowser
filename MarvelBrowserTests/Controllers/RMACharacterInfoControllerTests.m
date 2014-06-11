//
// RMACharacterInfoControllerTest.m
// MarvelBrowser
//
// Created by Raphael MOR on 22/05/2014.
// Copyright (c) 2014 Raphael MOR. All rights reserved.
//

#import <Marvelous/Marvelous.h>
#import <OCMock/OCMock.h>
#import <XCTest/XCTest.h>

#import "RMACharacterInfoController.h"
#import "RMACharacterInfoViewModel.h"

@interface RMACharacterInfoControllerTests : XCTestCase

@end

@implementation RMACharacterInfoControllerTests

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

- (void)testFetchCharacterInfoShouldFetchProperID
{
    NSNumber *characterID = @(1234);

    id mockMarvelAPI      = [OCMockObject mockForClass:[RCMarvelAPI class]];
    [[[mockMarvelAPI stub] andReturn:mockMarvelAPI] api];
    [[mockMarvelAPI expect] characterByIdentifier:characterID andCallbackBlock:OCMOCK_ANY];

    RMACharacterInfoController *controller = [[RMACharacterInfoController alloc]
                                              init];
    [controller fetchCharacterInfo:characterID];


    [mockMarvelAPI verify];
}

@end