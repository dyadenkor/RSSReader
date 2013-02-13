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
    
    [[self dataSource] setArray:[RRCoreDataSupport fetchData:SiteInfoEntityName]];
    
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

#pragma mark - UIStoryboardSegue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"RRALLNEWSVC_TO_RRWEBVIEWVC"])
    {
        NSIndexPath *indexPath = [[self tableView] indexPathForCell:sender];
        SiteInfo *site = [[self dataSource] objectAtIndex:[indexPath section]];
        NSMutableArray *arrayFromNSSet = [NSMutableArray arrayWithArray:[[site siteNews] allObjects]];
        SiteContent *news = [arrayFromNSSet objectAtIndex:[indexPath row]];
        
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
    [[self dataSource] setArray:[RRCoreDataSupport fetchData:SiteInfoEntityName]];
    [[self tableView] reloadData];
}

#pragma mark - Buttons Actions

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

- (IBAction)favouriteButtonAction:(id)sender
{
    SiteContent *news = [self detectNewsFromButton:(UIButton *)sender];
    
    for (FavouriteNewsInfo *item in [RRCoreDataSupport fetchData:FavouriteNewsInfoEntityName])
    {
        if ([[item newsTitle] isEqualToString:[news newsTitle]])
        {
            return;
        }
    }
    
    FavouriteNewsInfo *newItem = [NSEntityDescription insertNewObjectForEntityForName:FavouriteNewsInfoEntityName
                                                 inManagedObjectContext:[RRManagedObjectContext sharedManagedObjectContext]];
   
    [newItem setNewsDescription:[news newsContent]];
    [newItem setNewsTitle:[news newsTitle]];
    [newItem setNewslink:[news newsLink]];
    
    [RRCoreDataSupport saveManagedObjectContext];
}

- (IBAction)saveButtonAction:(id)sender
{
    SiteContent *news = [self detectNewsFromButton:(UIButton *)sender];
    
    for (SavedNews *item in [RRCoreDataSupport fetchData:SavedNewsEntityName])
    {
        if ([[item newsTitle] isEqualToString:[news newsTitle]])
        {
            return;
        }
    }
    
    SavedNews *newItem = [NSEntityDescription insertNewObjectForEntityForName:SavedNewsEntityName
                                                       inManagedObjectContext:[RRManagedObjectContext sharedManagedObjectContext]];
    [newItem setNewsDescription:[news newsContent]];
    [newItem setNewsTitle:[news newsTitle]];
    [newItem setNewsContent:[NSData dataWithContentsOfURL:[NSURL URLWithString:[news newsLink]]]];
    [newItem setNewsLink:[news newsLink]];
    
    [RRCoreDataSupport saveManagedObjectContext];
   
}

#pragma mark - Private methods

- (SiteContent *)detectNewsFromButton:(UIButton *)theTouchButton
{
    RRAllNewsCell *cell = (RRAllNewsCell *)[[theTouchButton superview] superview];
    NSIndexPath *indexPath = [[self tableView] indexPathForCell:cell];
    
    SiteInfo *site = [[self dataSource] objectAtIndex:[indexPath section]];
    NSMutableArray *arrayFromNSSet = [NSMutableArray arrayWithArray:[[site siteNews] allObjects]];
    SiteContent *news = [arrayFromNSSet objectAtIndex:[indexPath row]];
    
    return news;
}

@end
