//
//  RRNewDetailObjectMapping.m
//  RSSReader
//
//  Created by admin on 1/17/13.
//  Copyright (c) 2013 Roman Dyadenko. All rights reserved.
//

#import "RRNewDetailObjectMapping.h"

@implementation RRNewDetailObjectMapping

+ (RKEntityMapping *)objectMapping
{
     RKEntityMapping* newDetail = [RKEntityMapping mappingForEntityForName:SiteContentEntityName
                                                      inManagedObjectStore:[[RKObjectManager sharedManager] managedObjectStore]];
    
    [newDetail addAttributeMappingsFromDictionary:
     @{
     @"title": @"newsTitle",
     @"link": @"newsLink",
     //@"publishedDate": @"date",
     @"content": @"newsContent"
     }];
    
    return newDetail;
}

@end
