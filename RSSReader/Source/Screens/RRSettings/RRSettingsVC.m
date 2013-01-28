//
//  RRSettingsVC.m
//  RSSReader
//
//  Created by admin on 1/11/13.
//  Copyright (c) 2013 Roman Dyadenko. All rights reserved.
//

#import "RRSettingsVC.h"

@interface RRSettingsVC ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation RRSettingsVC
@synthesize tableView;
@synthesize dataSource;

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
    
    [self fetchData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
    UITableViewCell *cell = [theTableView dequeueReusableCellWithIdentifier:SettingCellIdentyfier];
    
    SiteLink *item = [[self dataSource] objectAtIndex:[indexPath row]];

    [[cell textLabel] setText:[item link]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
                                            forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        SiteLink *deleteLink = [[self dataSource] objectAtIndex:[indexPath row]];
        NSManagedObjectContext *context = [RRManagedObjectContext sharedManagedObjectContext];
        [context deleteObject:deleteLink];
        
        [self saveManagedObjectContext];
        
        [[self dataSource] removeObjectAtIndex:indexPath.row];
        [[self tableView] reloadData];
    }
}

#pragma mark - NavigationItemsAction

- (IBAction)addButtonAction:(id)sender
{
    UITextField *alertTextField = [[UITextField alloc] init];
    [alertTextField setText:@"http://"];
    
    RRAlertViewBlock *alert = [[RRAlertViewBlock alloc] initWithTitle:@"Add url"
                                                              message:nil
                                                            textfield:alertTextField
                                                           completion:^(BOOL cancelled, NSInteger buttonIndex, NSString *text)
    {
        if (!cancelled)
        {
            SiteLink *siteLink = [NSEntityDescription insertNewObjectForEntityForName:SiteLinkEntityName
                                                               inManagedObjectContext:[RRManagedObjectContext sharedManagedObjectContext]];

            [siteLink setLink:text];
            
            [[self dataSource] addObject:siteLink];
            [[self tableView] reloadData];
            
            [self saveManagedObjectContext];
        }
    }
                                                    cancelButtonTitle:@"Cancel"
                                                    otherButtonTitles:@"OK", nil];
    
    [alert show];
}

#pragma mark - Private methods

- (void)fetchData
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:SiteLinkEntityName
                                              inManagedObjectContext:[RRManagedObjectContext sharedManagedObjectContext]];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
        
    NSError *error = nil;
    
    [[self dataSource] addObjectsFromArray:[[RRManagedObjectContext sharedManagedObjectContext] executeFetchRequest:request
                                                                                                              error:&error]];
    
    if (error)
    {
        assert(error);
    }
    
}

- (NSError *)saveManagedObjectContext
{
    NSError *error = nil;
    
    if ([[RRManagedObjectContext sharedManagedObjectContext] save:&error])
    {
        NSLog(@"error = %@", [error description]);
        
        return error;
    }
    
    return error;
}

@end
