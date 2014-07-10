//
// RMACharacterInfoController.m
// MarvelBrowser
//
// Created by Raphael MOR on 22/05/2014.
// Copyright (c) 2014 Raphael MOR. All rights reserved.
//

#import <Marvelous/Marvelous.h>
#import <ReactiveCocoa/RACEXTScope.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <SDWebImage/SDWebImageDownloader.h>

#import "RMACharacterInfoController.h"

#import "RMACharacterInfoViewModel.h"

@interface RMACharacterInfoController ()

@property (nonatomic) NSNumber *characterID;

@property (nonatomic) RACSignal *characterIDDidChange;
@property (nonatomic) RACSignal *didFetchCharacter;

@end

@implementation RMACharacterInfoController

- (instancetype)init
{
    self = [super init];

    if (self) {
        self.characterID = @0;
        [self setupSignals];
    }
    return self;
}

#pragma mark - Public methods

- (void)fetchCharacterInfo:(NSNumber *)characterID
{
    self.characterID = characterID;
}

#pragma mark - Private methods

- (void)setupSignals
{
    @weakify(self);
    self.characterIDDidChange = [RACObserve(self, characterID) skip:1];

    self.didFetchCharacter    = [self.characterIDDidChange flattenMap:^RACStream *(NSNumber *newCharacterID) {
        @strongify(self);
        return [self fetchCharacterInfoForID:newCharacterID];
    }];

    [[self.didFetchCharacter deliverOn:RACScheduler.mainThreadScheduler] subscribeNext:^(RCCharacterObject *character) {
        @strongify(self);
        self.characterViewModel.biography = character.bio;
        self.characterViewModel.name = [character.name uppercaseString];

        [[[self fetchAvatarForURL:character.thumbnail.fullSizeURL] deliverOn:RACScheduler.mainThreadScheduler] subscribeNext:^(UIImage *avatar) {
            self.characterViewModel.avatar = avatar;
        } error:^(NSError *error) {
            [self.characterViewModel setDefaultAvatar];
        }];
    }];
}

- (RACSignal *)fetchCharacterInfoForID:(NSNumber *)characterID
{
    return [RACSignal createSignal:^RACDisposable *(id < RACSubscriber > subscriber) {
        [[RCMarvelAPI api] characterByIdentifier:characterID
                                andCallbackBlock:^(id character, RCQueryInfoObject *info, NSError *error) {
            if (!character) {
                [subscriber sendError:error];
            } else {
                [subscriber sendNext:character];
            }
            [subscriber sendCompleted];
        }];
        return nil;
    }];
}

- (RACSignal *)fetchAvatarForURL:(NSURL *)avatarURL
{
    return [RACSignal createSignal:^RACDisposable *(id < RACSubscriber > subscriber) {
        NSOperation *operation = [SDWebImageDownloader.sharedDownloader downloadImageWithURL:avatarURL
                                                                                     options:0
                                                                                    progress:nil
                                                                                   completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
            if (image && finished) {
                [subscriber sendNext:image];
            } else {
                [subscriber sendError:error];
            }
            [subscriber sendCompleted];
        }];
        return [RACDisposable disposableWithBlock:^{
            [operation cancel];
        }];;
    }];
}

@end