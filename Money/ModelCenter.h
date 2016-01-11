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



/*
 价格接口
 http://proxy.finance.qq.com/ifzqgtimg/appstock/app/fqkline/get?p=1&param=sz002081,day,,,320,qfq&_rndtime=1449565003&_appName=ios&_dev=iPhone6,2&_devId=66c90aa82c1f94a1e87845a8ecb5f4be0dc80e55&_appver=4.2.0&_ifChId=&_isChId=1&_osVer=8.4&_uin=10000&_wxuin=20000
 http://proxy.finance.qq.com/ifzqgtimg/appstock/app/fqkline/get?param=sz000712,day,,,320,qfq
 
 类型参数的接口
 http://proxy.finance.qq.com/ifzqgtimg/appstock/indicators/%@/D1
 
 */
@end
