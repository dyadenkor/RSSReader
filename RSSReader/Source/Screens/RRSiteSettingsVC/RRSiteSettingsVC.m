//
//  RRSiteSettingsVC.m
//  RSSReader
//
//  Created by admin on 2/21/13.
//  Copyright (c) 2013 Roman Dyadenko. All rights reserved.
//

#import "RRSiteSettingsVC.h"
#import "RRAppDelegate.h"

@interface RRSiteSettingsVC ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic) NSArray *dataSource;
@property (weak, nonatomic) IBOutlet UISwitch *siteLoadNewsSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *unreadNewsSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *autoRefreshSwitch;
@property (weak, nonatomic) IBOutlet UIView *autorefreshTimeView;
@property (weak, nonatomic) IBOutlet UITextField *numberOfNewsTextField;
@property (weak, nonatomic) IBOutlet UITextField *autorefreshingTimeHRTextField;
@property (nonatomic) UIButton *returnButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic) RRRefreshNews *refreshNews;

@end

@implementation RRSiteSettingsVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[self autorefreshTimeView] setBackgroundColor:[UIColor clearColor]];
    
    self.refreshNews = [[RRRefreshNews alloc] init];
   
    self.dataSource = [[NSArray alloc] init];
    [self initDataSource];
    
    [[self navigationItem] setTitle:[[[self dataSource] lastObject] title]];
    [[self titleLabel] setText:[[[self dataSource] lastObject] siteUrl]];
    
    if ([[[[self dataSource] lastObject] autoRefreshTime] integerValue] == 0)
    {
        [[[self dataSource] lastObject] setAutoRefreshTime:[NSNumber numberWithInteger:4]];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    // UISwitches
    [self initSwitches];
    
    // textFields
    [self initTextFields];
    
    // returnButton
    self.returnButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [[self returnButton] setFrame:CGRectMake(0, 568, 106, 53)];
    
    // UIScrollView
    [[self scrollView] setScrollEnabled:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [self setTitleLabel:nil];
    [self setSiteLoadNewsSwitch:nil];
    [self setUnreadNewsSwitch:nil];
    [self setAutoRefreshSwitch:nil];
    [self setAutorefreshTimeView:nil];
    [self setNumberOfNewsTextField:nil];
    [self setAutorefreshingTimeHRTextField:nil];
    [self setScrollView:nil];
    
    [super viewDidUnload];
}

#pragma mark - Rotation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return interfaceOrientation == UIInterfaceOrientationPortrait;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationPortrait|UIInterfaceOrientationPortraitUpsideDown;
}

- (BOOL)shouldAutorotate
{
    return YES;
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
}

- (void)initSwitches
{
    [[self siteLoadNewsSwitch] setOn:![[[[self dataSource] lastObject] needOffNews] boolValue]];
    [[self unreadNewsSwitch] setOn:[[[[self dataSource] lastObject] isShowOnlyUnreadNews] boolValue]];
    [[self autoRefreshSwitch] setOn:[[[[self dataSource] lastObject] isAutoRefresh] boolValue]];
    [[self autorefreshTimeView] setHidden:![[[[self dataSource] lastObject] isAutoRefresh] boolValue]];
}

- (void)initTextFields
{
    [[self numberOfNewsTextField] setDelegate:self];
    [[self autorefreshingTimeHRTextField] setDelegate:self];
    
    [[self autorefreshingTimeHRTextField] setText:[NSString stringWithFormat:@"%@",[[[self dataSource] lastObject] autoRefreshTime]]];
    
    if (![[[[self dataSource] lastObject] maxNumbersOfNews] integerValue] == 0)
    {
        [[self numberOfNewsTextField] setText:[NSString stringWithFormat:@"%@",[[[self dataSource] lastObject] maxNumbersOfNews]]];
    }
}

- (void)startAutoRefresh
{
    [NSTimer scheduledTimerWithTimeInterval:[[[[self dataSource] lastObject] autoRefreshTime] intValue] * 3600
                                     target:self
                                   selector:@selector(startUpdatingNews:)
                                   userInfo:[[[self dataSource] lastObject] siteUrl]
                                    repeats:YES];
}

- (void)startUpdatingNews:(id)sender
{
    [sender setTimeoutInterval:[[[[self dataSource] lastObject] autoRefreshTime] intValue] * 3600];
    
    if (![[self refreshNews] startIsOK:(NSString *)[sender userInfo]] ||
        ![[[[self dataSource] lastObject] isAutoRefresh] boolValue])
    {
        [sender invalidate];
    }
}

#pragma mark -
#pragma mark UIKeyBoard

- (void)keyboardWillShow:(NSNotification *)note
{
    NSInteger hight = [[self view] frame].size.height - 33;
    
    [UIView animateWithDuration:0.23
                          delay:0.0
                        options:UIViewAnimationCurveEaseOut
                     animations:^{
                         [[self returnButton] setFrame:CGRectMake(0, hight, 106, 53)];
                     }
                     completion:^(BOOL finished){}];
    
    [[self returnButton] setAdjustsImageWhenHighlighted:NO];
    [[self returnButton] setImage:[UIImage imageNamed:@"ReturnUp.png"] forState:UIControlStateNormal];
    [[self returnButton] setImage:[UIImage imageNamed:@"ReturnDown.png"] forState:UIControlStateHighlighted];
    [[self returnButton] addTarget:self action:@selector(hideKeyboard) forControlEvents:UIControlEventTouchUpInside];
    
    UIWindow *frontWindow = [[[UIApplication sharedApplication] windows] lastObject];
    [frontWindow addSubview:[self returnButton]];
}

#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField
{
    [theTextField resignFirstResponder];
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)theTextField
{
    BOOL isHightScreen = [[UIScreen mainScreen] bounds].size.height > 567.0f;
    
    if ([theTextField isEqual:[self autorefreshingTimeHRTextField]] &&
        !isHightScreen)
    {
        [[self scrollView] setContentOffset:CGPointMake(0, 65) animated:YES];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)theTextField
{
    if ([theTextField isEqual:[self numberOfNewsTextField]])
    {
        [[[self dataSource] lastObject] setMaxNumbersOfNews:[NSNumber numberWithInteger: [[theTextField text] integerValue]]];
    }
    else if ([theTextField isEqual:[self autorefreshingTimeHRTextField]])
    {
        [[self scrollView] setContentOffset:CGPointMake(0, 0) animated:YES];
        
        NSNumber *hr = [NSNumber numberWithInteger: [[theTextField text] integerValue]];
       
        if ([[theTextField text] isEqualToString:@""])
        {
            hr = [NSNumber numberWithInteger: 4];
        }
                
        [[[self dataSource] lastObject] setAutoRefreshTime:hr];
        
        [self startAutoRefresh];
    }
    
    [RRCoreDataSupport saveManagedObjectContext];
}

- (BOOL)textField:(UITextField *)theTextField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string
{
    if (range.location == 2 &&
        [string isEqual:@""])
    {
        [[self numberOfNewsTextField] setText:@""];
    }
    
    if (range.location == 0 &&
        [string isEqual:@"0"])
    {
        return NO;
    }
    
    if (range.location > 1)
    {
        return NO;
    }
    
    return  YES;
}

#pragma mark -
#pragma mark HTPDRKeyboardProtocol

- (void)hideKeyboard
{
    [[self numberOfNewsTextField] resignFirstResponder];
    [[self autorefreshingTimeHRTextField] resignFirstResponder];
    
    [[self returnButton] setFrame:CGRectMake(0, 568, 106, 53)];
}

#pragma mark - IBActions

- (IBAction)siteLoadNewsSwitcAction:(id)sender
{
    [[[self dataSource] lastObject] setNeedOffNews:[NSNumber numberWithBool:![self siteLoadNewsSwitch].on]];
    [RRCoreDataSupport saveManagedObjectContext];
}

- (IBAction)unreadNewsSwitchAction:(id)sender
{
    [[[self dataSource] lastObject] setIsShowOnlyUnreadNews:[NSNumber numberWithBool:[self unreadNewsSwitch].on]];
    [RRCoreDataSupport saveManagedObjectContext];
}

- (IBAction)autoRefreshSwitchAction:(id)sender
{
    [[[self dataSource] lastObject] setIsAutoRefresh:[NSNumber numberWithBool:[self autoRefreshSwitch].on]];
    
    [RRCoreDataSupport saveManagedObjectContext];
    
    if ([self autoRefreshSwitch].on)
    {
        [self startAutoRefresh];
    }
    
    [[self autorefreshTimeView] setHidden:![self autoRefreshSwitch].on];
}

- (IBAction)allButtonAction:(id)sender
{
    [[self numberOfNewsTextField] setText:@"All"];
    [[[self dataSource] lastObject] setMaxNumbersOfNews:[NSNumber numberWithInteger: 0]];
    [RRCoreDataSupport saveManagedObjectContext];
}

- (IBAction)backButtonAction:(id)sender
{
    [self hideKeyboard];
    [self setReturnButton:nil];
    [self dismissModalViewControllerAnimated:YES];
}

@end
