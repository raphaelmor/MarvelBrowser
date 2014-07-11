//
// RMACharacterInfoController.h
// MarvelBrowser
//
// Created by Raphael MOR on 22/05/2014.
// Copyright (c) 2014 Raphael MOR. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RCCharacterObject;
@class RMACharacterInfoViewModel;
@class RMACharacterInfoView;

/**
 * Controller in charge of getting the data, creating and updating the view-model for Character Info.
 */
@interface RMACharacterInfoController : NSObject

/**
 * The view-model that this controller will update.
 *
 */
@property (nonatomic) IBOutlet RMACharacterInfoViewModel *characterViewModel;


/**
 *  Fetches character information.
 *
 * @param characterID       The ID of the character to fetch.
 */
- (void)fetchCharacterInfo:(NSNumber *)characterID;

@end