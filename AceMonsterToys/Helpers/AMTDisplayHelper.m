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

#import "AMTDisplayHelper.h"

@implementation AMTDisplayHelper

+ (NSString *)distanceToString:(double)distance
{
    float feet = distance * 3.28083989501312;
    float miles = feet/5280;
    
    if (feet <= 500)
        return [NSString stringWithFormat:@"%g ft", roundf(feet)];
    else if (miles < 2)
        return [NSString stringWithFormat:@"%G mi", roundf(miles * 10)/10];
    else
        return [NSString stringWithFormat:@"%g mi", roundf(miles)];
}

+ (NSString *)stringFromDateLong:(NSDate *)date
{
    static NSDateFormatter *__dateFormatterLong;
    if (__dateFormatterLong == nil) {
        __dateFormatterLong = [[NSDateFormatter alloc] init];
        __dateFormatterLong.dateFormat = @"cccc MMM d @h:mm a";
    }
    return [__dateFormatterLong stringFromDate:date];
}

+ (NSString *)stringFromDate:(NSDate *)date
{
    static NSDateFormatter *__dateFormatter;
    if (__dateFormatter == nil) {
        __dateFormatter = [[NSDateFormatter alloc] init];
        __dateFormatter.dateFormat = @"cccc MMM d";
    }
    return [__dateFormatter stringFromDate:date];
}

+ (UIColor *)darkenColor:(UIColor *)color
{
    CGFloat hue, saturation, brightness, alpha;
    UIColor *darkerColor = color;
    
    if ([color getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha]) {
        darkerColor = [UIColor colorWithHue:hue saturation:saturation brightness:brightness - 0.25 alpha:alpha];
    }
    return darkerColor;
}

@end
