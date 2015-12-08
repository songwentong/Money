//
//  CoreDataManager.m
//  CoreData
//
//  Created by SongWentong on 10/17/15.
//  Copyright © 2015 SongWentong. All rights reserved.
//

#import "CoreDataManager.h"
#import "AppDelegate.h"
@import CoreData;
@interface CoreDataManager()
@property (nonatomic,strong) NSOperationQueue *operationQueue;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@end
@implementation CoreDataManager
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.operationQueue = [[NSOperationQueue alloc] init];
        
        
        //这是关键,最大并发数设置为1为了保证这个queue中创建persistentStoreCoordinator和managedObjectContext是最先的
        [_operationQueue setMaxConcurrentOperationCount:1];
        
        [_operationQueue setSuspended:NO];
        
        [_operationQueue addOperationWithBlock:^{
            self.persistentStoreCoordinator = [AppDelegate sharedDelegate].persistentStoreCoordinator;
            
            self.managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
            
            [_managedObjectContext setPersistentStoreCoordinator:_persistentStoreCoordinator];
        }];
        
    }
    return self;
}
@end
