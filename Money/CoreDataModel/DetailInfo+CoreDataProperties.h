//
//  DetailInfo+CoreDataProperties.h
//  Money
//
//  Created by SongWentong on 12/8/15.
//  Copyright © 2015 275712575@qq.com. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "DetailInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailInfo (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *code;
@property (nullable, nonatomic, retain) NSNumber *d;
@property (nullable, nonatomic, retain) NSString *date;
@property (nullable, nonatomic, retain) NSNumber *dea;
@property (nullable, nonatomic, retain) NSNumber *diff;
@property (nullable, nonatomic, retain) NSNumber *j;
@property (nullable, nonatomic, retain) NSNumber *k;
@property (nullable, nonatomic, retain) NSNumber *ma5;
@property (nullable, nonatomic, retain) NSNumber *ma10;
@property (nullable, nonatomic, retain) NSNumber *ma20;
@property (nullable, nonatomic, retain) NSNumber *macd;
@property (nullable, nonatomic, retain) NSNumber *price;
@property (nullable, nonatomic, retain) NSNumber *rsi6;
@property (nullable, nonatomic, retain) NSNumber *rsi12;
@property (nullable, nonatomic, retain) NSNumber *rsi24;

@end

NS_ASSUME_NONNULL_END
