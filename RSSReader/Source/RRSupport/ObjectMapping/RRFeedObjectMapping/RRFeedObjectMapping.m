//
//  RRFeedObjectMapping.m
//  RSSReader
//
//  Created by admin on 1/17/13.
//  Copyright (c) 2013 Roman Dyadenko. All rights reserved.
//

#import "RRFeedObjectMapping.h"

@implementation RRFeedObjectMapping

+ (RKObjectMapping *)objectMapping
{
    RKObjectMapping* feedMapping = [RKObjectMapping mappingForClass:[self class]];
    
    [feedMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"feed"
                                                                                toKeyPath:@"siteInfo"
                                                                              withMapping:[RRSiteInfoObjectMapping objectMapping]]];
    
    return feedMapping;
}

@end
