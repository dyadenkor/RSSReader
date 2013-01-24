//
//  RRServerGateway.m
//  RSSReader
//
//  Created by admin on 1/15/13.
//  Copyright (c) 2013 Roman Dyadenko. All rights reserved.
//

#import "RRServerGateway.h"

@implementation RRServerGateway
@synthesize baseURL;

/*- (void)sendData
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://ajax.googleapis.com/ajax/services/feed/load?v=1.0&q=%@&num=-1&output=json",baseURL]];

    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"text/javascript"];
    
    
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    RKObjectManager* objectManager = [RKObjectManager managerWithBaseURL:url];
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    NSManagedObjectModel *managedObjectModel = [[[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL] mutableCopy];
    RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];
    objectManager.managedObjectStore = managedObjectStore;
    
    
    NSString *storePath = [RKApplicationDataDirectory() stringByAppendingPathComponent:@"Model.sqlite"];
    NSString *seedPath = [[NSBundle mainBundle] pathForResource:@"Model" ofType:@"sqlite"];
    NSError *error = nil;
     NSPersistentStore *persistentStore = [managedObjectStore addSQLitePersistentStoreAtPath:storePath fromSeedDatabaseAtPath:seedPath withConfiguration:nil options:nil error:&error];
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    //RKObjectMapping *requestMapping = [RRRootResponseObjectMapping objectMapping];
    
    RKEntityMapping *requestMapping = [RKEntityMapping mappingForEntityForName:@"Root" inManagedObjectStore:[[RKObjectManager sharedManager] managedObjectStore]];
    requestMapping.identificationAttributes = @[ @"someID" ];
    [requestMapping addAttributeMappingsFromDictionary:
     @{
     @"id": @"someID",
     @"responseStatus": @"statusCode",
     }];
    
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:requestMapping pathPattern:nil keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    RKObjectRequestOperation *objectRequestOperation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[responseDescriptor]];
    
    [objectRequestOperation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult)
    {
        [[self delegate] didRecieveResponceSucces:mappingResult];
    }
    failure:^(RKObjectRequestOperation *operation, NSError *error)
    {
        [[self delegate] didRecieveResponceFailure:error];
    }];
    
    [objectRequestOperation start];

}
*/
- (void)sendData
{
     [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"text/javascript"];
    // Initialize RestKit
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://ajax.googleapis.com/ajax/services/feed/load?v=1.0&q=%@&num=-1&output=json",self.baseURL]];
    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:url];
    
    // Enable Activity Indicator Spinner
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    // Initialize managed object store
    NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];
    objectManager.managedObjectStore = managedObjectStore;
    
    // Setup our object mappings
    /**
     Mapping by entity. Here we are configuring a mapping by targetting a Core Data entity with a specific
     name. This allows us to map back Twitter user objects directly onto NSManagedObject instances --
     there is no backing model class!
     */
    RKEntityMapping *mapping = [RKEntityMapping mappingForEntityForName:@"Root" inManagedObjectStore:managedObjectStore];
   // userMapping.identificationAttributes = @[ @"someID" ];
    [mapping addAttributeMappingsFromDictionary:@{
     //@"id": @"someID",
     @"responseStatus": @"statusCode"
     }];
    
  
    // Register our mappings with the provider
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping
                                                                                       pathPattern:nil
                                                                                           keyPath:nil
                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [objectManager addResponseDescriptor:responseDescriptor];
    
    // Uncomment this to use XML, comment it to use JSON
    //  objectManager.acceptMIMEType = RKMIMETypeXML;
    //  [objectManager.mappingProvider setMapping:statusMapping forKeyPath:@"statuses.status"];
    
    // Database seeding is configured as a copied target of the main application. There are only two differences
    // between the main application target and the 'Generate Seed Database' target:
    //  1) RESTKIT_GENERATE_SEED_DB is defined in the 'Preprocessor Macros' section of the build setting for the target
    //      This is what triggers the conditional compilation to cause the seed database to be built
    //  2) Source JSON files are added to the 'Generate Seed Database' target to be copied into the bundle. This is required
    //      so that the object seeder can find the files when run in the simulator.
    /**
     Complete Core Data stack initialization
     */
    [managedObjectStore createPersistentStoreCoordinator];
    NSString *storePath = [RKApplicationDataDirectory() stringByAppendingPathComponent:@"Model.sqlite"];
    NSString *seedPath = [[NSBundle mainBundle] pathForResource:@"Model" ofType:@"sqlite"];
    NSError *error;
    NSPersistentStore *persistentStore = [managedObjectStore addSQLitePersistentStoreAtPath:storePath fromSeedDatabaseAtPath:seedPath withConfiguration:nil options:nil error:&error];
    NSAssert(persistentStore, @"Failed to add persistent store with error: %@", error);
    
    // Create the managed object contexts
    [managedObjectStore createManagedObjectContexts];
    
    // Configure a managed object cache to ensure we do not create duplicate objects
    managedObjectStore.managedObjectCache = [[RKInMemoryManagedObjectCache alloc] initWithManagedObjectContext:managedObjectStore.persistentStoreManagedObjectContext];

    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    RKObjectRequestOperation *objectRequestOperation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[responseDescriptor]];
    
    [objectRequestOperation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult)
     {
         [[self delegate] didRecieveResponceSucces:mappingResult];
     }
                                                  failure:^(RKObjectRequestOperation *operation, NSError *error)
     {
         [[self delegate] didRecieveResponceFailure:error];
     }];
    
    [objectRequestOperation start];
    
}

@end
