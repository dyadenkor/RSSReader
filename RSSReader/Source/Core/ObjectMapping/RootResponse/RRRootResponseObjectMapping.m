//
//  RRRootResponseObjectMapping.m
//  RSSReader
//
//  Created by admin on 1/16/13.
//  Copyright (c) 2013 Roman Dyadenko. All rights reserved.
//

#import "RRRootResponseObjectMapping.h"

@implementation RRRootResponseObjectMapping
@synthesize responceStatusCode;
@synthesize responseData;

+ (RKObjectMapping *)objectMapping
{
    RKObjectMapping *rootMmapping = [RKObjectMapping mappingForClass:[self class]];
    [rootMmapping addAttributeMappingsFromDictionary:
    @{
        @"responseStatus": @"responceStatusCode",
    }];
    
    [rootMmapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"responseData"
                                                                                 toKeyPath:@"responseData"
                                                                               withMapping:[RRFeedObjectMapping objectMapping]]];
    
    return rootMmapping;
}

@end
