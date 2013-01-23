//
//  SiteInfo.h
//  RSSReader
//
//  Created by admin on 1/22/13.
//  Copyright (c) 2013 Roman Dyadenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SiteInfo : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSSet *siteNews;
@property (nonatomic, retain) NSManagedObject *siteLink;
@end

@interface SiteInfo (CoreDataGeneratedAccessors)

- (void)addSiteNewsObject:(NSManagedObject *)value;
- (void)removeSiteNewsObject:(NSManagedObject *)value;
- (void)addSiteNews:(NSSet *)values;
- (void)removeSiteNews:(NSSet *)values;

@end
