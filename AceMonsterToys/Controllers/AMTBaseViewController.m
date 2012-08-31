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

#import "AMTBaseViewController.h"


@interface AMTBaseViewController ()

@end

@implementation AMTBaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.view.backgroundColor = COLOR_PALETTE_BG;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.isAuthRequired && ![[AMTSession sharedSession] isActive]) {
        [self.applicationDelegate showLoginAnimated:animated];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (IS_IPAD)
        return UIInterfaceOrientationIsLandscape(interfaceOrientation);
    else
        return YES;
}

#pragma mark - MainMenuViewControllerDelegate

- (void)showMenuPopoverButton:(UIBarButtonItem *)barButton 
{
    self.navigationItem.leftBarButtonItem = barButton;
}

- (void)hideMenuPopoverButton:(UIBarButtonItem *)barButton 
{
    NSMutableArray *leftButtons = [self.navigationItem.leftBarButtonItems mutableCopy];
    [leftButtons removeObject:barButton];
    [self.navigationItem setLeftBarButtonItems:leftButtons animated:NO];
}

- (AMTAppDelegate *)applicationDelegate
{
    return [[UIApplication sharedApplication] delegate];
}


@end
