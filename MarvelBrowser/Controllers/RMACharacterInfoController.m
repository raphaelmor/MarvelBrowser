//
// RMACharacterInfoController.m
// MarvelBrowser
//
// Created by Raphael MOR on 22/05/2014.
// Copyright (c) 2014 Raphael MOR. All rights reserved.
//

#import <Marvelous/Marvelous.h>
#import <SDWebImage/SDWebImageDownloader.h>

#import "RMACharacterInfoController.h"

#import "RMACharacterInfoViewModel.h"

@interface RMACharacterInfoController ()

@property (nonatomic) NSNumber *characterID;
@property (nonatomic) RCCharacterObject *character;

@end

@implementation RMACharacterInfoController

#pragma mark - Public methods

- (void)fetchCharacterInfo:(NSNumber *)characterID
{
    [[RCMarvelAPI api] characterByIdentifier:characterID
                            andCallbackBlock:^(id result, RCQueryInfoObject *info, NSError *error) {
        if (result) {
            self.character = (RCCharacterObject *)result;

            dispatch_async(dispatch_get_main_queue(), ^{
                self.characterViewModel.name = [self.character.name uppercaseString];
                self.characterViewModel.biography = self.character.bio;
            });

            NSURL *imageURL = self.character.thumbnail.fullSizeURL;

            [SDWebImageDownloader.sharedDownloader downloadImageWithURL:imageURL
                                                                options:0
                                                               progress:nil
                                                              completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished)
            {
                if (image && finished) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.characterViewModel.avatar = image;
                    });
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.characterViewModel setDefaultAvatar];
                    });
                }
            }];
        }
    }];
}

@end