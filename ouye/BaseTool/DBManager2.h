//
//  DBManager2.h
//  lianhelihua
//
//  Created by Sino on 15/11/25.
//  Copyright (c) 2015年 Sino. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBManager2 : NSObject

+ (DBManager2 *)shared;

- (BOOL)isExists:(NSString *)uid;
- (void)deleteDataWith:(NSString *)uid;

- (void)deleteDataWith:(NSString *)uid dateTime:(NSString *)datetime;
- (void)deleteDataWith:(NSString *)uid tags:(NSString *)tags;

- (void)updateDataWithDateTime:(NSString *)datetime check:(NSString *)check uid:(NSString *)uid;
- (void)updateDataWithDateCheck:(NSString *)check uid:(NSString *)uid tags:(NSString *)tag;
/** 插入一条
 *  @param uid      主键 , 保存的用户为手机号
 */
- (void)inserDataWIthUid:(NSString *)uid msg:(NSString *)msg state:(NSString *)state code:(NSString *)code dateTime:(NSString *)datetime check:(NSString *)check;

- (NSArray *)selectAllDataWithUid:(NSString *)uid;
@end
