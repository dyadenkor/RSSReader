//
//  RRAllNewsDataSourceItem.h
//  RSSReader
//
//  Created by admin on 1/17/13.
//  Copyright (c) 2013 Roman Dyadenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RRAllNewsDataSourceItem : NSObject

@property (nonatomic, strong) NSString *siteName;
@property (nonatomic, strong) NSString *siteURL;
@property (nonatomic, strong) NSMutableArray *siteNews;

@end
