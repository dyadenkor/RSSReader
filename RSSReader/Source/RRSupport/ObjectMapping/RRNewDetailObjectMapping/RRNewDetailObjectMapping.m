//
//  RRNewDetailObjectMapping.m
//  RSSReader
//
//  Created by admin on 1/17/13.
//  Copyright (c) 2013 Roman Dyadenko. All rights reserved.
//

#import "RRNewDetailObjectMapping.h"

@implementation RRNewDetailObjectMapping

+ (RKObjectMapping *)objectMapping
{
    RKObjectMapping *newDetail = [RKObjectMapping mappingForClass:[self class]];
    [newDetail addAttributeMappingsFromDictionary:
     @{
     @"title": @"title",
     @"link": @"link",
     @"publishedDate": @"date",
     @"content": @"content",
     }];
    
    return newDetail;
}

@end
