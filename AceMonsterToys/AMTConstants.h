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

#pragma mark - URLS

//#define API_LOG_RESPONSES

#ifdef USE_LOCAL
    #define AMT_URL_BASE @"http://localhost:3000"
#else
    #define AMT_URL_BASE @"http://acemonstertoys.org"
    #define _AFNETWORKING_ALLOW_INVALID_SSL_CERTIFICATES_ 1
#endif

#define AMT_URL_LOGIN @"/node?destination=node"
#define AMT_URL_UNLOCK @"/membership"

#define AMT_URL_ABOUT @"http://acemonstertoys.org"

#define AMT_URL_UPCOMING @"https://www.google.com/calendar/render?cid=mtim8b2triatrns3gpkfn7m56o@group.calendar.google.com"

#define GOOGLE_URL_API_BASE @"https://www.googleapis.com"
#define GOOGLE_URL_CALENDAR_EVENTS @"/calendar/v3/calendars/mtim8b2triatrns3gpkfn7m56o@group.calendar.google.com/events"

#pragma mark - API Keys
#define GOOGLE_API_KEY @"AIzaSyA5e7L6zo1Bl0-AqDaOW43UWo8rY2UCanE"

#pragma mark - Helpers

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define DEVICE_CAN_CALL [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel://"]]

extern NSString * const kApplicationName;

#pragma mark - Notifications
extern NSString * const kNotificationUserDidLogIn;
extern NSString * const kNotificationUserDidLogOut;

#pragma mark - Other
extern NSString *const kKeyChainIdentifierSession;