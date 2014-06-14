//
// RMACharacterInfoView.m
// MarvelBrowser
//
// Created by Raphael MOR on 22/05/2014.
// Copyright (c) 2014 Raphael MOR. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>
#import <pop/POP.h>

#import "RMACharacterInfoView.h"
#import "RMACharacterInfoViewModel.h"

#import "RMAAutoPanningImageView.h"

@interface RMACharacterInfoView () <UIScrollViewDelegate>

@property (nonatomic) RMAAutoPanningImageView *avatarView;
@property (nonatomic) UILabel *characterName;
@property (nonatomic) UILabel *characterBio;
@property (nonatomic) CGFloat yTranslation;

@property (nonatomic) CGFloat minYAllowed;
@property (nonatomic) CGFloat maxYAllowed;


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
    [self setYTranslation:1.f];
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self addGestureRecognizer:panGestureRecognizer];
    
    _minYAllowed = -self.frame.size.height / 3.f;
    //yTranslation = 1.0
    _maxYAllowed = self.frame.size.height / 2.0f;
    self.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.layer.shadowOpacity = .4f;
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

- (IBAction)handlePan:(UIPanGestureRecognizer *)recognizer {
    
    CGPoint translation = [recognizer translationInView:self];
    
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
        {
            [self pop_removeAnimationForKey:@"decelerate"];
        }
            
        case UIGestureRecognizerStateChanged:
        {
            CGFloat adjustedYTranslation = translation.y / 473.33333f;
            [self setYTranslation:self.yTranslation + adjustedYTranslation];
            
            [recognizer setTranslation:CGPointMake(0, 0) inView:self];
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            POPAnimatableProperty *yTranslationProperty = [POPAnimatableProperty propertyWithName:@"yTranslation" initializer:^(POPMutableAnimatableProperty *prop) {
                prop.readBlock = ^(id obj, CGFloat values[]) {
                    values[0] = [obj yTranslation];
                };
                prop.writeBlock = ^(id obj, const CGFloat values[]) {
                    [obj setYTranslation:values[0]];
                };
                prop.threshold = 0.01;
            }];

            
            CGPoint velocity = [recognizer velocityInView:self];
            velocity.x = 0;
            velocity.y = -velocity.y/473.33333f;
            

            
            POPSpringAnimation *springAnimation = [POPSpringAnimation animation];
            springAnimation.property = yTranslationProperty;
            springAnimation.velocity = @(velocity.y);
            springAnimation.springBounciness =10;

            
            if (velocity.y > 0) {
                springAnimation.toValue = @(0.0f);
            }else {
                springAnimation.toValue = @(1.0f);
            }
            
            [self pop_addAnimation:springAnimation forKey:@"decelerate"];

            
        }
            break;
            
        default:
            break;
    }
}



- (void)setYTranslation:(CGFloat)yTranslation {
    NSLog(@"y translation : %.2f", yTranslation);
    _yTranslation = yTranslation;
    
    CGFloat projectedY = _minYAllowed + yTranslation * (_maxYAllowed - _minYAllowed);
    
    
    CGFloat invertedRatio = 1.f - yTranslation;
    
    self.center = CGPointMake(self.center.x,projectedY);
    
    self.layer.shadowOffset = CGSizeMake(0.f, 10.f * invertedRatio);

    
    _characterBio.alpha = yTranslation;
    
    CGFloat minNameYAllowed = 530;
    CGFloat maxNameYAllowed = 50;
    if (yTranslation > 1.0f) {
        yTranslation = 1.0f;
    }
    if (yTranslation < 0.0f) {
        yTranslation = 0.0f;
    }
    invertedRatio = 1.f - yTranslation;
    
    CGFloat projectedNameY = minNameYAllowed + yTranslation * (maxNameYAllowed - minNameYAllowed);
    
    _characterName.center = CGPointMake(_characterName.center.x,
                                            projectedNameY);
    _characterName.alpha =  (sin((invertedRatio*2*M_PI)+M_PI_2) +1.f)/2.f;
    
}

@end