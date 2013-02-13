//
//  RRFavouriteNewsVC.m
//  RSSReader
//
//  Created by admin on 1/11/13.
//  Copyright (c) 2013 Roman Dyadenko. All rights reserved.
//

#import "RRFavouriteNewsVC.h"

@interface RRFavouriteNewsVC ()
@property (nonatomic) NSMutableArray *dataSource;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation RRFavouriteNewsVC

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
    
    self.dataSource = [[NSMutableArray alloc] init];
	// Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [[self dataSource] setArray:[RRCoreDataSupport fetchData:FavouriteNewsInfoEntityName]];

    if ([[self dataSource] count])
    {
        [[self tableView] reloadData];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [super viewDidUnload];
}

#pragma mark - UITableview

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self dataSource] count];
}

- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RRAllNewsCell *cell = [theTableView dequeueReusableCellWithIdentifier:FavouriteNewsVCCellIdentifier];
    
    FavouriteNewsInfo *news = [[self dataSource] objectAtIndex:[indexPath row]];
    
    [[cell description] setText:[news newsDescription]];
    [[cell title] setText:[news newsTitle]];
    
    [[cell favouriteButton] setTag:[indexPath row]];
    
    return cell;
}

#pragma mark - UIStoryboardSegue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"RRFAVOURITENEWSVC_TO_RRWEBVIEWVC"])
    {
        NSIndexPath *indexPath = [[self tableView] indexPathForCell:sender];
        FavouriteNewsInfo *news = [[self dataSource] objectAtIndex:[indexPath row]];
        
        RRWebViewVC *vc = [segue destinationViewController];
        [vc setUrl:[news newslink]];
    }
}

#pragma mark - Buttons Actions

- (IBAction)deleteButtonAction:(id)sender
{
    FavouriteNewsInfo *deleteNews = [[self dataSource] objectAtIndex:[sender tag]];
    NSManagedObjectContext *context = [RRManagedObjectContext sharedManagedObjectContext];
    [context deleteObject:deleteNews];
    
    [RRCoreDataSupport saveManagedObjectContext];
    
    [[self dataSource] removeObjectAtIndex:[sender tag]];
    [[self tableView] reloadData];
}

@end
