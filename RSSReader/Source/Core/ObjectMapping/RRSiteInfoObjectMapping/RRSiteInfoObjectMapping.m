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

+ (RKObjectMapping *)objectMapping
{
    RKObjectMapping *siteInfo = [RKObjectMapping mappingForClass:[self class]];
    [siteInfo addAttributeMappingsFromDictionary:
    @{
        @"title": @"title",
        @"link": @"link",
    }];
    
    [siteInfo addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"entries"
                                                                             toKeyPath:@"entries"
                                                                           withMapping:[RRNewDetailObjectMapping objectMapping]]];
    return siteInfo;
}

@end
