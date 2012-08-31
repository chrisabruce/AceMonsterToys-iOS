/*************************************************************************
 
 Created by Chris Bruce on 8/31/12
 Copyright (c) 2021 Chris Bruce & Ace Monster Toys, Inc.
 
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

#import "AMTMainMenuViewController.h"

#import "NSDate+Formatting.h"

#import "AMTAppDelegate.h"
#import "AMTSession.h"
#import "AMTLocation.h"


@interface AMTMainMenuViewController ()
- (void)showMenuButton;
- (void)hideMenuButton;
@end

@implementation AMTMainMenuViewController

@synthesize popoverController;
@synthesize popoverButton;
@synthesize logInOutButton;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImageView *headerImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Logo-Nav"]];
    self.navigationItem.titleView = headerImage;
    
    self.contentSizeForViewInPopover = CGSizeMake(310.0, self.tableView.rowHeight * 7);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.rightBarButtonItem.enabled = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchData) name:kNotificationUserLocationDidUpdate object:nil];
    AMTSession *session = [AMTSession sharedSession];
    if (session.isActive) {
        self.navigationItem.rightBarButtonItem.title = NSLocalizedString(@"Logout", nil);
    } else {
        self.navigationItem.rightBarButtonItem.title = NSLocalizedString(@"Login", nil);
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self showMenuButton];
}

- (void)viewDidUnload
{
    [self setLogInOutButton:nil];
    [super viewDidUnload];
    self.popoverButton = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (IS_IPAD)
        return UIInterfaceOrientationIsLandscape(interfaceOrientation);
    else
        return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [self.popoverController dismissPopoverAnimated:YES];
}

#pragma mark - actions

- (IBAction)logInOut:(id)sender
{
    [self.popoverController dismissPopoverAnimated:YES];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    AMTSession *session = [AMTSession sharedSession];
    if (session.isActive) {
        [session logout];
    } else {
        AMTAppDelegate *appDelegate = (AMTAppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate showLoginAnimated:YES];
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

#pragma mark - SplitViewController Delegate
- (void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc {
    
    // Keep references to the popover controller and the popover button, and tell the detail view controller to show the button.
    barButtonItem.title = NSLocalizedString(@"Menu", nil);
    self.popoverController = pc;
    self.popoverButton = barButtonItem;
    [self showMenuButton];
    
}

- (void)splitViewController:(UISplitViewController*)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
    [self hideMenuButton];

}

#pragma mark - Delegate Calls

- (void)showMenuButton
{
    UINavigationController *navigationController = [self.navigationController.splitViewController.viewControllers objectAtIndex:1];
    UIViewController <MainMenuViewControllerDelegate> *detailViewController = [navigationController.viewControllers lastObject];
    if ([detailViewController respondsToSelector:@selector(showMenuPopoverButton:)])
        [detailViewController showMenuPopoverButton:self.popoverButton];
}

- (void)hideMenuButton
{
    UINavigationController *navigationController = [self.navigationController.splitViewController.viewControllers objectAtIndex:1];
    UIViewController <MainMenuViewControllerDelegate> *detailViewController = [navigationController.viewControllers lastObject];
    if ([detailViewController respondsToSelector:@selector(hideMenuPopoverButton:)])
        [detailViewController hideMenuPopoverButton:self.popoverButton];
    //self.popoverController = nil;
    //self.popoverButton = nil;
}
@end
