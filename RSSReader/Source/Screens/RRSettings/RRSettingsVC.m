//
//  RRSettingsVC.m
//  RSSReader
//
//  Created by admin on 1/11/13.
//  Copyright (c) 2013 Roman Dyadenko. All rights reserved.
//

#import "RRSettingsVC.h"
#import "RRAlertViewBlock.h"

@interface RRSettingsVC ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation RRSettingsVC
@synthesize tableView;
@synthesize dataSource;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    dataSource = [[NSMutableArray alloc] init];
    
    NSString *someUrl = @"http://lenta.ru/rss";
    ///NSString *someUrl2 = @"http://lenta.ru/rss";
   // NSString *someUrl3 = @"http://lenta.ru/rss";
    //NSString *someUrl4 = @"http://lenta.ru/rss";
    
    [[self dataSource] addObject:someUrl];
     //[[self dataSource] addObject:someUrl2];
    // [[self dataSource] addObject:someUrl3];
     //[[self dataSource] addObject:someUrl4];
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark UITableview

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self dataSource ] count];
}

- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [theTableView dequeueReusableCellWithIdentifier:@"SettingCellIdentyfier"];

    [[cell textLabel] setText:[[self dataSource] objectAtIndex:[indexPath row]]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
                                            forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [[self dataSource] removeObjectAtIndex:indexPath.row];
        [[self tableView] reloadData];
    }
}


#pragma mark NavigationItemsAction

- (IBAction)addButtonAction:(id)sender
{
    RRAlertViewBlock *alert = [[RRAlertViewBlock alloc] initWithTitle:@"Add url" message:@"http://" textfield:YES completion:^(BOOL cancelled, NSInteger buttonIndex, NSString *text)
    {
        if (!cancelled)
        {
            NSMutableString *newUrl = [[NSMutableString alloc] init];
            [newUrl appendString:@"http://"];
            [newUrl appendString:text];
            [[self dataSource] addObject:newUrl];
            
            [[self tableView] reloadData];
        }
    }
        cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    
    [alert show];
}

@end
