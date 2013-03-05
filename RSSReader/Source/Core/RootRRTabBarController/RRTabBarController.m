//
//  RRTabBarController.m
//  RSSReader
//
//  Created by admin on 2/26/13.
//  Copyright (c) 2013 Roman Dyadenko. All rights reserved.
//

#import "RRTabBarController.h"

@interface RRTabBarController ()
@property (nonatomic) RRRefreshNews *refreshNews;
@end

@implementation RRTabBarController

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return [[self selectedViewController] shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (BOOL)shouldAutorotate
{
    return [[self selectedViewController] shouldAutorotate];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.refreshNews = [[RRRefreshNews alloc] init];
    
    NSArray *sites = [[NSArray alloc] initWithArray:[RRCoreDataSupport fetchData:SiteInfoEntityName]];
    
    for (SiteInfo *site in sites)
    {
        if ([[site isAutoRefresh] boolValue])
        {
                [NSTimer scheduledTimerWithTimeInterval:[[site autoRefreshTime] intValue] * 3600
                                                 target:self
                                               selector:@selector(startUpdatingNews:)
                                               userInfo:[site siteUrl]
                                                repeats:YES];
        }
    }
}

- (void)startUpdatingNews:(id)sender
{
    if (![[self refreshNews] startIsOK:(NSString *)[sender userInfo]])
    {
        [sender invalidate];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
