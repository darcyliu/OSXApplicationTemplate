//
//  DBManager.h
//  OSXApplicationTemplate
//
//  Created by Darcy Liu on 06/07/2022.
//  Copyright © 2022 Darcy Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
NS_ASSUME_NONNULL_BEGIN

@interface DBManager : NSObject
+ (instancetype)sharedInstance;
@property (readonly, strong) NSPersistentContainer *persistentContainer;
@property (readonly, strong) NSManagedObjectContext *managedObjectContext;
@end

NS_ASSUME_NONNULL_END
