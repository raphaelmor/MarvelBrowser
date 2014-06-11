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

@interface RMAViewController ()

@property (nonatomic) IBOutlet RMACharacterInfoView *characterInfoView;
@property (nonatomic) IBOutlet RMACharacterInfoController *characterInfoController;

@end

@implementation RMAViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSNumber *identifier = @1009368;
    
    [self.characterInfoController fetchCharacterInfo:identifier];
}

@end