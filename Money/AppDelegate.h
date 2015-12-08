//
//  AppDelegate.h
//  Money
//
//  Created by SongWentong on 12/4/15.
//  Copyright © 2015 275712575@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
+(instancetype)sharedDelegate;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

