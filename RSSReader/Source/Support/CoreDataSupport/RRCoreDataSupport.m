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
NSString * const SavedNewsEntityName = @"SavedNews";

@implementation RRCoreDataSupport

+ (NSError *)saveManagedObjectContext
{
    NSError *error = nil;
    
    if (![[RRManagedObjectContext sharedManagedObjectContext] save:&error])
    {
        NSLog(@"error = %@", [error description]);
    }
    
    return error;
}

+ (NSMutableArray *)fetchData:(NSString *)entityName
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName
                                              inManagedObjectContext:[RRManagedObjectContext sharedManagedObjectContext]];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    if ([entityName isEqualToString:SiteContentEntityName])
    {
        [request setSortDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"newsDate" ascending:YES]]];
    }
    
    NSError *error = nil;
    
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    [resultArray addObjectsFromArray:[[RRManagedObjectContext sharedManagedObjectContext] executeFetchRequest:request
                                                                                                        error:&error]];
    
    if (error)
    {
        assert(0);
    }
    
    return resultArray;
}

@end
