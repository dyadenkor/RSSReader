//
//  SiteInfo.h
//  RSSReader
//
//  Created by admin on 2/27/13.
//  Copyright (c) 2013 Roman Dyadenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SiteContent;

@interface SiteInfo : NSManagedObject

@property (nonatomic, retain) NSNumber * autoRefreshTime;
@property (nonatomic, retain) NSNumber * isAutoRefresh;
@property (nonatomic, retain) NSNumber * isShowOnlyUnreadNews;
@property (nonatomic, retain) NSNumber * maxNumbersOfNews;
@property (nonatomic, retain) NSNumber * needOffNews;
@property (nonatomic, retain) NSNumber * sitePosition;
@property (nonatomic, retain) NSString * siteUrl;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSSet *siteNews;
@end

@interface SiteInfo (CoreDataGeneratedAccessors)

- (void)addSiteNewsObject:(SiteContent *)value;
- (void)removeSiteNewsObject:(SiteContent *)value;
- (void)addSiteNews:(NSSet *)values;
- (void)removeSiteNews:(NSSet *)values;

@end
