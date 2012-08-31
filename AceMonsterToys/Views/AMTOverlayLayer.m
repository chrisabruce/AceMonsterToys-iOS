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

#import "AMTOverlayLayer.h"

@interface AMTOverlayLayer ()
- (void)orientationChanged:(NSNotification *)notifcation;
- (void)resize;
@end

@implementation AMTOverlayLayer

- (id)init
{
    self = [super init];
    if (self) {
        self.zPosition = 1;
        self.needsDisplayOnBoundsChange = YES;
        
        [self resize];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:)
                                                     name:UIDeviceOrientationDidChangeNotification object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)orientationChanged:(NSNotification *)notification
{
    [self performSelector:@selector(resize) withObject:self afterDelay:0];
}

- (void)resize {
    
    self.frame = self.frame = CGRectInset([[UIScreen mainScreen] applicationFrame], 0, 0);
    UIImage *overlayImg = [[UIImage imageNamed:@"overlay.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
    self.contents = (id)overlayImg.CGImage;
}
@end
