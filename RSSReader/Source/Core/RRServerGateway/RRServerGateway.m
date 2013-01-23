//
//  RRServerGateway.m
//  RSSReader
//
//  Created by admin on 1/15/13.
//  Copyright (c) 2013 Roman Dyadenko. All rights reserved.
//

#import "RRServerGateway.h"

@implementation RRServerGateway
@synthesize baseURL;

- (void)sendData
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://ajax.googleapis.com/ajax/services/feed/load?v=1.0&q=%@&num=-1&output=json",baseURL]];

    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"text/javascript"];
    
    RKObjectMapping *requestMapping = [RRRootResponseObjectMapping objectMapping];
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:requestMapping pathPattern:nil keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    RKObjectRequestOperation *objectRequestOperation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[responseDescriptor]];
    
    [objectRequestOperation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult)
    {
        [[self delegate] didRecieveResponceSucces:mappingResult];
    }
    failure:^(RKObjectRequestOperation *operation, NSError *error)
    {
        [[self delegate] didRecieveResponceFailure:error];
    }];
    
    [objectRequestOperation start];

}

@end
