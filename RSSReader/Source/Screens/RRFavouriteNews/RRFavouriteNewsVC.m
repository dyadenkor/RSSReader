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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dataSource = [[NSMutableArray alloc] init];
	// Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
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

#pragma mark - Rotation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (BOOL)shouldAutorotate
{
    return YES;
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
    [[cell saveButton] setTag:[indexPath row]];
    
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

- (IBAction)saveButtonAction:(id)sender
{
    FavouriteNewsInfo *news = [[self dataSource] objectAtIndex:[sender tag]];
    
    for (SavedNews *item in [RRCoreDataSupport fetchData:SavedNewsEntityName])
    {
        if ([[item newsTitle] isEqualToString:[news newsTitle]])
        {
            return;
        }
    }
    
    SavedNews *newItem = [NSEntityDescription insertNewObjectForEntityForName:SavedNewsEntityName
                                                       inManagedObjectContext:[RRManagedObjectContext sharedManagedObjectContext]];
    [newItem setNewsDescription:[news newsDescription]];
    [newItem setNewsTitle:[news newsTitle]];
    [newItem setNewsContent:[NSData dataWithContentsOfURL:[NSURL URLWithString:[news newslink]]]];
    [newItem setNewsLink:[news newslink]];
    
    [RRCoreDataSupport saveManagedObjectContext];
}

@end
