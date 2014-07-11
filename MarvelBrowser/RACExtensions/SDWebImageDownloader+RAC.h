//
// SDWebImageDownloader+RAC.h
// MarvelBrowser
//
// Created by Raphael MOR on 11/07/2014.
// Copyright (c) 2014 Raphael MOR. All rights reserved.
//

#import "SDWebImageDownloader.h"

@class RACSignal;

@interface SDWebImageDownloader (RAC)

/**
 *  Fetches an image from its URL.
 *
 *  @param imageURL The URL of the image do download.
 *
 *  @return a signal that sends the UIImage when it is downloaded.
 */
- (RACSignal *)fetchImageAtURL:(NSURL *)imageURL;

@end