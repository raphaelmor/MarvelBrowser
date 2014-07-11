//
// RCMarvelAPI+RAC.m
// MarvelBrowser
//
// Created by Raphael MOR on 11/07/2014.
// Copyright (c) 2014 Raphael MOR. All rights reserved.
//
#import <ReactiveCocoa/RACEXTScope.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

#import "RCMarvelAPI+RAC.h"

@implementation RCMarvelAPI (RAC)

- (RACSignal *)fetchCharacterInfoForID:(NSNumber *)characterID
{
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id < RACSubscriber > subscriber) {
        @strongify(self);
        [self characterByIdentifier:characterID
                   andCallbackBlock:^(RCCharacterObject *character,
                                      RCQueryInfoObject *info,
                                      NSError *error) {
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

@end