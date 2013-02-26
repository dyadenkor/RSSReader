//
//  RRNavigationController.m
//  RSSReader
//
//  Created by admin on 2/26/13.
//  Copyright (c) 2013 Roman Dyadenko. All rights reserved.
//

#import "RRNavigationController.h"

@interface RRNavigationController ()

@end

@implementation RRNavigationController

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return [[self visibleViewController] shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}

- (BOOL)shouldAutorotate
{
    return [[self visibleViewController] shouldAutorotate];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return [[self visibleViewController] supportedInterfaceOrientations];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
