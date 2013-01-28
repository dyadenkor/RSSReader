//
//  RRSiteInfoObjectMapping.h
//  RSSReader
//
//  Created by admin on 1/17/13.
//  Copyright (c) 2013 Roman Dyadenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RRSiteInfoObjectMapping : NSObject
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *link;
@property (nonatomic, strong) NSMutableArray *entries;

+ (RKEntityMapping *)objectMapping;

@end
