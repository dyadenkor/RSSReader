//
//  RRAllNewsCell.m
//  RSSReader
//
//  Created by admin on 1/23/13.
//  Copyright (c) 2013 Roman Dyadenko. All rights reserved.
//

#import "RRAllNewsCell.h"

@implementation RRAllNewsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [[self notReadButton] addSubview:[self notReadImageView]];
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
