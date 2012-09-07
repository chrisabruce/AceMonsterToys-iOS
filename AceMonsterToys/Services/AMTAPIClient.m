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

#import "AMTAPIClient.h"


@interface AMTAPIClient ()
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


#pragma mark - API Routes

- (void)loginWithUsername:(NSString *)username andPassword:(NSString *)password completionBlock:(AMTClientCompletion)completionBlock
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

- (void)unlockDoorWithPIN:(NSString *)PIN completionBlock:(AMTClientCompletion)completionBlock
{
    NSDictionary *params = @{
        @"doorcode": PIN,
        @"forceit": @"Open Door"
    };
    
    [self postPath:AMT_URL_UNLOCK parameters:params completionBlock:completionBlock];
}

- (void)webcamImageWithCompletionBlock:(AMTClientCompletion)completionBlock
{
    [self getPath:AMT_URL_WEBCAM parameters:nil completionBlock:completionBlock];
}



@end
