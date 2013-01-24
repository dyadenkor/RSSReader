//
//  Root.h
//  RSSReader
//
//  Created by admin on 1/24/13.
//  Copyright (c) 2013 Roman Dyadenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Root : NSManagedObject

@property (nonatomic, retain) NSNumber * statusCode;
@property (nonatomic, retain) NSNumber * someID;

@end
