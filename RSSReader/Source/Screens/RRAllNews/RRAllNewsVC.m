//
//  RRAllNewsVC.m
//  RSSReader
//
//  Created by admin on 1/11/13.
//  Copyright (c) 2013 Roman Dyadenko. All rights reserved.
//

#import "RRAllNewsVC.h"

@interface RRAllNewsVC ()

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) RRServerGateway *serverGateWay;

@end

@implementation RRAllNewsVC

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
    
    self.dataSource = [[NSMutableArray alloc] init];
    self.serverGateWay = [[RRServerGateway alloc] init];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[self dataSource] setArray:[self fetchData:SiteInfoEntityName]];
    
    if ([[self dataSource] count])
    {
        [[self tableView] reloadData];
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

#pragma mark - UITableview

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self dataSource] count];;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    SiteInfo *item = [[self dataSource] objectAtIndex:section];
    NSLog(@"%i",[[item siteNews] count]);
    return [[[[self dataSource] objectAtIndex:section] siteNews] count];
}

- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RRAllNewsCell *cell = [theTableView dequeueReusableCellWithIdentifier:AllNewsVCCellIdentifier];
    
    SiteInfo *site = [[self dataSource] objectAtIndex:[indexPath section]];
    NSMutableArray *arrayFromNSSet = [NSMutableArray arrayWithArray:[[site siteNews] allObjects]];
    SiteContent *news = [arrayFromNSSet objectAtIndex:[indexPath row]];
    
    [[cell description] setText:[news newsContent]];
    [[cell title] setText:[news newsTitle]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    SiteInfo *item = [[self dataSource] objectAtIndex:section];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[self view] frame].size.width , 30.0)];
    [headerView setBackgroundColor:[UIColor colorWithRed:163/255 green:169/255 blue:171/255 alpha:1]];
    [headerView setAlpha:0.6];
    
    UIButton *refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [refreshButton setFrame:CGRectMake([[self view] frame].size.width - 40, 0, 30.0, 30.0)];
    [refreshButton setTag:section];
    [refreshButton setImage:[UIImage imageNamed: @"refreshButton.png"] forState:UIControlStateNormal];
    [refreshButton addTarget:self
                      action:@selector(refreshButtonPressed:)
            forControlEvents:UIControlEventTouchDown];
    
    [headerView addSubview:refreshButton];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, [[self view] frame].size.width  - 50, 30.0)];
    [titleLabel setText:[item title]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    
    [headerView addSubview:titleLabel];
    
    return headerView;
}

#pragma mark - RRServerGatewayDelegate

- (void)didRecieveResponceFailure:(NSError *)error
{
    NSLog(@"Error   -----   %@",error);
}

- (void)didRecieveResponceSucces:(RKMappingResult *)mappingResult
{
    [[self dataSource] setArray:[self fetchData:SiteInfoEntityName]];
    [[self tableView] reloadData];
}

#pragma mark - Private methods

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

- (void)refreshButtonPressed:(id)sender
{
    NSString *url = [[[self dataSource] objectAtIndex:[sender tag]] siteUrl];
    
    SiteInfo *deleteSite = [[self dataSource] objectAtIndex:[sender tag]];
    NSManagedObjectContext *context = [RRManagedObjectContext sharedManagedObjectContext];
    [context deleteObject:deleteSite];
    
    [RRCoreDataSupport saveManagedObjectContext];
    
    [[self serverGateWay] sendData:url];
    [[self serverGateWay] setDelegate:self];
}

@end
