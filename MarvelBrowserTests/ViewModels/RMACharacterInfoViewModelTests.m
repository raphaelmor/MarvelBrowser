//
// RMACharacterInfoViewModelTests.m
// MarvelBrowser
//
// Created by Raphael MOR on 10/06/2014.
// Copyright (c) 2014 Raphael MOR. All rights reserved.
//

#import <OCMock/OCMock.h>
#import <XCTest/XCTest.h>

#import "RMACharacterInfoViewModel.h"

@interface RMACharacterInfoViewModelTests : XCTestCase

@end

@implementation RMACharacterInfoViewModelTests

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

- (void)testEmptyViewModelShouldHaveDefaultName
{
    RMACharacterInfoViewModel *viewModel = [RMACharacterInfoViewModel new];

    XCTAssertEqualObjects(@"", viewModel.name, @"Default name should be an empty string");
}

- (void)testEmptyViewModelShouldHaveDefaultBiography
{
    RMACharacterInfoViewModel *viewModel = [RMACharacterInfoViewModel new];

    XCTAssertEqualObjects(@"", viewModel.biography, @"Default biography should be an empty string");
}

- (void)testEmptyViewModelShouldHaveDefaultAvatar
{
    UIImage *defaultImage = [UIImage new];
    id mockUIImage = [OCMockObject mockForClass:[UIImage class]];
    [[[mockUIImage stub] andReturn:defaultImage] imageNamed:@"defaultAvatar"];

    RMACharacterInfoViewModel *viewModel = [RMACharacterInfoViewModel new];

    XCTAssertEqualObjects(defaultImage, viewModel.avatar, @"Default biography should be an empty string");
}

@end