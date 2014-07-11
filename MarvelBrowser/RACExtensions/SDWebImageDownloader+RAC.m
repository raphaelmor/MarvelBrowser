//
// SDWebImageDownloader+RAC.m
// MarvelBrowser
//
// Created by Raphael MOR on 11/07/2014.
// Copyright (c) 2014 Raphael MOR. All rights reserved.
//
#import <ReactiveCocoa/RACEXTScope.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

#import "SDWebImageDownloader+RAC.h"

@implementation SDWebImageDownloader (RAC)

- (RACSignal *)fetchImageAtURL:(NSURL *)imageURL
{
    return [RACSignal createSignal:^RACDisposable *(id < RACSubscriber > subscriber) {
        NSOperation *operation = [self downloadImageWithURL:imageURL
                                                    options:0
                                                   progress:nil
                                                  completed:^(UIImage *image,
                                                              NSData *data,
                                                              NSError *error,
                                                              BOOL finished) {
            if (image && finished) {
                [subscriber sendNext:image];
            } else {
                [subscriber sendError:error];
            }
            [subscriber sendCompleted];
        }];
        return [RACDisposable disposableWithBlock:^{
            [operation cancel];
        }];;
    }];
}

@end