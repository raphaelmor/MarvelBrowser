//
// RMACharacterInfoController.m
// MarvelBrowser
//
// Created by Raphael MOR on 22/05/2014.
// Copyright (c) 2014 Raphael MOR. All rights reserved.
//
#import <ReactiveCocoa/RACEXTScope.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

#import "RMACharacterInfoController.h"

#import "RCMarvelAPI+RAC.h"
#import "RMACharacterInfoViewModel.h"
#import "SDWebImageDownloader+RAC.h"

@interface RMACharacterInfoController ()

@property (nonatomic) RACSubject *characterIDDidChange;
@property (nonatomic) RACSignal  *didFetchCharacter;

@end

@implementation RMACharacterInfoController

#pragma mark - Lifecycle methods

- (instancetype)init
{
    self = [super init];

    if (self) {
        [self setupSignals];
    }
    return self;
}

#pragma mark - Public methods

- (void)fetchCharacterInfo:(NSNumber *)characterID
{
    [self.characterIDDidChange sendNext:characterID];
}

#pragma mark - Private methods

- (void)setupSignals
{
    @weakify(self);
    self.characterIDDidChange = [RACSubject subject];

    self.didFetchCharacter    = [self.characterIDDidChange flattenMap:^RACStream *(NSNumber *newCharacterID) {
        return [[RCMarvelAPI api] fetchCharacterInfoForID:newCharacterID];
    }];

    [[self.didFetchCharacter deliverOn:RACScheduler.mainThreadScheduler] subscribeNext:^(RCCharacterObject *character) {
        @strongify(self);
        self.characterViewModel.biography = character.bio;
        self.characterViewModel.name = [character.name uppercaseString];

        [[[[SDWebImageDownloader sharedDownloader] fetchImageAtURL:character.thumbnail.fullSizeURL] deliverOn:RACScheduler.mainThreadScheduler] subscribeNext:^(UIImage *avatar) {
            self.characterViewModel.avatar = avatar;
        } error:^(NSError *error) {
            [self.characterViewModel setDefaultAvatar];
        }];
    }];
}

@end