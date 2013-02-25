//
//  RRServerGateway.m
//  RSSReader
//
//  Created by admin on 1/15/13.
//  Copyright (c) 2013 Roman Dyadenko. All rights reserved.
//

#import "RRServerGateway.h"


@implementation RRServerGateway

- (void)sendData:(NSString *)siteUrl
       newsCount:(NSInteger)count
{
    if (count == 0)
        count = -1;
    
    // get data from server
    NSString *pathToResource = [NSString stringWithFormat:@"/ajax/services/feed/load?v=1.0&q=%@&num=%i&output=json", siteUrl, count];
    
    [[RKObjectManager sharedManager] getObjectsAtPath:pathToResource
                                           parameters:nil
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult)
     {
         [self.delegate didRecieveResponceSucces:mappingResult];
     }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error)
     {
         [self.delegate didRecieveResponceFailure:error];
     }];
}

@end
