//
//  FavouriteNewsInfo.h
//  RSSReader
//
//  Created by admin on 2/12/13.
//  Copyright (c) 2013 Roman Dyadenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface FavouriteNewsInfo : NSManagedObject

@property (nonatomic, retain) NSString * newsTitle;
@property (nonatomic, retain) NSString * newsDescription;
@property (nonatomic, retain) NSData * newsContent;

@end
