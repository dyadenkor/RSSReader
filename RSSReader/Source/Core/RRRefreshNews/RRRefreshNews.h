//
//  RRRefreshNews.h
//  RSSReader
//
//  Created by admin on 2/27/13.
//  Copyright (c) 2013 Roman Dyadenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RRRefreshNews : NSObject <RRServerGatewayDelegate>

- (void)start:(NSString *)theUrl;

@end
