//
//  RRWebViewVC.m
//  RSSReader
//
//  Created by admin on 2/12/13.
//  Copyright (c) 2013 Roman Dyadenko. All rights reserved.
//

#import "RRWebViewVC.h"

@interface RRWebViewVC ()
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (nonatomic) UIWebView *webView;
@property (nonatomic) CGRect frameForPortrait;
@property (nonatomic) CGRect frameForLandScape;

@end

@implementation RRWebViewVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setFrameForPortrait:CGRectMake(0, 0, [[self view] frame].size.width, [[self view] frame].size.height)];
    [self setFrameForLandScape:CGRectMake(0, 0, [[self view] frame].size.height, [[self view] frame].size.width)];
    
    self.webView = [[UIWebView alloc]initWithFrame:[self frameForPortrait]];
    NSURL *url = [NSURL URLWithString:[self url]];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    if ([self siteData])
    {
        [[self webView] loadData:[self siteData]
                 MIMEType:@"text/html"
         textEncodingName:@"UTF-8"
                  baseURL:nil];
    }
    else
    {
        [[self webView] loadRequest:requestObj];
    }
    
    [[self view] addSubview:[self webView]];
    
    [[self view] addSubview:[self backButton]];
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setBackButton:nil];
    [super viewDidUnload];
}

#pragma mark - Rotation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
        interfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        [[self webView] setFrame:[self frameForLandScape]];
    }
    else
    {
        [[self webView] setFrame:[self frameForPortrait]];
    }
    
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (BOOL)shouldAutorotate
{
    if ([[UIDevice currentDevice] orientation] == UIInterfaceOrientationLandscapeLeft ||
        [[UIDevice currentDevice] orientation] == UIInterfaceOrientationLandscapeRight)
    {
        [[self webView] setFrame:[self frameForLandScape]];
    }
    else
    {
        [[self webView] setFrame:[self frameForPortrait]];
    }
    
    return YES;
}

#pragma mark - UIButtonActions

- (IBAction)backButtonAction:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

@end
