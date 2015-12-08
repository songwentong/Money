//
//  CoreDataManager.h
//  CoreData
//
//  Created by SongWentong on 10/17/15.
//  Copyright © 2015 SongWentong. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NSPersistentStoreCoordinator;
@class NSManagedObjectContext;
@interface CoreDataManager : NSObject
@property (readonly, nonatomic,strong) NSOperationQueue *operationQueue;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;



//单例类
+(instancetype)sharedManager;
@end
