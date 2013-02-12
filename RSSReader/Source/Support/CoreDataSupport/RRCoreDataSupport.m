//
//  RRCoreDataSupport.m
//  RSSReader
//
//  Created by admin on 1/25/13.
//  Copyright (c) 2013 Roman Dyadenko. All rights reserved.
//

#import "RRCoreDataSupport.h"

NSString * const SiteContentEntityName = @"SiteContent";
NSString * const SiteInfoEntityName = @"SiteInfo";
NSString * const FavouriteNewsInfoEntityName = @"FavouriteNewsInfo";
NSString * const ServerBaseURL = @"https://ajax.googleapis.com";

@implementation RRCoreDataSupport

+ (NSError *)saveManagedObjectContext
{
    NSError *error = nil;
    
    if ([[RRManagedObjectContext sharedManagedObjectContext] save:&error])
    {
        NSLog(@"error = %@", [error description]);
        
        return error;
    }
    
    return error;
}

@end
