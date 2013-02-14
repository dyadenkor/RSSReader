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

@end

@implementation RRWebViewVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect frame = CGRectMake(0, 0, [[self view] frame].size.width, [[self view] frame].size.height);
    
    UIWebView *webView = [[UIWebView alloc]initWithFrame:frame];
    NSURL *url = [NSURL URLWithString:[self url]];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    if ([self siteData])
    {
        [webView loadData:[self siteData]
                 MIMEType:@"text/html"
         textEncodingName:@"UTF-8"
                  baseURL:nil];
    }
    else
    {
        [webView loadRequest:requestObj];
    }
    
    [[self view] addSubview:webView];
    
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

- (IBAction)backButtonAction:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

@end
