//
//  RRCoreDataSupport.h
//  RSSReader
//
//  Created by admin on 1/25/13.
//  Copyright (c) 2013 Roman Dyadenko. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const SiteContentEntityName;
extern NSString *const SiteInfoEntityName;
extern NSString *const ServerBaseURL;

@interface RRCoreDataSupport : NSObject

+ (NSError *)saveManagedObjectContext;

@end
