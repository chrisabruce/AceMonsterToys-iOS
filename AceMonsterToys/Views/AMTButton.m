/*************************************************************************
 
 Created by Chris Bruce on 8/31/12
 Copyright (c) 2012 Chris Bruce & Ace Monster Toys, Inc.
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 
 *************************************************************************/

#import "AMTButton.h"

#import <QuartzCore/QuartzCore.h>

#import "AMTDisplayHelper.h"

@implementation AMTButton

@synthesize buttonColor = _buttonColor;

+ (Class)layerClass {
    return [CAGradientLayer class];
}

- (void)awakeFromNib {
    
    self.buttonColor = COLOR_AFFIRMATION;
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    CAGradientLayer *gradientLayer = (CAGradientLayer *)self.layer;
    
    if (highlighted) {
        gradientLayer.colors = [NSArray arrayWithObjects:
                                (id)[AMTDisplayHelper darkenColor:_buttonColor].CGColor,
                                (id)[AMTDisplayHelper darkenColor:_buttonColor].CGColor,
                                nil];
    } else {
        gradientLayer.colors = [NSArray arrayWithObjects:
                                (id)_buttonColor.CGColor,
                                (id)[AMTDisplayHelper darkenColor:_buttonColor].CGColor,
                                nil];
    }
}

- (void)setButtonColor:(UIColor *)buttonColor
{
    _buttonColor = buttonColor;
    
    // Add Shine
    CAGradientLayer *gradientLayer = (CAGradientLayer *)self.layer;
    
    gradientLayer.cornerRadius = 5.0;
    gradientLayer.masksToBounds = YES;
    
    gradientLayer.colors = [NSArray arrayWithObjects:
                            (id)_buttonColor.CGColor,
                            (id)[AMTDisplayHelper darkenColor:_buttonColor].CGColor,
                            nil];
    
    self.titleLabel.font = [UIFont fontWithName:@"Museo Slab" size:self.titleLabel.font.pointSize];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //[self setTintColor:[UIColor colorWithRed:29.0/255.0 green:144.0/255.0 blue:0 alpha:1]];
}

@end
