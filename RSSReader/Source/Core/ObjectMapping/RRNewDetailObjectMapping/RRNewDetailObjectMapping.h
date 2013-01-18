//
//  RRNewDetailObjectMapping.h
//  RSSReader
//
//  Created by admin on 1/17/13.
//  Copyright (c) 2013 Roman Dyadenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RRNewDetailObjectMapping : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *link;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, copy) NSString *content;

+ (RKObjectMapping *)objectMapping;

@end
