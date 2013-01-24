//
//  SiteInfo.h
//  RSSReader
//
//  Created by Oleg Salyvin on 1/24/13.
//  Copyright (c) 2013 Roman Dyadenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SiteContent, SiteLink;

@interface SiteInfo : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) SiteLink *siteLink;
@property (nonatomic, retain) NSSet *siteNews;
@end

@interface SiteInfo (CoreDataGeneratedAccessors)

- (void)addSiteNewsObject:(SiteContent *)value;
- (void)removeSiteNewsObject:(SiteContent *)value;
- (void)addSiteNews:(NSSet *)values;
- (void)removeSiteNews:(NSSet *)values;

@end
