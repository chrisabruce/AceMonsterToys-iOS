//
//  AMTCamViewController.m
//  AceMonsterToys
//
//  Created by Chris Bruce on 9/6/12.
//  Copyright (c) 2012 Ace Monster Toys. All rights reserved.
//

#import "AMTCamViewController.h"

#import "AMTAPIClient.h"

@interface AMTCamViewController ()
- (void)fetchData;
@end

@implementation AMTCamViewController {
    NSTimer *refreshTimer;
}
@synthesize scrollView;
@synthesize imageView;
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self fetchData];
	
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.imageView.image == nil) {
        [self.applicationDelegate showSpinnerWithMessage:nil];
    }
    
    refreshTimer = [NSTimer scheduledTimerWithTimeInterval:0.50f target:self selector:@selector(fetchData) userInfo:nil repeats:YES];
    [refreshTimer fire];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [refreshTimer invalidate];
}

- (void)viewDidUnload
{
    [self setImageView:nil];
    [self setScrollView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    CGRect imageFrame = self.imageView.frame;
    imageFrame.origin.x = 5.0;
    imageFrame.origin.y = 5.0;
    
    CGRect viewportSize = [[UIScreen mainScreen] bounds];
    CGFloat width;
        
    if (UIDeviceOrientationIsLandscape(toInterfaceOrientation)) {
        width = viewportSize.size.height - 10;
    } else {
        width = viewportSize.size.width - 10;
    }
    
    imageFrame.size.width = width;
    imageFrame.size.height = (width / 4) * 3; // Defualt Webcam image size is 800x600 (4:3)
    
    self.imageView.frame = imageFrame;

}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.imageView.frame.size.height);
}

#pragma mark - Privates

- (void)fetchData
{
    __block AMTCamViewController *blockSelf = self;
    
    AMTAPIClient *apiClient = [AMTAPIClient sharedClient];
    [apiClient webcamImageWithCompletionBlock:^(AFHTTPRequestOperation *operation, id responseObject, NSError *error) {
        [blockSelf.applicationDelegate hideSpinner];
        if (error == nil && [responseObject isKindOfClass:[NSData class]]) {
            UIImage *camImage = [UIImage imageWithData:responseObject];
            blockSelf.imageView.image = camImage;
        }
    }];
}

@end
