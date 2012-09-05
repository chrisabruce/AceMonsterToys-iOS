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

#import "AMTClient.h"

NSString * const kNotificationAMTClientAuthenticationFailure = @"kNotificationAMTClientAuthenticationFailure";

@implementation AMTClient

- (id)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    //[self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *clientVersion = [NSString stringWithFormat:@"%@.%@", [infoDict objectForKey:@"CFBundleShortVersionString"], [infoDict objectForKey:@"CFBundleVersion"]];
	[self setDefaultHeader:@"X-AMT-Client-Version" value:clientVersion];
    
    KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:kKeyChainIdentifierSession accessGroup:nil];
    NSString *clientID = [keychain objectForKey:(__bridge id)kSecAttrAccount];
    if (clientID == nil || clientID.length < 1) {
        CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
        clientID = (__bridge NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuid);
        CFRelease(uuid);
        [keychain setObject:clientID forKey:(__bridge id)kSecAttrAccount];
    }
    
	[self setDefaultHeader:@"X-AMT-Client-ID" value:clientID];
    
    return self;
}

#pragma mark - Helpers for single completion block

- (void)getPath:(NSString *)path parameters:(NSDictionary *)parameters completionBlock:(AMTClientCompletion)completionBlock
{
    [self getPath:path
       parameters:parameters
          success:[self successBlockWithCompletionBlock:completionBlock]
          failure:[self failureBlockWithCompletionBlock:completionBlock]
     ];
}

- (void)postPath:(NSString *)path parameters:(NSDictionary *)parameters completionBlock:(AMTClientCompletion)completionBlock
{
    [self postPath:path
        parameters:parameters
           success:[self successBlockWithCompletionBlock:completionBlock]
           failure:[self failureBlockWithCompletionBlock:completionBlock]
     ];
}

- (void)putPath:(NSString *)path parameters:(NSDictionary *)parameters completionBlock:(AMTClientCompletion)completionBlock
{
    [self putPath:path
       parameters:parameters
          success:[self successBlockWithCompletionBlock:completionBlock]
          failure:[self failureBlockWithCompletionBlock:completionBlock]
     ];
}

#pragma mark - AFNetworking Block generators
- (AFSuccessHandler)successBlockWithCompletionBlock:(AMTClientCompletion)completionBlock {
    return ^(AFHTTPRequestOperation *operation, id responseObject) {
        [self logResponse:operation response:responseObject error:nil];
        
        if (completionBlock) {
            completionBlock(operation, responseObject, nil);
        }
    };
}

- (AFFailureHandler)failureBlockWithCompletionBlock:(AMTClientCompletion)completionBlock {
    return ^(AFHTTPRequestOperation *operation, NSError *error) {
        [self logResponse:operation response:nil error:error];
        
        if (completionBlock) {
            completionBlock(operation, nil, error);
        }
        if ([operation.response statusCode] == 401) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationAMTClientAuthenticationFailure object:operation.response];
        }
    };
}

#pragma mark - Privates

- (void)logResponse:(AFHTTPRequestOperation *)operation response:(id)responseObject error:(NSError *)error
{
    NSString *url = [[operation.response URL] description];
    NSInteger statusCode = [operation.response statusCode];
    NSString *response = @"";
#ifdef API_LOG_RESPONSES
    response = responseObject;
#endif
    NSLog(@"\n******************************************************************\n\nURL: %@\nStatus Code: %i\nResponse:\n%@\nError:\n%@\n\n******************************************************************", url, statusCode, response, error);
    
}

@end
