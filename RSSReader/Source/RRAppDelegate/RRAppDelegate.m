//
//  RRAppDelegate.m
//  RSSReader
//
//  Created by admin on 1/11/13.
//  Copyright (c) 2013 Roman Dyadenko. All rights reserved.
//

#import "RRAppDelegate.h"

@implementation RRAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self initRestKitParameters];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{}

- (void)applicationDidEnterBackground:(UIApplication *)application
{}

- (void)applicationWillEnterForeground:(UIApplication *)application
{}

- (void)applicationDidBecomeActive:(UIApplication *)application
{}

- (void)applicationWillTerminate:(UIApplication *)application
{}

- (void)initRestKitParameters
{
    // Setup RestKit
    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class]
                               forMIMEType:@"text/javascript"];
    
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    // object manager
    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:ServerBaseURL]];
    
    // managed object model
    
    NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    // managed object store
    RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];
    objectManager.managedObjectStore = managedObjectStore;
    
    // object mappings
    RKObjectMapping *objectMapping = [RRRootResponseObjectMapping objectMapping];
    [RKObjectMapping addDefaultDateFormatterForString:@"E, d M y H:m:s Z" inTimeZone:nil];
    
    // Register our mappings with the provider
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:objectMapping
                                                                                       pathPattern:nil
                                                                                           keyPath:nil
                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [objectManager addResponseDescriptor:responseDescriptor];
    
    // Complete Core Data stack initialization

    [managedObjectStore createPersistentStoreCoordinator];
    
    NSString *storePath = [RKApplicationDataDirectory() stringByAppendingPathComponent:@"Model.sqlite"];
    
    NSString *seedPath = [NSBundle.mainBundle pathForResource:@"Model"
                                                       ofType:@"sqlite"];
    
    NSError *error = nil;
    NSPersistentStore *persistentStore = [managedObjectStore addSQLitePersistentStoreAtPath:storePath
                                                                     fromSeedDatabaseAtPath:seedPath
                                                                          withConfiguration:nil
                                                                                    options:nil
                                                                                      error:&error];
    NSAssert(persistentStore, @"Failed to add persistent store with error: %@", error);
    
    // Create the managed object contexts
    [managedObjectStore createManagedObjectContexts];
}

@end
