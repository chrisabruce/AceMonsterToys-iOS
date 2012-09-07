//
//  AMTCamViewController.h
//  AceMonsterToys
//
//  Created by Chris Bruce on 9/6/12.
//  Copyright (c) 2012 Ace Monster Toys. All rights reserved.
//

#import "AMTBaseViewController.h"

@interface AMTCamViewController : AMTBaseViewController <UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@end
