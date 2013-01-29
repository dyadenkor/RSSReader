//
//  RRServerGateway.m
//  RSSReader
//
//  Created by admin on 1/15/13.
//  Copyright (c) 2013 Roman Dyadenko. All rights reserved.
//

#import "RRServerGateway.h"

@interface RRServerGateway ()
@property (nonatomic)  RKObjectManager *objectManager;
@property (nonatomic) NSManagedObjectModel *managedObjectModel;
@property (nonatomic) RKManagedObjectStore *managedObjectStore;
@end

@implementation RRServerGateway

- (id)init
{
    self = [super init];
    if (self)
    {
        if (!self.objectManager)
        {
            // Setup RestKit
            [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class]
                                       forMIMEType:@"text/javascript"];
            
            [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
            
            // object manager
            self.objectManager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:ServerBaseURL]];
            
            // managed object model
            
            self.managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
            
            // managed object store
            self.managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:self.managedObjectModel];
            self.objectManager.managedObjectStore = self.managedObjectStore;
            
            // object mappings
            RKObjectMapping *objectMapping = [RRRootResponseObjectMapping objectMapping];
            
            // Register our mappings with the provider
            RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:objectMapping
                                                                                               pathPattern:nil
                                                                                                   keyPath:nil
                                                                                               statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
            [self.objectManager addResponseDescriptor:responseDescriptor];
            
            // Complete Core Data stack initialization
            
            [self.managedObjectStore createPersistentStoreCoordinator];
            
            NSString *storePath = [RKApplicationDataDirectory() stringByAppendingPathComponent:@"Model.sqlite"];
            
            NSString *seedPath = [NSBundle.mainBundle pathForResource:@"Model"
                                                               ofType:@"sqlite"];
            
            NSError *error = nil;
            NSPersistentStore *persistentStore = [self.managedObjectStore addSQLitePersistentStoreAtPath:storePath
                                                                                  fromSeedDatabaseAtPath:seedPath
                                                                                       withConfiguration:nil
                                                                                                 options:nil
                                                                                                   error:&error];
            NSAssert(persistentStore, @"Failed to add persistent store with error: %@", error);
            
            // Create the managed object contexts
            [self.managedObjectStore createManagedObjectContexts];
            
            // Configure a managed object cache to ensure we do not create duplicate objects
            if (!self.managedObjectStore.managedObjectCache)
            {
                self.managedObjectStore.managedObjectCache = [[RKInMemoryManagedObjectCache alloc] initWithManagedObjectContext:self.managedObjectStore.persistentStoreManagedObjectContext];
            }
        }
    }
    
    return self;
}

- (void)sendData
{
    // get data from server
    NSString *pathToResource = [NSString stringWithFormat:@"/ajax/services/feed/load?v=1.0&q=%@&num=-1&output=json", self.baseURL];
    
    [self.objectManager getObjectsAtPath:pathToResource
                         parameters:nil
                            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult)
                            {
                                [self.delegate didRecieveResponceSucces:mappingResult];
                            }
                            failure:^(RKObjectRequestOperation *operation, NSError *error)
                            {
                                [self.delegate didRecieveResponceFailure:error];
                            }];
}

@end
