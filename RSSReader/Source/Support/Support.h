//
//  Support.h
//  RSSReader
//
//  Created by admin on 1/18/13.
//  Copyright (c) 2013 Roman Dyadenko. All rights reserved.
//

#import <RestKit/RestKit.h>

// Object Mapping
#import "RRRootResponseObjectMapping.h"
#import "RRFeedObjectMapping.h"
#import "RRNewDetailObjectMapping.h"
#import "RRSiteInfoObjectMapping.h"

// DataSourceItem
#import "RRAllNewsDataSourceItem.h"

// ServerGateWay
#import "RRServerGateway.h"

// AlertViewBlock
#import "RRAlertViewBlock.h"

// CoreData
#import "SiteLink.h"
#import "SiteInfo.h"
#import "SiteContent.h"

#import "RRManagedObjectContext.h"

// RRTableViewCells
#import "RRAllNewsCell.h"

// entity names
extern NSString *const SiteLinkEntityName;

// cells identifier
extern NSString *const SettingCellIdentyfier;
extern NSString *const AllNewsVCCellIdentifier;