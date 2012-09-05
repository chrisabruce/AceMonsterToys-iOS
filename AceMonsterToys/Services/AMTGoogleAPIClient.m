//
//  AMTGoogleAPIClient.m
//  AceMonsterToys
//
//  Created by Chris Bruce on 9/4/12.
//  Copyright (c) 2012 Ace Monster Toys. All rights reserved.
//

#import "AMTGoogleAPIClient.h"

#import "AMTDateHelper.h"

@implementation AMTGoogleAPIClient

+ (AMTGoogleAPIClient *)sharedClient
{
    static AMTGoogleAPIClient *_sharedGoogleAPIClient = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        NSLog(@"Initializing GoogleAPIClient to use: %@", GOOGLE_URL_API_BASE);
        _sharedGoogleAPIClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:GOOGLE_URL_API_BASE]];
        [_sharedGoogleAPIClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    });
    
    return _sharedGoogleAPIClient;
}

- (void)getEventsWithCompletionBlock:(AMTClientCompletion)completionBlock
{
    NSDate *now = [[NSDate date] dateByAddingTimeInterval:-(60*60*24)];
    NSString *dateTimeString = [[AMTDateHelper iso8601DateFormatter] stringFromDate:now];
    
    NSString *path = [NSString stringWithFormat:@"%@?key=%@&orderBy=startTime&singleEvents=true&maxResults=20&timeMin=%@", GOOGLE_URL_CALENDAR_EVENTS, GOOGLE_API_KEY, dateTimeString];
    [self getPath:path parameters:nil completionBlock:completionBlock];
}

@end
