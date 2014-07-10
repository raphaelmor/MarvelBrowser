//
// RMACharacterInfoViewModel.m
// MarvelBrowser
//
// Created by Raphael MOR on 22/05/2014.
// Copyright (c) 2014 Raphael MOR. All rights reserved.
//

#import "RMACharacterInfoViewModel.h"

@implementation RMACharacterInfoViewModel

#pragma mark - Lifecycle methods

- (instancetype)init
{
    self = [super init];

    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)setDefaultAvatar
{
    self.avatar = [UIImage imageNamed:@"defaultAvatar"];
}

#pragma mark - Private Methods

- (void)commonInit
{
    self.name      = @"";
    self.biography = @"";
    [self setDefaultAvatar];
}

@end