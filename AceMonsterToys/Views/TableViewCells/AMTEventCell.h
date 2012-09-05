//
//  AMTEventCell.h
//  AceMonsterToys
//
//  Created by Chris Bruce on 9/5/12.
//  Copyright (c) 2012 Ace Monster Toys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AMTEventCell : UITableViewCell

@property (nonatomic, strong) NSDictionary *eventDetailsDict;

@property (nonatomic, strong) IBOutlet UILabel *infoLabel;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *descriptionLabel;
@end
