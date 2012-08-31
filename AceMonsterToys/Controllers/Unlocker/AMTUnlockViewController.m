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

#import "AMTUnlockViewController.h"

#import "AMTAPIClient.h"

@interface AMTUnlockViewController ()
- (void)validate;
@end

@implementation AMTUnlockViewController
@synthesize pinTextField;
@synthesize unlockButton;

- (void)awakeFromNib {
    self.isAuthRequired = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                           selector:@selector(validate)
                               name:UITextFieldTextDidChangeNotification
                             object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.pinTextField becomeFirstResponder];
    [self validate];
}

- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self setPinTextField:nil];
    [self setUnlockButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (IBAction)unlock:(id)sender {
    [self.pinTextField resignFirstResponder];
    
    [self.applicationDelegate showSpinnerWithMessage:NSLocalizedString(@"Sending PIN...", nil)];
    __block AMTUnlockViewController *blockSelf = self;
    
    [[AMTAPIClient sharedClient] unlockDoorWithPIN:self.pinTextField.text completionBlock:^(AFHTTPRequestOperation *operation, id responsObject, NSError *error) {
        [self.applicationDelegate hideSpinner];
        
        if (!error) {
            [blockSelf.navigationController popViewControllerAnimated:YES];
        } else {
            [blockSelf.applicationDelegate showErrorAlertWithMessage:nil];
            [blockSelf.pinTextField becomeFirstResponder];
        }
    }];
}

- (void)validate
{
    self.unlockButton.enabled = (self.pinTextField.text.length > 0 && [[AMTSession sharedSession] isActive]);
}
@end
