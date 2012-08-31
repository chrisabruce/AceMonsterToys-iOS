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

#import <Foundation/Foundation.h>

@interface AMTSession : NSObject

@property (copy, readonly) NSString *username;
@property (copy, readonly) NSString *password;
@property (copy, readonly) NSString *authToken;

// Indicates if session has email and password,
// does not mean they are valid.
@property (nonatomic, readonly) BOOL isActive;

// Returns the shared instance.
+ (AMTSession *)sharedSession;

// Starts a new Session with email and authentication token
// Call this after user has successfully created a new account using
// his facebook credentials.
- (void)startSessionWithUsername:(NSString *)username
                  andPassword:(NSString *)password
                 andAuthToken:(NSString *)authToken;

// Loads any saved SessionData, call this from AppDelegate
// didFinishLoading.
- (void)loadSessionData;

// Logs a user in with email and password.
- (void)loginWith:(NSString *)username
      andPassword:(NSString *)password 
completionHandler:(void (^)(void))completionHandler 
   failureHandler:(void (^)(NSError *error))failureHandler;

// Logs a User out and ends their session.
// Email and Password will be reset to nil.
// Sends Notification kNotificationUserDidLogOut when logged out.
- (void)logout;

@end
