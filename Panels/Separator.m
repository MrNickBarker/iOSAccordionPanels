//
//  Separator.m
//  Panels
//
//  Created by Nikola Lajic on 4/17/15.
//  Copyright (c) 2015 Nikola Lajic. All rights reserved.
//

#import "Separator.h"

@implementation Separator

- (instancetype)init
{
    self = [super init];
    if (!self) return nil;
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPan:)];
    [self addGestureRecognizer:pan];
    
    return self;
}

- (void)onPan:(UIPanGestureRecognizer *)pan
{
    CGPoint translation = [pan translationInView:self];
    
    self.constraint.constant += translation.x;
    
    // reset the translation so we get the correct values each update
    [pan setTranslation:CGPointZero inView:self];
}

@end
