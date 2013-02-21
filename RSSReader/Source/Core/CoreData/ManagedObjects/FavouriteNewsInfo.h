//
//  FavouriteNewsInfo.h
//  RSSReader
//
//  Created by admin on 2/19/13.
//  Copyright (c) 2013 Roman Dyadenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface FavouriteNewsInfo : NSManagedObject

@property (nonatomic, retain) NSString * newsDescription;
@property (nonatomic, retain) NSString * newslink;
@property (nonatomic, retain) NSString * newsTitle;

@end
