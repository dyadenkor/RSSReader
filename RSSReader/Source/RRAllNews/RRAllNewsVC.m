//
//  RRAllNewsVC.m
//  RSSReader
//
//  Created by admin on 1/11/13.
//  Copyright (c) 2013 Roman Dyadenko. All rights reserved.
//

#import "RRAllNewsVC.h"
#import "RRFeedObjectMapping.h"
#import "RRRootResponseObjectMapping.h"
#import "RRNewDetailObjectMapping.h"
#import "RRAllNewsDataSource.h"

@interface RRAllNewsVC ()

@property (nonatomic, strong) RRServerGateway *serverGateWay;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation RRAllNewsVC
@synthesize serverGateWay;
@synthesize dataSource;
@synthesize tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    serverGateWay = [[RRServerGateway alloc] init];
    
    [serverGateWay setBaseURL:@"feeds.bbci.co.uk/news/rss.xml"];
    
    [serverGateWay sendData];
    
    [serverGateWay setBaseURL:@"lenta.ru/rss"];
    
    [serverGateWay sendData];
    
    [serverGateWay setDelegate:self];
    
    dataSource = [[NSMutableArray alloc] init];
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}

#pragma mark UITableview

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self dataSource] count];;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[[self dataSource] objectAtIndex:section] siteNews]count];
}

- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [theTableView dequeueReusableCellWithIdentifier:@"AllNewsVCCellIdentifier"];
    
    [[cell textLabel] setText:[[[[self dataSource] objectAtIndex:[indexPath section]] siteNews]objectAtIndex:[indexPath row]]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

#pragma mark RRServerGatewayDelegate

- (void) didRecieveResponceFailure:(NSError *)error
{
    NSLog(@"Error   -----   %@",error);
}

- (void) didRecieveResponceSucces:(RKMappingResult *)mappingResult
{
    RRRootResponseObjectMapping *site = [mappingResult firstObject];
    
    RRSiteInfoObjectMapping *siteInfo = [[[site responseData] lastObject] siteInfo];
    
    
    RRAllNewsDataSource *siteDataSource = [[RRAllNewsDataSource alloc] init];
    
    [siteDataSource setSiteName:[siteInfo title]];
     
     for (RRNewDetailObjectMapping *element in [siteInfo entries])
     {
         [[siteDataSource siteNews] addObject:[element title]];
     }
    
    [[self dataSource] addObject:siteDataSource];
     
    [[self tableView] reloadData];
}


@end
