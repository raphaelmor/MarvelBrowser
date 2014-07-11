//
// RMAViewController.m
// MarvelBrowser
//
// Created by Raphael MOR on 22/05/2014.
// Copyright (c) 2014 Raphael MOR. All rights reserved.
//

#import <Marvelous/Marvelous.h>

#import "RMACharacterInfoController.h"
#import "RMACharacterInfoView.h"
#import "RMACharacterInfoViewModel.h"
#import "RMAViewController.h"

#define IRON_MAN @1009368
#define WOLVERINE @1009718
#define SPIDER_MAN @1009610

@interface RMAViewController ()

@property (nonatomic) IBOutlet RMACharacterInfoView *characterInfoView;
@property (nonatomic) IBOutlet RMACharacterInfoController *characterInfoController;

@end

@implementation RMAViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.characterInfoController fetchCharacterInfo:IRON_MAN];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.characterInfoController fetchCharacterInfo:WOLVERINE];
    });
}

@end