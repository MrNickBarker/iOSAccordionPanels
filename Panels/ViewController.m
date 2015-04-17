//
//  ViewController.m
//  Panels
//
//  Created by Nikola Lajic on 4/17/15.
//  Copyright (c) 2015 Nikola Lajic. All rights reserved.
//

#import "ViewController.h"
#import "Separator.h"

const CGFloat kMinimumPanelWidth = 50.0f;
const CGFloat kSeparatorWidth = 20.f;

@interface ViewController ()

@property (nonatomic, weak) IBOutlet UIView *panelsContainer;
@property (nonatomic, strong) NSMutableArray *panelsArray;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.panelsArray = [NSMutableArray array];
    [self addPanel];
    [self addPanel];
}

- (IBAction)tappedAddPanel:(id)sender
{
    [self addPanel];
}

- (IBAction)tappedRemovePanel:(id)sender
{
    [self removePanel];
}

- (void)addPanel
{
    
    if (self.panelsArray.count > 0)
    {
        Separator *separator = [[Separator alloc] init];
        separator.translatesAutoresizingMaskIntoConstraints = false;
        separator.backgroundColor = [UIColor blackColor];
        [self.panelsArray addObject:separator];
        [self.panelsContainer addSubview:separator];
        
        // width
        [separator addConstraint:[NSLayoutConstraint constraintWithItem:separator
                                                              attribute:NSLayoutAttributeWidth
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:nil
                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                             multiplier:1.0
                                                               constant:kSeparatorWidth]];
    }
    
    UIView *panel = [[UIView alloc] init];
    panel.translatesAutoresizingMaskIntoConstraints = false;
    panel.backgroundColor = [self randomColor];
    [self.panelsArray addObject:panel];
    [self.panelsContainer addSubview:panel];
    
    // minimum width
    [panel addConstraint:[NSLayoutConstraint constraintWithItem:panel
                                                      attribute:NSLayoutAttributeWidth
                                                      relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                         toItem:nil
                                                      attribute:NSLayoutAttributeNotAnAttribute
                                                     multiplier:1.0
                                                       constant:kMinimumPanelWidth]];
    
    [self updatePanelConstraints];
}

- (void)removePanel
{
    UIView *last = [self.panelsArray lastObject];
    [last removeFromSuperview];
    [self.panelsArray removeObject:last];

    // check if the next object is a seperator
    last = [self.panelsArray lastObject];
    if ([last isKindOfClass:[Separator class]])
    {
        [last removeFromSuperview];
        [self.panelsArray removeObject:last];
    }
    
    [self updatePanelConstraints];
}

- (void)updatePanelConstraints
{
    UIView *prevPanel = nil;
    Separator *prevSeparator = nil;
    for (int i = 0; i < self.panelsArray.count; i++)
    {
        // quick way to remove old constraints
        UIView *panel = self.panelsArray[i];
        [panel removeFromSuperview];
        [self.panelsContainer addSubview:panel];
        
        // vertical constraint
        [self.panelsContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[panel]-0-|"
                                                                                     options:0
                                                                                     metrics:nil
                                                                                       views:NSDictionaryOfVariableBindings(panel)]];
        
        // only one panel
        if (self.panelsArray.count == 1)
        {
            [self.panelsContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[panel]-0-|"
                                                                                         options:0
                                                                                         metrics:nil
                                                                                           views:NSDictionaryOfVariableBindings(panel)]];
            return;
        }
        
        // first panel
        if (!prevPanel)
        {
            [self.panelsContainer addConstraint:[NSLayoutConstraint constraintWithItem:panel
                                                                             attribute:NSLayoutAttributeLeading
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:self.panelsContainer
                                                                             attribute:NSLayoutAttributeLeading
                                                                            multiplier:1.0
                                                                              constant:0]];
        }
        else
        {
            [self.panelsContainer addConstraint:[NSLayoutConstraint constraintWithItem:panel
                                                                             attribute:NSLayoutAttributeLeading
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:prevPanel
                                                                             attribute:NSLayoutAttributeTrailing
                                                                            multiplier:1.0
                                                                              constant:0]];
        }
        
        // last panel
        if (i == self.panelsArray.count -1)
        {
            [self.panelsContainer addConstraint:[NSLayoutConstraint constraintWithItem:panel
                                                                             attribute:NSLayoutAttributeTrailing
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:self.panelsContainer
                                                                             attribute:NSLayoutAttributeTrailing
                                                                            multiplier:1.0
                                                                              constant:0]];
        }
        
        // constrain separators to each other
        if ([panel isKindOfClass:[Separator class]])
        {
            Separator *separator = (Separator *)panel;
            CGFloat panelWidth = 100; // replace this number with whatever you want or calcuate a precentage of the screen
            
            if (prevSeparator)
            {
                separator.constraint = [NSLayoutConstraint constraintWithItem:separator
                                                                    attribute:NSLayoutAttributeLeading
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:prevSeparator
                                                                    attribute:NSLayoutAttributeTrailing
                                                                   multiplier:1.0
                                                                     constant:panelWidth];
            }
            else
            {
                separator.constraint = [NSLayoutConstraint constraintWithItem:separator
                                                                    attribute:NSLayoutAttributeLeading
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.panelsContainer
                                                                    attribute:NSLayoutAttributeLeading
                                                                   multiplier:1.0
                                                                     constant:panelWidth];
            }
            // make sure it doesn't break if minimum width is pushing back
            separator.constraint.priority = 999;
            [self.panelsContainer addConstraint:separator.constraint];
            prevSeparator = separator;
        }
        
        prevPanel = panel;
    }
}

- (UIColor *)randomColor
{
    CGFloat r = arc4random_uniform(255) / 255.0;
    CGFloat g = arc4random_uniform(255) / 255.0;
    CGFloat b = arc4random_uniform(255) / 255.0;
    return [UIColor colorWithRed:r green:g blue:b alpha:1.0];
}

@end
