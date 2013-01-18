//
//  RRServerGateway.h
//  RSSReader
//
//  Created by admin on 1/15/13.
//  Copyright (c) 2013 Roman Dyadenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RestKit.h"

@protocol RRServerGatewayDelegate <NSObject>

- (void)didRecieveResponceSucces:(RKMappingResult *)mappingResult;
- (void)didRecieveResponceFailure:(NSError *)error;

@end

@interface RRServerGateway : NSObject
@property (nonatomic, weak) id<RRServerGatewayDelegate> delegate;
@property (nonatomic, copy) NSString *baseURL;

- (void)sendData;

@end
