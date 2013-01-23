//
//  RRAllNewsVC.m
//  RSSReader
//
//  Created by admin on 1/11/13.
//  Copyright (c) 2013 Roman Dyadenko. All rights reserved.
//

#import "RRAllNewsVC.h"

NSString * const AllNewsVCCellIdentifier = @"AllNewsVCCellIdentifier";

@interface RRAllNewsVC ()

@property (nonatomic, strong) RRServerGateway *serverGateWay;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *links;

@end

@implementation RRAllNewsVC
@synthesize serverGateWay;
@synthesize dataSource;
@synthesize tableView;
@synthesize links;

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
    
    dataSource = [[NSMutableArray alloc] init];
    links = [[NSMutableArray alloc] init];
	// Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[self dataSource] removeAllObjects];
    [[self tableView] reloadData];
    
    [self fetchData];
    
    if ([[self links] count])
    {
        [self loadNews];
    }
    else
    {
        //[[self tabBarController] setSelectedIndex:3];
    }
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
    return [[[[self dataSource] objectAtIndex:section] siteNews] count];
}

- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RRAllNewsCell *cell = [theTableView dequeueReusableCellWithIdentifier:AllNewsVCCellIdentifier];
    
    RRNewDetailObjectMapping *element = [[[[self dataSource] objectAtIndex:[indexPath section]] siteNews]objectAtIndex:[indexPath row]];
    
    [[cell title] setText:[element title]];
    
    [[cell description] setText:[element content]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[[self dataSource] objectAtIndex:section] siteName];
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
    RRAllNewsDataSourceItem *siteDataSource = [[RRAllNewsDataSourceItem alloc] init];
    
    [siteDataSource setSiteName:[siteInfo title]];
     
    for (RRNewDetailObjectMapping *element in [siteInfo entries])
    {
        [[siteDataSource siteNews] addObject:element];
    }
    
    if ([[siteDataSource siteNews] count])
    {
        [[self dataSource] addObject:siteDataSource];
    }
    
    [[self tableView] reloadData];
}

#pragma mark Private methods

- (void)loadNews
{
    serverGateWay = [[RRServerGateway alloc] init];
    
    for (SiteLink *item in [self links])
    {
        [serverGateWay setBaseURL:[item link]];
    
        [serverGateWay sendData];
    }
    
    [serverGateWay setDelegate:self];
}

- (void)fetchData
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:SiteLinkEntityName
                                              inManagedObjectContext:[RRManagedObjectContext sharedManagedObjectContext]];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    NSError *error = nil;
    
    [[self links] removeAllObjects];
    [[self links] addObjectsFromArray:[[RRManagedObjectContext sharedManagedObjectContext] executeFetchRequest:request
                                                                                                         error:&error]];
    
    if (error)
    {
        NSLog(@"%s: error:%@", __PRETTY_FUNCTION__, [error description]);
    }
    
}

@end
