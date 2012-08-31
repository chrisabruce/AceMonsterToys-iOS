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

#import "AFHTTPClient.h"

#import "AFHTTPRequestOperation.h"
#import "AFJSONRequestOperation.h"

extern NSString * const kNotificationAPIClientAuthenticationFailure;

typedef void (^AMTAPIClientCompletion)(AFHTTPRequestOperation *operation, id responseObject, NSError *error);

@interface AMTAPIClient : AFHTTPClient

+ (AMTAPIClient *)sharedClient;

- (void)loginWithUsername:(NSString *)username andPassword:(NSString *)password completionBlock:(AMTAPIClientCompletion)completionBlock;

- (void)unlockDoorWithPIN:(NSString *)PIN completionBlock:(AMTAPIClientCompletion)completionBlock;

#pragma mark - Single Block helpers
- (void)getPath:(NSString *)path parameters:(NSDictionary *)parameters completionBlock:(AMTAPIClientCompletion)completionBlock;
- (void)postPath:(NSString *)path parameters:(NSDictionary *)parameters completionBlock:(AMTAPIClientCompletion)completionBlock;

@end
