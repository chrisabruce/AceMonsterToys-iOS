//
//  AMTGoogleAPIClient.h
//  AceMonsterToys
//
//  Created by Chris Bruce on 9/4/12.
//  Copyright (c) 2012 Ace Monster Toys. All rights reserved.
//

#import "AMTClient.h"

@interface AMTGoogleAPIClient : AMTClient

+ (AMTGoogleAPIClient *)sharedClient;

- (void)getEventsWithCompletionBlock:(AMTClientCompletion)completionBlock;

@end
