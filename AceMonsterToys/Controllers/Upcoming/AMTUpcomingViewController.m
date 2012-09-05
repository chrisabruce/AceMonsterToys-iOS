/*************************************************************************
 
 Created by Chris Bruce on 9/4/2012
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

#import "AMTUpcomingViewController.h"

#import "AMTGoogleAPIClient.h"
#import "AMTEventCell.h"

@interface AMTUpcomingViewController ()
- (void)fetchData;
@end

@implementation AMTUpcomingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self fetchData];
    [self.tableView reloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)fetchData
{
    __block AMTUpcomingViewController *blockSelf = self;
    [self.applicationDelegate showSpinnerWithMessage:NSLocalizedString(@"Loading...", nil)];
    
    [self.googleClient getEventsWithCompletionBlock:^(AFHTTPRequestOperation *operation, id responseObject, NSError *error) {
        [blockSelf.applicationDelegate hideSpinner];
        if (error == nil) {
            NSError *parseError;
            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&parseError];
            if (parseError == nil) {
                blockSelf.events = [result objectForKeyNotNull:@"items"];
                [blockSelf.tableView reloadData];
                NSLog(@"Results: %@", blockSelf.events);
            } else {
                [blockSelf.applicationDelegate showErrorAlertWithMessage:nil];
            }
        } else {
            [blockSelf.applicationDelegate showErrorAlertWithMessage:nil];
        }
    }];
}

#pragma mark - UITableView delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.events.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AMTEventCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AMTEventCell"];
    NSDictionary *eventDetailsDict = [self.events objectAtIndex:indexPath.row];
    cell.eventDetailsDict = eventDetailsDict;
    
    return cell;
}


- (AMTGoogleAPIClient *)googleClient
{
    return [AMTGoogleAPIClient sharedClient];
}

@end
