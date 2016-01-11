//
//  ModelCenter.m
//  Money
//
//  Created by SongWentong on 12/7/15.
//  Copyright © 2015 275712575@qq.com. All rights reserved.
//

#import "ModelCenter.h"
#import "WTNetWorkManager.h"
#import "AppDelegate.h"
@import CoreData;

#import "Stock.h"
#import "DetailInfo.h"
@implementation ModelCenter
static ModelCenter *center = nil;
+(instancetype)sharedModelCenter{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        center = [[ModelCenter alloc] init];
    });
    return center;
}


+(NSArray*)readSHCode{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"code" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    return [dict valueForKey:@"SH"];
}

+(NSArray*)readSZCode{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"code" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    return [dict valueForKey:@"SZ"];
}

/*!
 关于数据抓取
 目前抓取的全是日K线,包括MACD,MA,KDJ和RSI
 */

-(void)daliyUpdate
{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *string = [formatter stringFromDate:date];
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
//    if (![standardUserDefaults boolForKey:string]) {
    
        [self updateAllDataWithComplection:^{
            [standardUserDefaults setBool:YES forKey:string];
            [standardUserDefaults synchronize];
        }];
        
//    }
}


//更新所有数据
-(void)updateAllDataWithComplection:(dispatch_block_t)complection
{
//    [self findMACDAndComplection:^{
        /*
        [self findKDJAndComplection:^{
            [self findRSIAndComplection:^{
                if (complection) {
                    complection();
                }
            }];
        }];
         */
//    }];
//    [self findAllMACDInfoComplection:^(NSMutableDictionary *result) {
//        NSLog(@"%@",result);
//    }];
    [self findAllStockWithType:@"MACD" complection:^(NSMutableDictionary *macdData) {
//        NSLog(@"%@",allData);
        [self findAllStockWithType:@"KDJ" complection:^(NSMutableDictionary *kdjData) {
            
            [self findAllStockWithType:@"RSI" complection:^(NSMutableDictionary *rsiData) {
                
            }];
        }];
    }];
    
}


-(void)findStockWithType:(NSString*)type code:(NSString*)code complection:(void(^)(NSArray *result))complection
{
    NSString *url = [NSString stringWithFormat:@"http://proxy.finance.qq.com/ifzqgtimg/appstock/indicators/%@/D1",type];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"SZ" forKey:@"market"];
    [parameters setValue:@"12-26-9" forKey:@"args"];
    [parameters setValue:code forKey:@"code"];
    NSMutableURLRequest *request = [[WTNetWorkManager sharedKit] requestWithMethod:@"GET" URLString:url parameters:parameters error:nil];
    [request setValue:@"aaa" forHTTPHeaderField:@"aaa"];
    [[[WTNetWorkManager sharedKit].session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
      {
          
          NSArray *stockData = [NSArray array];
          if (data) {
              NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
              stockData = [dict valueForKey:@"data"];
          }
          if (complection) {
              complection(stockData);
          }
      }] resume];
}

-(void)findAllStockWithType:(NSString *)type complection:(void(^)(NSMutableDictionary *allData))complection
{
    NSArray<NSString*> *szCodes = [[self class] readSZCode];
    NSMutableDictionary *finalResult = [NSMutableDictionary dictionary];
    
    NSInteger count = szCodes.count;
    __block NSInteger complectionCount = 0;
    
    [szCodes enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self findStockWithType:type code:obj complection:^(NSArray *result) {
            complectionCount = complectionCount + 1;
            [finalResult setValue:result forKey:obj];
            NSLog(@"complection :%ld  count :%ld",complectionCount,count);
            if (complectionCount == count) {
                if (complection) {
                    complection(finalResult);
                }
            }
        }];
        
        
    }];
}

-(void)findAllMACDInfoComplection:(void(^)(NSMutableDictionary *allMACDData))complection
{
    

    NSArray<NSString*> *szCodes = [[self class] readSZCode];
    NSMutableDictionary *finalResult = [NSMutableDictionary dictionary];
    
    NSInteger count = szCodes.count;
    __block NSInteger complectionCount = 0;

    [szCodes enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self findStockWithType:@"MACD" code:obj complection:^(NSArray *result) {
            complectionCount = complectionCount + 1;
            [finalResult setValue:result forKey:obj];
            NSLog(@"complection :%ld  count :%ld",complectionCount,count);
            if (complectionCount == count) {
                if (complection) {
                    complection(finalResult);
                }
            }
        }];
        

    }];
}


-(void)findMACDAndComplection:(dispatch_block_t)complection
{
    NSTimeInterval time1 = [[NSDate date] timeIntervalSince1970];
    
    NSMutableArray * _array = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view, typically from a nib.
    NSString *url = @"http://proxy.finance.qq.com/ifzqgtimg/appstock/indicators/MACD/D1";
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"SZ" forKey:@"market"];
    [parameters setValue:@"12-26-9" forKey:@"args"];
    //    NSDate *date = [NSDate date];
    //    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //    [formatter setDateFormat:@""];
    NSArray *szCodes = [[self class] readSZCode];
//        szCodes = [szCodes subarrayWithRange:NSMakeRange(0, 10)];
    //    NSLog(@"%@",szCodes);
    
    NSInteger count = szCodes.count;
    __block NSInteger complectionCount = 0;
    
    [szCodes enumerateObjectsUsingBlock:^(NSString *stockCode, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [parameters setValue:stockCode forKey:@"code"];
        
        NSMutableURLRequest *request = [[WTNetWorkManager sharedKit] requestWithMethod:@"GET" URLString:url parameters:parameters error:nil];
        [request setValue:@"aaa" forHTTPHeaderField:@"aaa"];
        
        
        
        [[[WTNetWorkManager sharedKit].session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            complectionCount = complectionCount + 1;
            //            NSLog(@"complection");
            
            if (data) {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                if (dict) {
                    [_array addObject:dict];
                }
                NSLog(@"成功(%ld)",(long)_array.count);
            }else{
                NSLog(@"失败");
            }
            
            
            if (complectionCount==count) {
                
                
                //解决在并发情况下的重复调用问题
                static dispatch_once_t onceToken;
                dispatch_once(&onceToken, ^{
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        NSManagedObjectContext *context = [AppDelegate sharedDelegate].managedObjectContext;
                        
                        
                        [_array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            
                            NSLog(@"存了%ld条数据",idx);
                            
                            if (idx%20==0) {
                                if ([context hasChanges]) {
                                    [context save:nil];
                                }
                            }
                            
                            NSArray *data = [obj valueForKey:@"data"];
                            if (data.count>2) {
                                
                                __block NSInteger code = 0;
                                [data enumerateObjectsUsingBlock:^(NSDictionary *obj1, NSUInteger idx, BOOL * _Nonnull stop) {
                                    if (idx ==0) {
                                        code = [[obj1 valueForKey:@"code"] integerValue];
                                    }else{
                                        CGFloat macd = [[obj1 valueForKey:@"MACD"] floatValue];
                                        CGFloat dea = [[obj1 valueForKey:@"DEA"] floatValue];
                                        CGFloat dif = [[obj1 valueForKey:@"DIF"] floatValue];
                                        NSString *date = [obj1 valueForKey:@"DATE"];
                                        
                                        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"DetailInfo"];
                                        request.predicate = [NSPredicate predicateWithFormat:@"code == %ld AND date == %@ ",code,date];
                                        
                                        NSError *error = nil;
                                        NSArray *results = [context executeFetchRequest:request error:&error];
                                        
                                        //如果找到了对应的数据,就修改,没有找到了,就插入一条新数据
                                        DetailInfo *detailInfo = nil;
                                        if (results.count>0) {
                                            
                                            detailInfo = results.lastObject;
                                            //                                NSLog(@"%@",NSStringFromClass([stock class]));
                                        }else{
                                            detailInfo = [NSEntityDescription insertNewObjectForEntityForName:@"DetailInfo" inManagedObjectContext:context];
                                            detailInfo.date = date;
                                            detailInfo.code = [NSNumber numberWithInteger:code];
                                        }
                                        detailInfo.dea = [NSNumber numberWithFloat:dea];
                                        detailInfo.diff = [NSNumber numberWithFloat:dif];
                                        detailInfo.macd = [NSNumber numberWithFloat:macd];

                                        
                                        
                                        
                                    }
                                }];
                                
                                
                                
                            }
                        }];
                        if ([context save:nil]) {
                            NSLog(@"保存成功");
                        }else{
                            NSLog(@"保存失败");
                        }
                        
                        if (complection) {
                            complection();
                            NSTimeInterval time2 = [[NSDate date] timeIntervalSince1970];
                            NSLog(@"查找MACD用时 %f",time2-time1);
                        }
                        
                        
                        NSLog(@"%@",NSHomeDirectory());
                            
                        
                        
                    }];
                    
                    
                    
                });
                
                
                
            }
        }] resume];
    }];
    
    
}

-(void)findKDJAndComplection:(dispatch_block_t)complection
{
    NSMutableArray * _array = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view, typically from a nib.
    NSString *url = @"http://proxy.finance.qq.com/ifzqgtimg/appstock/indicators/KDJ/W1";
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"SZ" forKey:@"market"];
    [parameters setValue:@"12-26-9" forKey:@"args"];
    //    NSDate *date = [NSDate date];
    //    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //    [formatter setDateFormat:@""];
    NSArray *szCodes = [[self class] readSZCode];
    //    szCodes = [szCodes subarrayWithRange:NSMakeRange(0, 10)];
    //    NSLog(@"%@",szCodes);
    
    NSInteger count = szCodes.count;
    __block NSInteger complectionCount = 0;
    
    [szCodes enumerateObjectsUsingBlock:^(NSString *stockCode, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [parameters setValue:stockCode forKey:@"code"];
        
        NSMutableURLRequest *request = [[WTNetWorkManager sharedKit] requestWithMethod:@"GET" URLString:url parameters:parameters error:nil];
        [request setValue:@"aaa" forHTTPHeaderField:@"aaa"];
        
        
        
        [[[WTNetWorkManager sharedKit].session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            complectionCount = complectionCount + 1;
            //            NSLog(@"complection");
            
            if (data) {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                if (dict) {
                    [_array addObject:dict];
                }
                NSLog(@"成功(%ld)",(long)_array.count);
            }else{
                NSLog(@"失败");
            }
            
            
            if (complectionCount==count) {
                
                
                //解决在并发情况下的重复调用问题
                static dispatch_once_t onceToken;
                dispatch_once(&onceToken, ^{
                    
                    [_array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        NSArray *data = [obj valueForKey:@"data"];
                        if (data.count>2) {
                            NSDictionary *firstObject = [data firstObject];
                            NSDictionary *lastObject = data [data.count -2];
                            
                            
                            NSInteger code = [[firstObject valueForKey:@"code"] integerValue];
                            CGFloat K = [[lastObject valueForKey:@"K"] floatValue];
                            CGFloat D = [[lastObject valueForKey:@"D"] floatValue];
                            CGFloat J = [[lastObject valueForKey:@"J"] floatValue];
                            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                NSManagedObjectContext *context = [AppDelegate sharedDelegate].managedObjectContext;
                                
                                
                                NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Stock"];
                                request.predicate = [NSPredicate predicateWithFormat:@"code == %ld",code];
                                //                            request.sortDescriptors =
                                NSError *error = nil;
                                NSArray *results = [context executeFetchRequest:request error:&error];
                                
                                //如果找到了对应的数据,就修改,没有找到了,就插入一条新数据
                                Stock *stock = nil;
                                if (results.count>0) {
                                    
                                    stock = results.lastObject;
                                    //                                NSLog(@"%@",NSStringFromClass([stock class]));
                                }else{
                                    stock = [NSEntityDescription insertNewObjectForEntityForName:@"Stock" inManagedObjectContext:context];
                                    
                                }
                                stock.code = [NSNumber numberWithInteger:code];
                                stock.k = [NSNumber numberWithFloat:K];
                                stock.d = [NSNumber numberWithFloat:D];
                                stock.j = [NSNumber numberWithFloat:J];
                                
                                
                                if ([context save:nil]) {
                                    
                                }
                                if (complection) {
                                    complection();
                                }
                                
                            }];
                            
                            
                        }
                        
                        if (idx==_array.count-1) {
                            NSLog(@"%@",NSHomeDirectory());
                        }
                        
                    }];
                    
                    
                    
                });
                
                
                
            }
        }] resume];
    }];
}

-(void)findRSIAndComplection:(dispatch_block_t)complection
{
    NSMutableArray * _array = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view, typically from a nib.
    NSString *url = @"http://proxy.finance.qq.com/ifzqgtimg/appstock/indicators/RSI/W1";
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"SZ" forKey:@"market"];
    [parameters setValue:@"12-26-9" forKey:@"args"];
    //    NSDate *date = [NSDate date];
    //    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //    [formatter setDateFormat:@""];
    NSArray *szCodes = [[self class] readSZCode];
    //        szCodes = [szCodes subarrayWithRange:NSMakeRange(0, 10)];
    //    NSLog(@"%@",szCodes);
    
    NSInteger count = szCodes.count;
    __block NSInteger complectionCount = 0;
    
    [szCodes enumerateObjectsUsingBlock:^(NSString *stockCode, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [parameters setValue:stockCode forKey:@"code"];
        
        NSMutableURLRequest *request = [[WTNetWorkManager sharedKit] requestWithMethod:@"GET" URLString:url parameters:parameters error:nil];
        [request setValue:@"aaa" forHTTPHeaderField:@"aaa"];
        
        
        
        [[[WTNetWorkManager sharedKit].session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            complectionCount = complectionCount + 1;
            //            NSLog(@"complection");
            
            if (data) {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                if (dict) {
                    [_array addObject:dict];
                }
                NSLog(@"成功(%ld)",(long)_array.count);
            }else{
                NSLog(@"失败");
            }
            
            
            if (complectionCount==count) {
                
                
                //解决在并发情况下的重复调用问题
                static dispatch_once_t onceToken;
                dispatch_once(&onceToken, ^{
                    
                    [_array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        NSArray *data = [obj valueForKey:@"data"];
                        if (data.count>2) {
                            NSDictionary *firstObject = [data firstObject];
                            NSDictionary *lastObject = data[data.count-2];
                            
                            
                            NSInteger code = [[firstObject valueForKey:@"code"] integerValue];
                            CGFloat RSI = [[lastObject valueForKey:@"RSI2"] floatValue];
                            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                NSManagedObjectContext *context = [AppDelegate sharedDelegate].managedObjectContext;
                                
                                
                                NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Stock"];
                                request.predicate = [NSPredicate predicateWithFormat:@"code == %ld",code];
                                //                            request.sortDescriptors =
                                NSError *error = nil;
                                NSArray *results = [context executeFetchRequest:request error:&error];
                                
                                //如果找到了对应的数据,就修改,没有找到了,就插入一条新数据
                                Stock *stock = nil;
                                if (results.count>0) {
                                    
                                    stock = results.lastObject;
                                    //                                NSLog(@"%@",NSStringFromClass([stock class]));
                                }else{
                                    stock = [NSEntityDescription insertNewObjectForEntityForName:@"Stock" inManagedObjectContext:context];
                                    
                                }
                                stock.code = [NSNumber numberWithInteger:code];
                                stock.rsi = [NSNumber numberWithFloat:RSI];
                                
                                
                                if ([context save:nil]) {
                                    
                                }
                                if (complection) {
                                    complection();
                                }
                                
                            }];
                            
                            
                            
                        }
                        
                        if (idx==_array.count-1) {
                            NSLog(@"%@",NSHomeDirectory());
                        }
                        
                    }];
                    
                    
                    
                });
                
                
                
            }
        }] resume];
    }];
    
}

/*!
 分析
 1.找出D和RSI最低的数据,排序
 
 分析指标分别有:
 D,RSI,MA和当前价关系,流通市值
 */
-(void)analysis
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Stock"];
    NSManagedObjectContext *managedObjectContext = [AppDelegate sharedDelegate].managedObjectContext;
    NSArray *result = [managedObjectContext executeFetchRequest:request error:nil];
    
    NSArray *dArray = [result sortedArrayWithOptions:0 usingComparator:^NSComparisonResult(Stock *obj1, Stock *obj2) {
        if (obj1.d.floatValue < obj2.d.floatValue) {
            return NSOrderedAscending;
        }else{
            return NSOrderedDescending;
        }
    }];
    
    NSArray *rsiArray = [result sortedArrayWithOptions:0 usingComparator:^NSComparisonResult(Stock *obj1, Stock *obj2) {
        if (obj1.rsi.floatValue < obj2.rsi.floatValue) {
            return NSOrderedAscending;
        }else{
            return NSOrderedDescending;
        }
    }];
    
    NSMutableOrderedSet *set = [NSMutableOrderedSet orderedSet];
    
    
    
    
    [dArray enumerateObjectsUsingBlock:^(Stock* obj1, NSUInteger idx, BOOL * _Nonnull stop) {
        [rsiArray enumerateObjectsUsingBlock:^(Stock* obj2, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj1.code integerValue] == [obj2.code integerValue]) {
                [set addObject:obj1];
            }
        }];
    }];
    
    
    [set enumerateObjectsUsingBlock:^(Stock *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"%@",obj.code);
    }];
    
}













@end
