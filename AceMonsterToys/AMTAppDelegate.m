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

#import <QuartzCore/QuartzCore.h>

#import "AMTAppDelegate.h"

#import "MBProgressHUD.h"

#import "AMTSession.h"
#import "AMTLocation.h"
#import "AMTAPIClient.h"

#import "AMTOverlayLayer.h"
#import "AMTMainMenuViewController.h"

@interface AMTAppDelegate ()
- (void)setupAppearances;
- (void)userDidLogin;
- (void)userDidLogout;
- (void)authenticationDidFail:(NSNotification *)notification;
@end

@implementation AMTAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    AMTSession *session = [AMTSession sharedSession];
    [session loadSessionData];
    
    [self setupAppearances];
    
    // Override point for customization after application launch.
    if (IS_IPAD) {
        UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
        UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
        splitViewController.delegate = (id)navigationController.topViewController;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLogout) name:kNotificationUserDidLogOut object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLogin) name:kNotificationUserDidLogIn object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(authenticationDidFail:) name:kNotificationAPIClientAuthenticationFailure object:nil];
    
//    if (!session.isActive) {
//        // Cancel all app local notifications
//        [application cancelAllLocalNotifications];
//        
//        // Trigger in next Run loop
//        double delayInSeconds = 0.1;
//        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
//        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//            [self showLoginAnimated:NO];
//        });
//    }
    
    [[AMTLocation sharedLocation] startUpdatingIfEnabled];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    [[AMTLocation sharedLocation] stopUpdating];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[AMTLocation sharedLocation] startUpdatingIfEnabled];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)showErrorAlertWithMessage:(NSString *)messageOrNil
{
    NSString *message = messageOrNil;
    if (message == nil) {
        message = NSLocalizedString(@"We ran into a problem, please try again.", nil);
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"There's a Problem", nil)
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)showSpinnerWithMessage:(NSString *)messageOrNil
{
    NSString *message = messageOrNil;
    if (messageOrNil == nil) {
        message = NSLocalizedString(@"Loading...", nil);
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.window animated:YES];
    hud.labelFont = [UIFont fontWithName:UI_TITLE_FONT_NAME size:hud.labelFont.pointSize];
    hud.labelText = message;
}

- (void)hideSpinner
{
    [MBProgressHUD hideAllHUDsForView:self.window animated:YES];
}

#pragma mark - Privates

- (void)setupAppearances
{
    
    [[UINavigationBar appearance] setTintColor:COLOR_PALETTE_HEADER];
    [[UINavigationBar appearance] setTitleTextAttributes:
     @{ UITextAttributeFont: [UIFont fontWithName:UI_TITLE_FONT_NAME size:21.0] }];
    
//    UIImage *navigationBarImage = [UIImage imageNamed:@"gun_metal"];
//    [[UINavigationBar appearance] setBackgroundImage:navigationBarImage forBarMetrics:UIBarMetricsDefault];
    
    if (!IS_IPAD) {
        AMTOverlayLayer *overlay = [[AMTOverlayLayer alloc] init];
        [self.window.layer addSublayer:overlay];
    }
}

- (void)userDidLogin
{
    
}

- (void)userDidLogout
{
    [self showLoginAnimated:YES];
}

- (void)authenticationDidFail:(NSNotification *)notification
{
    [[AMTSession sharedSession] logout];
}

- (void)showLoginAnimated:(BOOL)animated
{
    if (IS_IPAD) {
        UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
        UINavigationController *navigationController = (UINavigationController *) [splitViewController.viewControllers objectAtIndex:0];
        [navigationController popToRootViewControllerAnimated:NO];
        UIViewController *controller = [splitViewController.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        
        [splitViewController presentModalViewController:controller animated:animated];
    } else {
        UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
        [navigationController popToRootViewControllerAnimated:NO];
        //[[navigationController.viewControllers objectAtIndex:0] performSegueWithIdentifier:@"NonMemberSegue" sender:self];
        UIViewController *controller = [navigationController.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [navigationController presentModalViewController:controller animated:animated];
    }
}

@end
