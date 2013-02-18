//
//  SiteInfo.h
//  RSSReader
//
//  Created by admin on 2/18/13.
//  Copyright (c) 2013 Roman Dyadenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SiteContent;

@interface SiteInfo : NSManagedObject

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
