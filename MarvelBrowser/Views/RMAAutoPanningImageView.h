//
// RMAAutoPanningImageView.h
// MarvelBrowser
//
// Created by Raphael MOR on 23/05/2014.
// Copyright (c) 2014 Raphael MOR. All rights reserved.
//

@import UIKit;

/**
 * A view that displays an image and scrolls automatically to show more while tilting device.
 *
 * This class is heavily based on http://subjc.com/facebook-paper-photo-panner/ implementation.
 */
@interface RMAAutoPanningImageView : UIScrollView

/**
 *  The image to display.
 */
@property (nonatomic) UIImage *image;

@end