//
//  SavedNews.h
//  RSSReader
//
//  Created by admin on 2/22/13.
//  Copyright (c) 2013 Roman Dyadenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SavedNews : NSManagedObject

@property (nonatomic, retain) NSData * newsContent;
@property (nonatomic, retain) NSString * newsDescription;
@property (nonatomic, retain) NSString * newsLink;
@property (nonatomic, retain) NSString * newsTitle;

@end
