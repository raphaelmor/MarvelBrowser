//
// RMACharacterInfoView.h
// MarvelBrowser
//
// Created by Raphael MOR on 22/05/2014.
// Copyright (c) 2014 Raphael MOR. All rights reserved.
//

@import UIKit;

@class RMACharacterInfoViewModel;

/**
 *  A View that displays Character Infos (name, biography, and avatar).
 */
@interface RMACharacterInfoView : UIView

/**
 * View-model for the view.
 *
 * The view will register using RACObserve to the fields of the view-model, and will be updated
 * automatically when the view-model changes.
 *
 */
@property (nonatomic) IBOutlet RMACharacterInfoViewModel *viewModel;


@end