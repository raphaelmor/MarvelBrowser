//
// RMACharacterInfoViewModel.h
// MarvelBrowser
//
// Created by Raphael MOR on 22/05/2014.
// Copyright (c) 2014 Raphael MOR. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RACSignal;

@interface RMACharacterInfoViewModel : NSObject

@property (nonatomic) NSString *name;
@property (nonatomic) NSString *biography;
@property (nonatomic) UIImage  *avatar;

@property (nonatomic) RACSignal *nameDidChangeSignal;
@property (nonatomic) RACSignal *biographyDidChangeSignal;
@property (nonatomic) RACSignal *avatarDidChangeSignal;

- (void)setDefaultAvatar;


@end