//
//  RRSiteInfoObjectMapping.m
//  RSSReader
//
//  Created by admin on 1/17/13.
//  Copyright (c) 2013 Roman Dyadenko. All rights reserved.
//

#import "RRSiteInfoObjectMapping.h"

@implementation RRSiteInfoObjectMapping
@synthesize title;
@synthesize link;
@synthesize entries;

+ (RKEntityMapping *)objectMapping
{
    RKEntityMapping *siteInfo = [RKEntityMapping mappingForEntityForName:SiteInfoEntityName
                                                    inManagedObjectStore:[[RKObjectManager sharedManager] managedObjectStore]];
    siteInfo.identificationAttributes = @[ @"title" ];
    [siteInfo addAttributeMappingsFromDictionary:
    @{
        @"title": @"title",
       // @"link": @"link",
    }];
    
    [siteInfo addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"entries"
                                                                             toKeyPath:@"siteNews"
                                                                           withMapping:[RRNewDetailObjectMapping objectMapping]]];
    return siteInfo;
}

@end
