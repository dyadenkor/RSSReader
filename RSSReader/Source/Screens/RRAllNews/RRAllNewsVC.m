//
//  RRAllNewsVC.m
//  RSSReader
//
//  Created by admin on 1/11/13.
//  Copyright (c) 2013 Roman Dyadenko. All rights reserved.
//

#import "RRAllNewsVC.h"

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

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil
                           bundle:nibBundleOrNil];
    if (self){}
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    dataSource = [[NSMutableArray alloc] init];
    links = [[NSMutableArray alloc] init];
    serverGateWay = [[RRServerGateway alloc] init];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[self dataSource] removeAllObjects];
    [[self tableView] reloadData];
    
    [[self links] removeAllObjects];
    [[self links] setArray:[self fetchData:SiteLinkEntityName]];
    
    if ([[self links] count])
    {
        [self loadNews];
    }
    else
    {
        RRAlertViewBlock *alert = [[RRAlertViewBlock alloc] initWithTitle:@"No links in settings"
                                                                  message:@"Please add them in Settings"
                                                                textfield:nil
                                                               completion:^(BOOL cancelled, NSInteger buttonIndex, NSString *text)
                                   {
                                       [[self tabBarController] setSelectedIndex:3];
                                   }
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles:nil, nil];
        
        [alert show];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{
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
    
    RRAllNewsDataSourceItem *site = [[self dataSource] objectAtIndex:[indexPath section]];
    SiteContent *news = [[site siteNews] objectAtIndex:[indexPath row]];
    
    [[cell description] setText:[news newsContent]];
    [[cell title] setText:[news newsTitle]];
    
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
    NSMutableArray *arrayOfLinks = [[NSMutableArray alloc] init];
    
    [arrayOfLinks setArray:[self fetchData:SiteInfoEntityName]];
   
    for (SiteInfo *site in arrayOfLinks)
    {
        RRAllNewsDataSourceItem *item = [[RRAllNewsDataSourceItem alloc] init];
        [item setSiteName:[site title]];
        
        [item setSiteNews:[self fetchData:SiteContentEntityName]];
        
        [[self dataSource] addObject:item];
    }
    
    [[self tableView] reloadData];
}

#pragma mark Private methods

- (void)loadNews
{
    for (SiteLink *item in [self links])
    {
        [serverGateWay setBaseURL:[item link]];
    
        [serverGateWay sendData];
    }
    
    [serverGateWay setDelegate:self];
}

- (NSMutableArray *)fetchData:(NSString *)entityName
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName
                                              inManagedObjectContext:[RRManagedObjectContext sharedManagedObjectContext]];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    NSError *error = nil;
    
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    [resultArray addObjectsFromArray:[[RRManagedObjectContext sharedManagedObjectContext] executeFetchRequest:request
                                                                                                        error:&error]];
  
    if (error)
    {
       assert(error);
    }
    
    return resultArray;
}

@end
