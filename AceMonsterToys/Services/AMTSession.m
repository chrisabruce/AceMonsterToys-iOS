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

#import "AMTSession.h"

#import "AMTAPIClient.h"
#import "KeychainItemWrapper.h"

@interface AMTSession ()
- (void)saveSessionData;
- (void)deleteSessionData;
- (void)setAuthHeaders:(NSString *)authToken;
- (void)clearAuthHeaders;
@end

@implementation AMTSession {
    __strong KeychainItemWrapper *keychain;
}

@synthesize username = _username;
@synthesize password = _password;
@synthesize authToken = _authToken;

+ (void)initialize {
    NSAssert(self == [AMTSession class], @"This class is not designed to be subclassed.");
}

+ (AMTSession *)sharedSession {
    static AMTSession *_sharedSession = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedSession = [[self alloc] init];
    });
    
    return _sharedSession;
}

- (id)init {
    if ((self = [super init])) {
        keychain = [[KeychainItemWrapper alloc] initWithIdentifier:kKeyChainIdentifierSession accessGroup:nil];
    }
    return self;
}

- (void)startSessionWithUsername:(NSString *)email andPassword:(NSString *)password andAuthToken:(NSString *)authToken {
    _authToken = authToken;
    _username = email;
    _password = password;
    [self saveSessionData];
    
    if (authToken) {
        [self setAuthHeaders:authToken];
    } else {
        [[AMTAPIClient sharedClient] setAuthorizationHeaderWithUsername:email password:password];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUserDidLogIn object:nil];
}

// Login with email/password
- (void)loginWith:(NSString *)email 
      andPassword:(NSString *)password 
completionHandler:(void (^)(void))completionHandler 
   failureHandler:(void (^)(NSError *error))failureHandler {
    //OMAPIClient *apiClient = [OMAPIClient sharedClient];
    
    //TODO
}

- (void)logout {
    [self clearSession];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUserDidLogOut object:nil];
}

- (void)clearSession {
    _username = nil;
    _password = nil;
    _authToken = nil;
    [self deleteSessionData];
    [self clearAuthHeaders];
}

#pragma mark - Properties

- (BOOL)isActive {
    BOOL result = ((nil != self.username && nil != self.password) || (nil != self.username && nil != self.authToken));
    return result;
}

- (void)loadSessionData {
    _username = [keychain objectForKey:(__bridge id)kSecAttrAccount];
    _password = [keychain objectForKey:(__bridge id)kSecValueData];
    _authToken = [keychain objectForKey:(__bridge id)kSecAttrService];
    
    if ([@"" isEqualToString:_username] || [@"" isEqualToString:_password]) {
        _username = nil;
        _password = nil;
    }
    
    if ([@"" isEqualToString:_authToken]) {
        _authToken = nil;
    }
    
    if ([self isActive]) {
        if (_authToken != nil) {
            [self setAuthHeaders:self.authToken];
        } else {
            [[AMTAPIClient sharedClient] setAuthorizationHeaderWithUsername:self.username password:self.password];
        }
    } else {
        [self clearAuthHeaders];
    }
    //[self preauthenticateDiags];
}

#pragma mark - Privates

// Persist Session Data
- (void)saveSessionData {
    [keychain setObject:self.username forKey:(__bridge id)kSecAttrAccount];
    [keychain setObject:self.password forKey:(__bridge id)kSecValueData];
    [keychain setObject:self.authToken forKey:(__bridge id)kSecAttrService];
}

// Delete Session Data
- (void)deleteSessionData {
    [keychain resetKeychainItem];
}

// Set Authorization Headers for HTTP Clients
- (void)setAuthHeaders:(NSString *)authToken {
    [[AMTAPIClient sharedClient] setAuthorizationHeaderWithToken:self.authToken];
}

// Clears Authorization Headers for HTTP Clients
- (void)clearAuthHeaders {
    [[AMTAPIClient sharedClient] clearAuthorizationHeader];
}


@end
