//
//  RRRefreshNews.m
//  RSSReader
//
//  Created by admin on 2/27/13.
//  Copyright (c) 2013 Roman Dyadenko. All rights reserved.
//

#import "RRRefreshNews.h"
#import "RRSiteContentDataSource.h"

@interface RRRefreshNews ()

//SiteInfo
@property (nonatomic) NSArray *arrayOfOneSite;
@property (nonatomic) NSNumber *autorefreshTime;
@property (nonatomic) NSNumber *maxNumberOfNews;
@property (nonatomic) NSNumber *sitePosition;
@property (nonatomic) NSString *theUrl;
@property (nonatomic) BOOL isAutorefresh;
@property (nonatomic) BOOL isShowOnlyUnread;
@property (nonatomic) NSMutableArray *oldNews;

@end


@implementation RRRefreshNews

- (BOOL)startIsOK:(NSString *)theUrl
{
    NSPredicate *predicate =
    [NSPredicate predicateWithFormat:@"(siteUrl == %@)",theUrl];
    
    self.oldNews = [[NSMutableArray alloc] init];
    
    self.arrayOfOneSite =
    [[RRCoreDataSupport fetchData:SiteInfoEntityName] filteredArrayUsingPredicate:predicate];
    
    if (![[self arrayOfOneSite] count])
    {
        return NO;
    }
    
    [self saveOldSite];
    [self deleteOldSite];
    [self loadNewSite];
    
    return YES;
}

- (void)saveOldSite
{
    [self setAutorefreshTime:[[[self arrayOfOneSite] lastObject] autoRefreshTime]];
    [self setMaxNumberOfNews:[[[self arrayOfOneSite] lastObject] maxNumbersOfNews]];
    [self setSitePosition:[[[self arrayOfOneSite] lastObject] sitePosition]];
    [self setTheUrl:[[[self arrayOfOneSite] lastObject] siteUrl]];
    [self setIsAutorefresh:[[[[self arrayOfOneSite] lastObject] isAutoRefresh] boolValue]];
    [self setIsShowOnlyUnread:[[[[self arrayOfOneSite] lastObject] isShowOnlyUnreadNews] boolValue]];
    
    
    for (SiteContent *item in [[[self arrayOfOneSite] lastObject] siteNews])
    {
        RRSiteContentDataSource *siteContent = [[RRSiteContentDataSource alloc] init];
        
        [siteContent setIsFavourite:[[item isFavourite] boolValue]];
        [siteContent setIsRead:[[item isRead] boolValue]];
        [siteContent setIsSaved:[[item isSaved] boolValue]];
        [siteContent setNewsLink:[item newsLink]];
        
        [[self oldNews] addObject:siteContent];
    }
}

- (void)deleteOldSite
{
    SiteInfo *delete = [[self arrayOfOneSite] lastObject];
    NSManagedObjectContext *context = [RRManagedObjectContext sharedManagedObjectContext];
    [context deleteObject:delete];
    
    [RRCoreDataSupport saveManagedObjectContext];
}

- (void)loadNewSite
{
    RRServerGateway *serverGateWay = [[RRServerGateway alloc] init];
    [serverGateWay setDelegate:self];
    [serverGateWay sendData:[self theUrl] newsCount:[[self maxNumberOfNews] intValue]];
}

#pragma mark - RRServerGatewayDelegate

- (void)didRecieveResponceFailure:(NSError *)error
{
    NSLog(@"Error   -----   %@",error);
}

- (void)didRecieveResponceSucces:(RKMappingResult *)mappingResult
{
    NSPredicate *predicate =
    [NSPredicate predicateWithFormat:@"(siteUrl == %@)",[self theUrl]];
    
    self.arrayOfOneSite =
    [[RRCoreDataSupport fetchData:SiteInfoEntityName] filteredArrayUsingPredicate:predicate];
    
    [[[self arrayOfOneSite] lastObject] setAutoRefreshTime:[self autorefreshTime]];
    [[[self arrayOfOneSite] lastObject] setMaxNumbersOfNews:[self maxNumberOfNews]];
    [[[self arrayOfOneSite] lastObject] setSitePosition:[self sitePosition]];
    [[[self arrayOfOneSite] lastObject] setIsAutoRefresh:[NSNumber numberWithBool:[self isAutorefresh]]];
    [[[self arrayOfOneSite] lastObject] setIsShowOnlyUnreadNews:[NSNumber numberWithBool:[self isShowOnlyUnread]]];
    
    for (SiteContent *itemSiteContent in [[[self arrayOfOneSite] lastObject] siteNews])
    {
        for (RRSiteContentDataSource *itemSiteContentDataSource in [self oldNews])
        {
            if ([[itemSiteContent newsLink] isEqualToString:[itemSiteContentDataSource newsLink]])
            {
                [itemSiteContent setIsFavourite:[NSNumber numberWithBool:[itemSiteContentDataSource isFavourite]]];
                [itemSiteContent setIsSaved:[NSNumber numberWithBool:[itemSiteContentDataSource isSaved]]];
                [itemSiteContent setIsRead:[NSNumber numberWithBool:[itemSiteContentDataSource isRead]]];
                
                break;
            }
        }
    }
    
    [RRCoreDataSupport saveManagedObjectContext];
}

@end
