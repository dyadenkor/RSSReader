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
@property (nonatomic, strong) NSMutableArray *sites;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) RRServerGateway *serverGateWay;

@end

@implementation RRAllNewsVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dataSource = [[NSMutableArray alloc] init];
    self.serverGateWay = [[RRServerGateway alloc] init];
    self.sites = [[NSMutableArray alloc] init];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[self sites] setArray:[RRCoreDataSupport fetchData:SiteInfoEntityName]];
    
    [[self dataSource] removeAllObjects];
    
    [self initDataSource];
    
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
    return [[self dataSource] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[[self dataSource] objectAtIndex:section] siteNews] count];
}

- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RRAllNewsCell *cell = [theTableView dequeueReusableCellWithIdentifier:AllNewsVCCellIdentifier];
    
    RRAllNewsDataSourceItem *item = [[self dataSource] objectAtIndex:[indexPath section]];
    SiteContent *news = [[item siteNews] objectAtIndex:[indexPath row]];
    
    if ([news isRead])
    {
        [[cell notReadImageView] setHidden:YES];
        [[cell notReadButton] setHidden:YES];
    }
    
    if ([news isFavourite])
    {
        [[cell favouriteButton] setHidden:YES];
    }
    
    if ([news isSaved])
    {
        [[cell saveButton] setHidden:YES];
    }
    
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
    RRAllNewsDataSourceItem *item = [[self dataSource] objectAtIndex:section];
    
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
    [titleLabel setText:[item siteName]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    
    [headerView addSubview:titleLabel];
    
    return headerView;
}

#pragma mark - UIStoryboardSegue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"RRALLNEWSVC_TO_RRWEBVIEWVC"])
    {
        NSIndexPath *indexPath = [[self tableView] indexPathForCell:sender];
        RRAllNewsDataSourceItem *site = [[self dataSource] objectAtIndex:[indexPath section]];
        SiteContent *news = [[site siteNews] objectAtIndex:[indexPath row]];
        [news setIsRead:[NSNumber numberWithBool:YES]];
        [RRCoreDataSupport saveManagedObjectContext];
        
        RRWebViewVC *vc = [segue destinationViewController];
        [vc setUrl:[news newsLink]];
    }
}

#pragma mark - RRServerGatewayDelegate

- (void)didRecieveResponceFailure:(NSError *)error
{
    NSLog(@"Error   -----   %@",error);
}

- (void)didRecieveResponceSucces:(RKMappingResult *)mappingResult
{
    [[self sites] setArray:[RRCoreDataSupport fetchData:SiteInfoEntityName]];
    [[self dataSource] removeAllObjects];
    [self initDataSource];
}

#pragma mark - Buttons Actions

- (void)refreshButtonPressed:(id)sender
{
    NSString *url = [[[self dataSource] objectAtIndex:[sender tag]] siteURL];
    
    SiteInfo *deleteSite = [[self sites] objectAtIndex:[sender tag]];
    NSManagedObjectContext *context = [RRManagedObjectContext sharedManagedObjectContext];
    [context deleteObject:deleteSite];
    
    [RRCoreDataSupport saveManagedObjectContext];
    
    [[self serverGateWay] sendData:url];
    [[self serverGateWay] setDelegate:self];
}

- (IBAction)favouriteButtonAction:(id)sender
{
    NSIndexPath *indexPath = [self detectIndexPathFromButton:sender];
    SiteContent *news = [self detectNewsFromIndexPath:indexPath];
    [news setIsFavourite:[NSNumber numberWithBool:YES]];
    [news setIsRead:[NSNumber numberWithBool:YES]];
    
    FavouriteNewsInfo *newItem = [NSEntityDescription insertNewObjectForEntityForName:FavouriteNewsInfoEntityName
                                                 inManagedObjectContext:[RRManagedObjectContext sharedManagedObjectContext]];
   
    [newItem setNewsDescription:[news newsContent]];
    [newItem setNewsTitle:[news newsTitle]];
    [newItem setNewslink:[news newsLink]];
    
    [RRCoreDataSupport saveManagedObjectContext];
    
    [[self tableView] reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
}

- (IBAction)saveButtonAction:(id)sender
{
    NSIndexPath *indexPath = [self detectIndexPathFromButton:sender];
    SiteContent *news = [self detectNewsFromIndexPath:indexPath];
    [news setIsSaved:[NSNumber numberWithBool:YES]];
    [news setIsRead:[NSNumber numberWithBool:YES]];
    
    SavedNews *newItem = [NSEntityDescription insertNewObjectForEntityForName:SavedNewsEntityName
                                                       inManagedObjectContext:[RRManagedObjectContext sharedManagedObjectContext]];
    [newItem setNewsDescription:[news newsContent]];
    [newItem setNewsTitle:[news newsTitle]];
    [newItem setNewsContent:[NSData dataWithContentsOfURL:[NSURL URLWithString:[news newsLink]]]];
    [newItem setNewsLink:[news newsLink]];
    
    [RRCoreDataSupport saveManagedObjectContext];
    
    [[self tableView] reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
}

- (IBAction)notReadButtonAction:(id)sender
{
    NSIndexPath *indexPath = [self detectIndexPathFromButton:sender];
    SiteContent *item = [self detectNewsFromIndexPath:indexPath];
    [item setIsRead:[NSNumber numberWithBool:YES]];
    
    [RRCoreDataSupport saveManagedObjectContext];
    
    [[self tableView] reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
}

#pragma mark - Private methods

- (NSIndexPath *)detectIndexPathFromButton:(UIButton *)theTouchButton
{
    RRAllNewsCell *cell = (RRAllNewsCell *)[[theTouchButton superview] superview];
    NSIndexPath *indexPath = [[self tableView] indexPathForCell:cell];
    
    return indexPath;
}

- (SiteContent *)detectNewsFromIndexPath:(NSIndexPath *)indexPath
{
    RRAllNewsDataSourceItem *site = [[self dataSource] objectAtIndex:[indexPath section]];
    SiteContent *news = [[site siteNews] objectAtIndex:[indexPath row]];
    
    return news;
}

- (void)initDataSource
{
    for (SiteInfo *item in [self sites])
    {
        RRAllNewsDataSourceItem *dataSourceItem = [[RRAllNewsDataSourceItem alloc] init];
        [dataSourceItem setSiteName:[item title]];
        [dataSourceItem setSiteURL:[item siteUrl]];
        [dataSourceItem setSiteNews:(NSMutableArray *)[self sortNews:item]];
        
        [[self dataSource] addObject:dataSourceItem];
    }
}

- (NSArray *)sortNews:(SiteInfo *)site
{
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"newsDate" ascending:YES]];
    
    NSArray *sortArray = [[NSArray alloc] init];
    sortArray = [[site siteNews] sortedArrayUsingDescriptors:sortDescriptors];
    sortArray = [[sortArray reverseObjectEnumerator] allObjects];
    
    return sortArray;
}

@end
