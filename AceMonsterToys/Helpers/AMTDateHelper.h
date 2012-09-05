//
//  AMTDateHelper.h
//  AceMonsterToys
//
//  Created by Chris Bruce on 9/5/12.
//  Copyright (c) 2012 Ace Monster Toys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AMTDateHelper : NSObject

+ (NSDateFormatter *)iso8601DateFormatter;
+ (NSDateFormatter *)dateFormatter;

@end
