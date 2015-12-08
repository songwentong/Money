//
//  ModelCenter.h
//  Money
//
//  Created by SongWentong on 12/7/15.
//  Copyright © 2015 275712575@qq.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelCenter : NSObject
+(instancetype)sharedModelCenter;

//每日更新
-(void)daliyUpdate;

//更新所有数据
-(void)updateAllDataWithComplection:(dispatch_block_t)complection;

-(void)findMACDAndComplection:(dispatch_block_t)complection;
-(void)findKDJAndComplection:(dispatch_block_t)complection;
-(void)findRSIAndComplection:(dispatch_block_t)complection;

/*!
 分析
 1.找出D和RSI最低的数据,排序
 */
-(void)analysis;

@end
