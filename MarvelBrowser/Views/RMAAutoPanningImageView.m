//
// RMAAutoPanningImageView.m
// MarvelBrowser
//
// Created by Raphael MOR on 23/05/2014.
// Copyright (c) 2014 Raphael MOR. All rights reserved.
//
@import CoreMotion;

#import <pop/POP.h>

#import "RMAAutoPanningImageView.h"

@interface RMAAutoPanningImageView () <UIScrollViewDelegate>

@property (nonatomic) UIImageView *imageView;
@property (nonatomic, strong) CMMotionManager *motionManager;

@end

@implementation RMAAutoPanningImageView

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

- (void)dealloc
{
    [self.motionManager stopDeviceMotionUpdates];
}

#pragma mark - Public methods

- (void)setImage:(UIImage *)image
{
    if (self.image == nil) {
        [self fadeInToImage:image];
    } else {
        [self fadeOutThenFadeInToImage:image];
    }
}

#pragma mark - Private methods

- (void)commonInit
{
    [self setupViews];

    self.motionManager = [[CMMotionManager alloc] init];
    [self.motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue]
                                            withHandler:^(CMDeviceMotion *motion, NSError *error) {
         [self calculateRotationBasedOnDeviceMotionRotationRate:motion];
     }];
}

- (void)setupViews
{
    self.bounces       = NO;
    self.bouncesZoom   = NO;
    self.scrollEnabled = NO;
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.delegate      = self;

    self.imageView     = [[UIImageView alloc] initWithFrame:self.frame];
    self.imageView.contentMode     = UIViewContentModeScaleAspectFill;
    self.imageView.backgroundColor = [UIColor lightGrayColor];

    [self addSubview:self.imageView];
}

- (void)fadeInToImage:(UIImage *)image
{
    self.alpha = 0.0;
    [self changeImage:image];

    POPBasicAnimation *fadeInAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    fadeInAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    fadeInAnimation.fromValue      = @(0.0);
    fadeInAnimation.toValue = @(1.0);
    [self pop_addAnimation:fadeInAnimation forKey:@"fadeIn"];
}

- (void)fadeOutThenFadeInToImage:(UIImage *)image
{
    POPBasicAnimation *fadeOutAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    fadeOutAnimation.timingFunction  = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    fadeOutAnimation.fromValue       = @(1.0);
    fadeOutAnimation.toValue = @(0.0);
    fadeOutAnimation.completionBlock = ^(POPAnimation *animation, BOOL completed) {
        [self fadeInToImage:image];
    };
    [self pop_addAnimation:fadeOutAnimation forKey:@"fadeOut"];
}

- (void)changeImage:(UIImage *)image
{
    [self resetZoomLevels];

    self.imageView.image = image;
    [self.imageView sizeToFit];
    self.imageView.frame = CGRectMake(0,
                                      0,
                                      self.imageView.bounds.size.width,
                                      self.imageView.bounds.size.height);

    [self updateScrollViewZoomToMaximumForImage:image];
}

- (void)updateScrollViewZoomToMaximumForImage:(UIImage *)image
{
    self.contentSize      = image.size;
    self.contentOffset    = CGPointMake((self.contentSize.width / 2.f) - (CGRectGetWidth(self.bounds)) / 2.f,
                                        (self.contentSize.height / 2.f) - (CGRectGetHeight(self.bounds)) / 2.f);

    CGFloat zoomScale = [self maximumZoomScaleForImage:image];

    self.maximumZoomScale = zoomScale;
    self.minimumZoomScale = zoomScale;
    self.zoomScale = zoomScale;
}

- (CGFloat)maximumZoomScaleForImage:(UIImage *)image
{
    return MAX(CGRectGetHeight(self.bounds), CGRectGetWidth(self.bounds)) / MIN(image.size.width, image.size.height);
}

- (void)calculateRotationBasedOnDeviceMotionRotationRate:(CMDeviceMotion *)motion
{
    CGFloat xRotationRate = motion.rotationRate.x;
    CGFloat yRotationRate = motion.rotationRate.y;
    CGFloat zRotationRate = motion.rotationRate.z;

    if (fabs(yRotationRate) > (fabs(xRotationRate) + fabs(zRotationRate))) {
        CGFloat invertedYRotationRate     = yRotationRate * -1;

        CGFloat zoomScale = [self maximumZoomScaleForImage:self.imageView.image];
        CGFloat interpretedXOffset        = self.contentOffset.x + (invertedYRotationRate * zoomScale * 5.f);

        CGPoint contentOffset = [self clampedContentOffsetForHorizontalOffset:interpretedXOffset];

        static CGFloat kMovementSmoothing = 0.3f;


        [UIView animateWithDuration:kMovementSmoothing
                              delay:0.0f
                            options:UIViewAnimationOptionBeginFromCurrentState |
         UIViewAnimationOptionAllowUserInteraction |
         UIViewAnimationOptionCurveEaseOut
                         animations:^{
             [self setContentOffset:contentOffset animated:NO];
         } completion:NULL];
    }
}

- (CGPoint)clampedContentOffsetForHorizontalOffset:(CGFloat)horizontalOffset;
{
    CGFloat maximumXOffset = self.contentSize.width - CGRectGetWidth(self.bounds);
    CGFloat minimumXOffset = 0.f;

    CGFloat clampedXOffset = fmaxf(minimumXOffset, fmin(horizontalOffset, maximumXOffset));
    CGFloat centeredY      = (self.contentSize.height / 2.f) - (CGRectGetHeight(self.bounds)) / 2.f;

    return CGPointMake(clampedXOffset, centeredY);
}

- (void)resetZoomLevels
{
    self.maximumZoomScale = 1.0f;
    self.minimumZoomScale = 1.0f;
    self.zoomScale = 1.0f;
}

#pragma mark - UIScrollViewDelegate methods

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

@end