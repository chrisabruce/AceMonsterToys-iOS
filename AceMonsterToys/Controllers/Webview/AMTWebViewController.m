/*************************************************************************
 
 Created by Chris Bruce on 9/2/12
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

#import "AMTWebViewController.h"

@interface AMTWebViewController ()
- (void)loadData;
@end

@implementation AMTWebViewController

@synthesize html = _html;
@synthesize URL = _URL;
@synthesize webView = _webView;

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self loadData];
}

- (void)viewDidUnload
{
    [self setWebView:nil];
    [super viewDidUnload];
}

- (void)setHtml:(NSString *)html
{
    _html = html;
    [self loadData];
}

- (void)setURL:(NSURL *)URL
{
    _URL = URL;
    [self loadData];
    
}

- (void)loadData
{
    NSLog(@"html: %@, URL: %@", _html, _URL);
    if (_html && _html.length > 0) {
        [self.webView loadHTMLString:_html baseURL:nil];
    } else if (_URL != nil) {
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:_URL];        
        [self.webView loadRequest:request];
    }
}

#pragma mark - UIWebView Delegates
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.applicationDelegate showSpinnerWithMessage:nil];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *htmlTitle = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if ([htmlTitle length] > 0) {
        self.title = htmlTitle;
    }
    [self.applicationDelegate hideSpinner];
}


@end
