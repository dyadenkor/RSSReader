//
//  RRServerGateway.m
//  RSSReader
//
//  Created by admin on 1/15/13.
//  Copyright (c) 2013 Roman Dyadenko. All rights reserved.
//

#import "RRServerGateway.h"

// rf me
#define SERVER_BASE_URL_STRING @"https://ajax.googleapis.com"

@implementation RRServerGateway

- (void)sendData
{
    // Setup RestKit
    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class]
                               forMIMEType:@"text/javascript"];
    
    // object manager
    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:SERVER_BASE_URL_STRING]];
    
    // managed object model
/* NSURL *pathToModel = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Model"
                                                                                ofType:@"momd"]];
    NSManagedObjectModel *managedObjectModel = [[[NSManagedObjectModel alloc] initWithContentsOfURL:pathToModel] mutableCopy];
*/
    NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];

    // managed object store
    RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];
    objectManager.managedObjectStore = managedObjectStore;
    
    // object mappings
    RKObjectMapping *objectMapping = [RRRootResponseObjectMapping objectMapping];
    
    // Register our mappings with the provider
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:objectMapping
                                                                                       pathPattern:nil
                                                                                           keyPath:nil
                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [objectManager addResponseDescriptor:responseDescriptor];
    
    /**
     Complete Core Data stack initialization
     */
    [managedObjectStore createPersistentStoreCoordinator];
    
    NSString *storePath = [RKApplicationDataDirectory() stringByAppendingPathComponent:@"Model.sqlite"];
    
    NSString *seedPath = [[NSBundle mainBundle] pathForResource:@"Model"
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
    
    // Configure a managed object cache to ensure we do not create duplicate objects
    managedObjectStore.managedObjectCache = [[RKInMemoryManagedObjectCache alloc] initWithManagedObjectContext:managedObjectStore.persistentStoreManagedObjectContext];
    
    // get data from server
    NSString *pathToResource = [NSString stringWithFormat:@"/ajax/services/feed/load?v=1.0&q=%@&num=-1&output=json", self.baseURL];
    
    [objectManager getObjectsAtPath:pathToResource
                         parameters:nil
                            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult)
                            {
                                NSLog(@"%@", [mappingResult firstObject]);
                                [[self delegate] didRecieveResponceSucces:mappingResult];
                            }
                            failure:^(RKObjectRequestOperation *operation, NSError *error)
                            {
                                [[self delegate] didRecieveResponceFailure:error];
                            }];
}

@end
