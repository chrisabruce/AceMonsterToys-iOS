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

#import "AFHTTPClient.h"

#import "KeychainItemWrapper.h"
#import "AFJSONRequestOperation.h"

extern NSString * const kNotificationAMTClientAuthenticationFailure;

typedef void (^AMTClientCompletion)(AFHTTPRequestOperation *operation, id responseObject, NSError *error);
typedef void (^AFFailureHandler)(AFHTTPRequestOperation *operation, NSError *error);
typedef void (^AFSuccessHandler)(AFHTTPRequestOperation *operation, id responseObject);

@interface AMTClient : AFHTTPClient


- (AFSuccessHandler)successBlockWithCompletionBlock:(AMTClientCompletion)completionBlock;
- (AFFailureHandler)failureBlockWithCompletionBlock:(AMTClientCompletion)completionBlock;
- (void)logResponse:(AFHTTPRequestOperation *)operation response:(id)responseObject error:(NSError *)error;

#pragma mark - Single Block helpers
- (void)getPath:(NSString *)path parameters:(NSDictionary *)parameters completionBlock:(AMTClientCompletion)completionBlock;
- (void)postPath:(NSString *)path parameters:(NSDictionary *)parameters completionBlock:(AMTClientCompletion)completionBlock;
- (void)putPath:(NSString *)path parameters:(NSDictionary *)parameters completionBlock:(AMTClientCompletion)completionBlock;
@end
