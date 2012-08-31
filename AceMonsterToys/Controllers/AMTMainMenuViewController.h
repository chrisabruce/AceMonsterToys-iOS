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

#import <UIKit/UIKit.h>

@interface AMTMainMenuViewController : UITableViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) UIPopoverController *popoverController;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *popoverButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *logInOutButton;

- (IBAction)logInOut:(id)sender;

@end

@protocol MainMenuViewControllerDelegate <NSObject>

@optional
- (void)showMenuPopoverButton:(UIBarButtonItem *)barButton;
- (void)hideMenuPopoverButton:(UIBarButtonItem *)barButton;

@end
