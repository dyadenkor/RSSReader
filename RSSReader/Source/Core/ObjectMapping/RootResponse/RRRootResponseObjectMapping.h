//
//  RRRootResponseObjectMapping.h
//  RSSReader
//
//  Created by admin on 1/16/13.
//  Copyright (c) 2013 Roman Dyadenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RRRootResponseObjectMapping : NSObject

@property (nonatomic, strong) NSNumber *responceStatusCode;
@property (nonatomic, strong) NSMutableArray *responseData;

+ (RKObjectMapping *)objectMapping;

@end
