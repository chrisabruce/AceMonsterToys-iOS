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

#import "AMTLoginViewController.h"

#import "AMTAPIClient.h"

@interface AMTLoginViewController ()
- (BOOL)isValid;
- (void)validate:(NSNotification *)notification;
@end

@implementation AMTLoginViewController
@synthesize usernameTextField;
@synthesize passwordTextField;
@synthesize loginButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.loginButton.enabled = [self isValid];
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    [notificationCenter addObserver:self
                           selector:@selector(validate:)
                               name:UITextFieldTextDidChangeNotification
                             object:nil];
    
//    [notificationCenter addObserver:self
//                           selector:@selector(keyboardWasShown:)
//                               name:UIKeyboardWillShowNotification
//                             object:nil];
//    
//    [notificationCenter addObserver:self
//                           selector:@selector(keyboardWillHide:)
//                               name:UIKeyboardWillHideNotification
//                             object:nil];
}

- (void)viewDidUnload
{
    [self setUsernameTextField:nil];
    [self setPasswordTextField:nil];
    [self setLoginButton:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewDidUnload];
}

- (IBAction)login
{
    [self.usernameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    
    [self.applicationDelegate showSpinnerWithMessage:NSLocalizedString(@"Logging in...", nil)];
    
    AMTAPIClient *api = [AMTAPIClient sharedClient];

    [api loginWithUsername:usernameTextField.text andPassword:passwordTextField.text completionBlock:^(AFHTTPRequestOperation *operation, id responseObject, NSError *error) {
        
        [self.applicationDelegate hideSpinner];
        NSString *authToken;
        
        if (!error) {
            NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:operation.request.URL];
            for (NSHTTPCookie *cookie in cookies) {
                NSLog(@"Cookie: %@", cookie);
                if ([cookie.name isEqualToString:@"DRUPAL_UID"]) {
                    authToken = cookie.value;
                }
            }
        }
        if (authToken) {
            [[AMTSession sharedSession] startSessionWithUsername:self.usernameTextField.text andPassword:self.passwordTextField.text andAuthToken:authToken];
            
            [self dismissModalViewControllerAnimated:YES];
        } else {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:NSLocalizedString(@"Login Failed", nil)
                                  message:NSLocalizedString(@"Your email/password was incorrect, please try again", nil)
                                  delegate:self
                                  cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                  otherButtonTitles:nil];
            [alert show];
            [self.usernameTextField becomeFirstResponder];
        }
    }];
}

- (IBAction)cancel:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - UITextField Delegates
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (self.usernameTextField == textField) {
        [passwordTextField becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
        if (self.passwordTextField.text.length > 0) {
            [self login];
        }
    }
    return YES;
}

#pragma mark - keyboard notification handlers

- (void)keyboardWasShown:(NSNotification *)notification {
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height - 20.0, 0.0);
    self.tableView.contentInset = contentInsets;
    self.tableView.scrollIndicatorInsets = contentInsets;
    [self.tableView setContentOffset:CGPointMake(0, keyboardSize.height - 20.0) animated:YES];
    
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [UIView beginAnimations:@"Scroll" context:nil];
    [UIView setAnimationDuration:0.1];
    //[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    self.tableView.contentInset = UIEdgeInsetsZero;
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsZero;
    [UIView commitAnimations];
}

- (BOOL)isValid {
    return (self.usernameTextField.text.length > 0 && self.passwordTextField.text.length > 0);
}

- (void)validate:(NSNotification *)notification {
    self.loginButton.enabled = [self isValid];
}

@end
