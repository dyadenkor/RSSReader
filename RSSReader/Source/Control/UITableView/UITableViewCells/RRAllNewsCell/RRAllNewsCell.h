//
//  RRAllNewsCell.h
//  RSSReader
//
//  Created by admin on 1/23/13.
//  Copyright (c) 2013 Roman Dyadenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RRAllNewsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *description;
@property (weak, nonatomic) IBOutlet UIButton *favouriteButton;

@end
