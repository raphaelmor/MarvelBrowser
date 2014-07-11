//
// RCMarvelAPI+RAC.h
// MarvelBrowser
//
// Created by Raphael MOR on 11/07/2014.
// Copyright (c) 2014 Raphael MOR. All rights reserved.
//

#import "RCMarvelAPI.h"

@class RACSignal;

@interface RCMarvelAPI (RAC)

/**
 *  Fetches a character from its id.
 *
 *  @param characterID The id of the character do download.
 *
 *  @return a signal that sends the RCCharacterObject when it is downloaded.
 */
- (RACSignal *)fetchCharacterInfoForID:(NSNumber *)characterID;

@end