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

#import "AMTLocation.h"

NSString * const kNotificationUserLocationDidUpdate = @"kNotificationUserLocationDidUpdate";

#define DISTANCE_FILTER_METERS 800

@implementation AMTLocation

@synthesize locationManager;
@synthesize currentLocation;

+ (AMTLocation *)sharedLocation
{
    static AMTLocation *_sharedLocation = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedLocation = [[self alloc] init];
    });
    
    return _sharedLocation;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.locationManager =[[CLLocationManager alloc] init];
        locationManager.distanceFilter = DISTANCE_FILTER_METERS;
        locationManager.delegate = self;        
    }
    return self;
}

- (void)startUpdatingIfEnabled
{
    if ([CLLocationManager locationServicesEnabled] == YES
        && [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized) {
        [locationManager startUpdatingLocation];
    }
}

- (void)startUpdating
{
    [locationManager startUpdatingLocation];
}

- (void)stopUpdating
{
    [locationManager stopMonitoringSignificantLocationChanges];
    [locationManager stopUpdatingHeading];
    [locationManager stopUpdatingLocation];
}

#pragma mark - CLLocationManager Delegates

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"New location: %@", newLocation);
    if (currentLocation == nil || newLocation.timestamp > currentLocation.timestamp) {
        self.currentLocation = newLocation;
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUserLocationDidUpdate object:newLocation];
    }
    
}



@end
