//
//  RRManagedObjectContext.h
//  RSSReader
//
//  Created by admin on 1/22/13.
//  Copyright (c) 2013 Roman Dyadenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RRManagedObjectContext : NSObject

+ (NSManagedObjectContext *)sharedManagedObjectContext;
@end
