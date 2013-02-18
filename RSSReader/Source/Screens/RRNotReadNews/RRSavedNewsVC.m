//
//  RRNotReadNewsVC.m
//  RSSReader
//
//  Created by admin on 1/11/13.
//  Copyright (c) 2013 Roman Dyadenko. All rights reserved.
//

#import "RRSavedNewsVC.h"

@interface RRSavedNewsVC ()
@property (nonatomic) NSMutableArray *dataSource;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation RRSavedNewsVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dataSource = [[NSMutableArray alloc] init];
	// Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[self dataSource] setArray:[RRCoreDataSupport fetchData:SavedNewsEntityName]];
    
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
    RRAllNewsCell *cell = [theTableView dequeueReusableCellWithIdentifier:SavedNewsVCCellIdentifier];
    
    SavedNews *news = [[self dataSource] objectAtIndex:[indexPath row]];

    [[cell description] setText:[news newsDescription]];
    [[cell title] setText:[news newsTitle]];
    
    [[cell saveButton] setTag:[indexPath row]];
    
    return cell;
}

#pragma mark - UIStoryboardSegue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"RRSAVEDNEWSVC_TO_RRWEBVIEWVC"])
    {
        NSIndexPath *indexPath = [[self tableView] indexPathForCell:sender];
        SavedNews *news = [[self dataSource] objectAtIndex:[indexPath row]];
        
        RRWebViewVC *vc = [segue destinationViewController];
        [vc setSiteData:[news newsContent]];
    }
}

#pragma mark - Buttons Actions

- (IBAction)deleteButtonAction:(id)sender
{
    SavedNews *deleteNews = [[self dataSource] objectAtIndex:[sender tag]];
    NSManagedObjectContext *context = [RRManagedObjectContext sharedManagedObjectContext];
    [context deleteObject:deleteNews];
    
    [RRCoreDataSupport saveManagedObjectContext];
    
    [[self dataSource] removeObjectAtIndex:[sender tag]];
    [[self tableView] reloadData];
}

- (IBAction)faouriteButtonAction:(id)sender
{
    SavedNews *news = [[self dataSource] objectAtIndex:[sender tag]];
    
    for (FavouriteNewsInfo *item in [RRCoreDataSupport fetchData:FavouriteNewsInfoEntityName])
    {
        if ([[item newsTitle] isEqualToString:[news newsTitle]])
        {
            return;
        }
    }
    
    FavouriteNewsInfo *newItem = [NSEntityDescription insertNewObjectForEntityForName:FavouriteNewsInfoEntityName
                                                               inManagedObjectContext:[RRManagedObjectContext sharedManagedObjectContext]];
    
    [newItem setNewsDescription:[news newsDescription]];
    [newItem setNewsTitle:[news newsTitle]];
    [newItem setNewslink:[news newsLink]];
    
    [RRCoreDataSupport saveManagedObjectContext];
}

@end
