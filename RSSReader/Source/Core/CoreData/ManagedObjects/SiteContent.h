//
//  SiteContent.h
//  RSSReader
//
//  Created by admin on 2/13/13.
//  Copyright (c) 2013 Roman Dyadenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SiteInfo;

@interface SiteContent : NSManagedObject

@property (nonatomic, retain) NSString * newsContent;
@property (nonatomic, retain) NSString * newsLink;
@property (nonatomic, retain) NSString * newsTitle;
@property (nonatomic, retain) SiteInfo *siteInfo;

@end
