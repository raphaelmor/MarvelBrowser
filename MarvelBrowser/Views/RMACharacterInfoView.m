//
// RMACharacterInfoView.m
// MarvelBrowser
//
// Created by Raphael MOR on 22/05/2014.
// Copyright (c) 2014 Raphael MOR. All rights reserved.
//
@import CoreMotion;

#import <ReactiveCocoa/ReactiveCocoa.h>
#import <pop/POP.h>

#import "RMACharacterInfoView.h"
#import "RMACharacterInfoViewModel.h"

#import "RMAAutoPanningImageView.h"

@interface RMACharacterInfoView () <UIScrollViewDelegate>

@property (nonatomic) RMAAutoPanningImageView *avatarView;
@property (nonatomic) UILabel *characterName;
@property (nonatomic) UILabel *characterBio;


@end

@implementation RMACharacterInfoView

#pragma mark - Lifecycle methods

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];

    if (self) {
        [self commonInit];
    }
    return self;
}

#pragma mark - Public methods

- (void)setViewModel:(RMACharacterInfoViewModel *)viewModel
{
    _viewModel = viewModel;

    RAC(self.characterName, text) = RACObserve(viewModel, name);
    RAC(self.characterBio, text)  = RACObserve(viewModel, biography);
    RAC(self.avatarView, image)   = RACObserve(viewModel, avatar);
}

#pragma mark - Private methods

- (void)commonInit
{
    [self setupCharacterAvatar];
    [self setupCharacterName];
    [self setupCharacterBio];
    [self setupConstraints];
}

- (void)setupCharacterAvatar
{
    self.avatarView = [[RMAAutoPanningImageView alloc] initWithFrame:self.frame];
    [self addSubview:self.avatarView];
}

- (void)setupCharacterName
{
    self.characterName           = [[UILabel alloc] init];

    self.characterName.font      = [UIFont fontWithName:@"MarkerFelt-Wide" size:40.f];
    self.characterName.textColor = [UIColor whiteColor];
    self.characterName.layer.shadowColor   = [[UIColor blackColor] CGColor];
    self.characterName.layer.shadowOffset  = CGSizeMake(-3.0, 3.0);
    self.characterName.layer.shadowOpacity = 1.0f;
    self.characterName.translatesAutoresizingMaskIntoConstraints = NO;

    [self addSubview:self.characterName];
}

- (void)setupCharacterBio
{
    self.characterBio                     = [[UILabel alloc] init];

    self.characterBio.font                = [UIFont fontWithName:@"Avenir-Medium" size:14.f];
    self.characterBio.textAlignment       = NSTextAlignmentLeft;
    self.characterBio.numberOfLines       = 0;
    self.characterBio.textColor           = [UIColor whiteColor];
    self.characterBio.layer.shadowColor   = [[UIColor blackColor] CGColor];
    self.characterBio.layer.shadowOffset  = CGSizeMake(-1.0, 1.0);
    self.characterBio.layer.shadowOpacity = 1.0f;
    self.characterBio.translatesAutoresizingMaskIntoConstraints = NO;

    [self addSubview:self.characterBio];
}

- (void)setupConstraints
{
    NSDictionary *viewsDictionary = @{
        @"name": self.characterName,
        @"bio": self.characterBio,
        @"avatar": self.avatarView
    };

    NSArray *constraints =
        [NSLayoutConstraint constraintsWithVisualFormat:@"|-[name]-|"
                                                options:0
                                                metrics:nil
                                                  views:viewsDictionary];
    [self addConstraints:constraints];

    constraints =
        [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[name(==50)]"
                                                options:0
                                                metrics:nil
                                                  views:viewsDictionary];
    [self addConstraints:constraints];

    constraints =
        [NSLayoutConstraint constraintsWithVisualFormat:@"|-[bio]-|"
                                                options:0
                                                metrics:nil
                                                  views:viewsDictionary];
    [self addConstraints:constraints];

    constraints =
        [NSLayoutConstraint constraintsWithVisualFormat:@"V:[bio]-|"
                                                options:0
                                                metrics:nil
                                                  views:viewsDictionary];
    [self addConstraints:constraints];

    constraints =
        [NSLayoutConstraint constraintsWithVisualFormat:@"|[avatar]|"
                                                options:0
                                                metrics:nil
                                                  views:viewsDictionary];
    [self addConstraints:constraints];
    constraints =
        [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[avatar]|"
                                                options:0
                                                metrics:nil
                                                  views:viewsDictionary];
    [self addConstraints:constraints];
}

@end