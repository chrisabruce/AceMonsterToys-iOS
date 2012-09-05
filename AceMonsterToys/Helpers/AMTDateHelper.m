//
//  AMTDateHelper.m
//  AceMonsterToys
//
//  Created by Chris Bruce on 9/5/12.
//  Copyright (c) 2012 Ace Monster Toys. All rights reserved.
//

#import "AMTDateHelper.h"

@implementation AMTDateHelper

+ (NSDateFormatter *)iso8601DateFormatter {
    static NSDateFormatter *__iso8601Formatter;
    if (__iso8601Formatter == nil) {
        __iso8601Formatter = [[NSDateFormatter alloc] init];
        [__iso8601Formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
        [__iso8601Formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    }
    return __iso8601Formatter;
}

+ (NSDateFormatter *)dateFormatter {
    static NSDateFormatter *__dateFormatter;
    if (__dateFormatter == nil) {
        __dateFormatter = [[NSDateFormatter alloc] init];
        [__dateFormatter setDateFormat:@"yyyy-MM-dd"];
    }
    return __dateFormatter;
}

@end
