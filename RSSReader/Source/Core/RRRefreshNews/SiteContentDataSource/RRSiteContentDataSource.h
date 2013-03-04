//
//  RRSiteContentDataSource.h
//  RSSReader
//
//  Created by admin on 3/4/13.
//  Copyright (c) 2013 Roman Dyadenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RRSiteContentDataSource : NSObject
@property (nonatomic) BOOL isFavourite;
@property (nonatomic) BOOL isRead;
@property (nonatomic) BOOL isSaved;
@property (nonatomic) NSString * newsLink;
@end
