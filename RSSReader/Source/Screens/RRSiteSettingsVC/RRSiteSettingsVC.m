//
//  RRSiteSettingsVC.m
//  RSSReader
//
//  Created by admin on 2/21/13.
//  Copyright (c) 2013 Roman Dyadenko. All rights reserved.
//

#import "RRSiteSettingsVC.h"

@interface RRSiteSettingsVC ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic) NSArray *dataSource;

@end

@implementation RRSiteSettingsVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.dataSource = [[NSArray alloc] init];
    [self initDataSource];
    
    [[self navigationItem] setTitle:[[[self dataSource] lastObject] title]];
    
    [[self titleLabel] setText:[[[self dataSource] lastObject] siteUrl]];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTitleLabel:nil];
    [super viewDidUnload];
}

#pragma mark - Private methods

- (void)initDataSource
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:SiteInfoEntityName
                                              inManagedObjectContext:[RRManagedObjectContext sharedManagedObjectContext]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(sitePosition == %@)",[self sitePosition]];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    
    [self setDataSource:[[RRManagedObjectContext sharedManagedObjectContext] executeFetchRequest:request
                                                                                           error:&error]];
    if (error)
    {
        assert(0);
    }
}

@end
