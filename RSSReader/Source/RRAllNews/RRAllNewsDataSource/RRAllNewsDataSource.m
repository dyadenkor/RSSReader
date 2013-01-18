//
//  RRAllNewsDataSource.m
//  RSSReader
//
//  Created by admin on 1/17/13.
//  Copyright (c) 2013 Roman Dyadenko. All rights reserved.
//

#import "RRAllNewsDataSource.h"

@implementation RRAllNewsDataSource
@synthesize siteName;
@synthesize siteNews;

- (id)init
{
    self = [super init];
    if (self)
    {
        siteNews = [[NSMutableArray alloc] init];
        // Custom initialization
    }
    return self;
}

@end
