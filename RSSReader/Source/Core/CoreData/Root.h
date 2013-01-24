//
//  Root.h
//  RSSReader
//
//  Created by Oleg Salyvin on 1/25/13.
//  Copyright (c) 2013 Roman Dyadenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Root : NSManagedObject

@property (nonatomic, retain) NSString * someId;
@property (nonatomic, retain) NSNumber * statusCode;

@end
