//
//  RRFeedObjectMapping.h
//  RSSReader
//
//  Created by admin on 1/17/13.
//  Copyright (c) 2013 Roman Dyadenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RRSiteInfoObjectMapping.h"

@interface RRFeedObjectMapping : NSObject
@property (nonatomic, strong) RRSiteInfoObjectMapping* siteInfo;

+ (RKObjectMapping *)objectMapping;

@end
