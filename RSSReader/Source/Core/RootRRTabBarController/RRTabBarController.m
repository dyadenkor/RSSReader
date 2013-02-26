//
//  RRTabBarController.m
//  RSSReader
//
//  Created by admin on 2/26/13.
//  Copyright (c) 2013 Roman Dyadenko. All rights reserved.
//

#import "RRTabBarController.h"

@interface RRTabBarController ()

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
