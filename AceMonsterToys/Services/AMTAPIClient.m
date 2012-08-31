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

#import "AMTAPIClient.h"

#import "KeychainItemWrapper.h"
#import "AFJSONRequestOperation.h"

NSString * const kNotificationAPIClientAuthenticationFailure = @"kNotificationAPIClientAuthenticationFailure";

typedef void (^AFFailureHandler)(AFHTTPRequestOperation *operation, NSError *error);
typedef void (^AFSuccessHandler)(AFHTTPRequestOperation *operation, id responseObject);

@interface AMTAPIClient ()
- (AFSuccessHandler)successBlockWithCompletionBlock:(AMTAPIClientCompletion)completionBlock;
- (AFFailureHandler)failureBlockWithCompletionBlock:(AMTAPIClientCompletion)completionBlock;
- (void)logResponse:(AFHTTPRequestOperation *)operation response:(id)responseObject error:(NSError *)error;
@end

@implementation AMTAPIClient

+ (AMTAPIClient *)sharedClient
{
    static AMTAPIClient *_sharedAPIClient = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        NSLog(@"Initializing OMAPIClient to use: %@", AMT_URL_BASE);
        _sharedAPIClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:AMT_URL_BASE]];
    });
    
    return _sharedAPIClient;
    
}

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

#pragma mark - API Routes

- (void)loginWithUsername:(NSString *)username andPassword:(NSString *)password completionBlock:(AMTAPIClientCompletion)completionBlock
{    
    NSDictionary *params = @{
        @"name" : username,
        @"pass": password,
        @"op": @"Log In",
        @"openid.return_to": @"http://acemonstertoys.org/openid/authenticate?destination=node",
        @"form_id": @"user_login_block",
        @"form_build_id": @"form-4d6478bc67a79eda5e36c01499ba4c88"
    };
    [self postPath:AMT_URL_LOGIN parameters:params completionBlock:completionBlock];
}

- (void)unlockDoorWithPIN:(NSString *)PIN completionBlock:(AMTAPIClientCompletion)completionBlock
{
    NSDictionary *params = @{
        @"doorcode": PIN,
        @"forceit": @"Open Door"
    };
    
    [self postPath:AMT_URL_UNLOCK parameters:params completionBlock:completionBlock];
}

#pragma mark - Helpers for single completion block

- (void)getPath:(NSString *)path parameters:(NSDictionary *)parameters completionBlock:(AMTAPIClientCompletion)completionBlock
{
    [self getPath:path
       parameters:parameters
          success:[self successBlockWithCompletionBlock:completionBlock]
          failure:[self failureBlockWithCompletionBlock:completionBlock]
     ];
}

- (void)postPath:(NSString *)path parameters:(NSDictionary *)parameters completionBlock:(AMTAPIClientCompletion)completionBlock
{
    [self postPath:path
        parameters:parameters
           success:[self successBlockWithCompletionBlock:completionBlock]
           failure:[self failureBlockWithCompletionBlock:completionBlock]
     ];
}

- (void)putPath:(NSString *)path parameters:(NSDictionary *)parameters completionBlock:(AMTAPIClientCompletion)completionBlock
{
    [self putPath:path
        parameters:parameters
           success:[self successBlockWithCompletionBlock:completionBlock]
           failure:[self failureBlockWithCompletionBlock:completionBlock]
     ];
}

#pragma mark - AFNetworking Block generators
- (AFSuccessHandler)successBlockWithCompletionBlock:(AMTAPIClientCompletion)completionBlock {
    return ^(AFHTTPRequestOperation *operation, id responseObject) {
        [self logResponse:operation response:responseObject error:nil];
        
        if (completionBlock) {
            completionBlock(operation, responseObject, nil);
        }
    };
}

- (AFFailureHandler)failureBlockWithCompletionBlock:(AMTAPIClientCompletion)completionBlock {
    return ^(AFHTTPRequestOperation *operation, NSError *error) {
        [self logResponse:operation response:nil error:error];
        
        if (completionBlock) {
            completionBlock(operation, nil, error);
        }
        if ([operation.response statusCode] == 401) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationAPIClientAuthenticationFailure object:operation.response];
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
