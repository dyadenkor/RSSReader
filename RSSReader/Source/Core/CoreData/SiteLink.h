//
//  SiteLink.h
//  RSSReader
//
//  Created by Oleg Salyvin on 1/24/13.
//  Copyright (c) 2013 Roman Dyadenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SiteInfo;

@interface SiteLink : NSManagedObject

@property (nonatomic, retain) NSString * link;
@property (nonatomic, retain) SiteInfo *siteInfo;

@end
