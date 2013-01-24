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
     RKEntityMapping* newDetail = [RKEntityMapping mappingForEntityForName:@"SiteContent"
                                                      inManagedObjectStore:[[RKObjectManager sharedManager] managedObjectStore]];
    
   // RKObjectMapping *newDetail = [RKObjectMapping mappingForClass:[self class]];
    [newDetail addAttributeMappingsFromDictionary:
     @{
     @"title": @"newsTitle",
     @"link": @"newsLink"
    // @"publishedDate": @"date",
    // @"content": @"content",
     }];
    
    return newDetail;
}

@end
