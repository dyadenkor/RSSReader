//
//  RRServerGateway.m
//  RSSReader
//
//  Created by admin on 1/15/13.
//  Copyright (c) 2013 Roman Dyadenko. All rights reserved.
//

#import "RRServerGateway.h"
#import "RestKit.h"

@implementation RRServerGateway

- (void)sendData
{
    NSURL *url = [NSURL URLWithString:@"http://lenta.ru/rss"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"%@", JSON);
    } failure:nil];
    [operation start];
}

@end
