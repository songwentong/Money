//
//  MaAndPrice+CoreDataProperties.h
//  Money
//
//  Created by SongWentong on 12/8/15.
//  Copyright © 2015 275712575@qq.com. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "MaAndPrice.h"

NS_ASSUME_NONNULL_BEGIN

@interface MaAndPrice (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *ma5;
@property (nullable, nonatomic, retain) NSNumber *ma10;
@property (nullable, nonatomic, retain) NSNumber *ma20;
@property (nullable, nonatomic, retain) NSDate *date;
@property (nullable, nonatomic, retain) NSNumber *price;
@property (nullable, nonatomic, retain) NSNumber *code;

@end

NS_ASSUME_NONNULL_END
