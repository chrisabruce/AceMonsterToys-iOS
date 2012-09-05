//
//  AMTEventCell.m
//  AceMonsterToys
//
//  Created by Chris Bruce on 9/5/12.
//  Copyright (c) 2012 Ace Monster Toys. All rights reserved.
//

#import "AMTEventCell.h"

#import "AMTDateHelper.h"
#import "AMTDisplayHelper.h"

@implementation AMTEventCell

@synthesize eventDetailsDict = _eventDetailsDict;


- (void)setEventDetailsDict:(NSDictionary *)eventDetailsDict
{
    _eventDetailsDict = eventDetailsDict;
    
    NSDate *startsAt;
    NSError *error;
    NSString *startsAtString = [eventDetailsDict valueForKeyPath:@"start.dateTime"];
    
    if (startsAtString == nil) {
        startsAtString = [eventDetailsDict valueForKeyPath:@"start.date"];
        startsAt = [[AMTDateHelper dateFormatter] dateFromString:startsAtString];
        self.infoLabel.text = [AMTDisplayHelper stringFromDate:startsAt];
    } else {
        [[AMTDateHelper iso8601DateFormatter] getObjectValue:&startsAt forString:startsAtString range:nil error:&error];
        self.infoLabel.text = [AMTDisplayHelper stringFromDateLong:startsAt];
    }
    
    
    self.titleLabel.text = [eventDetailsDict objectForKeyNotNull:@"summary"];
    self.descriptionLabel.text = [eventDetailsDict objectForKeyNotNull:@"description"];
}
@end
