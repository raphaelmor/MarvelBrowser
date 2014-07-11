//
// RMACharacterInfoViewModel.m
// MarvelBrowser
//
// Created by Raphael MOR on 22/05/2014.
// Copyright (c) 2014 Raphael MOR. All rights reserved.
//
#import <ReactiveCocoa/ReactiveCocoa.h>

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

#pragma mark - Public Methods

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

    self.nameDidChangeSignal      = RACObserve(self, name);
    self.biographyDidChangeSignal = RACObserve(self, biography);
    self.avatarDidChangeSignal    = RACObserve(self, avatar);
}

@end