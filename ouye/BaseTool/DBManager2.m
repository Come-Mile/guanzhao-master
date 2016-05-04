//
//  DBManager2.m
//  lianhelihua
//
//  Created by Sino on 15/11/25.
//  Copyright (c) 2015年 Sino. All rights reserved.
//

#import "DBManager2.h"
#import "FMDatabase.h"


@implementation DBManager2
{
    FMDatabase *_dataBase;
}

static DBManager2 *manager = nil;
+ (DBManager2 *)shared{
    if (manager == nil) {
        manager = [[DBManager2 alloc]init];
    }
    return manager;
}
- (id)init
{
    self = [super init];
    if (self) {
        NSString *path=[NSHomeDirectory() stringByAppendingFormat:@"/Documents/myData.db"];
        _dataBase=[[FMDatabase alloc]initWithPath:path];
        if ([_dataBase open]) {
            
            NSString *createSql = @"create table if not exists detail (uid varchar(256),msg varchar(256),state varchar(256),code varchar(256),datetime varchar(256),checkstr varchar(256),tags INTEGER PRIMARY KEY AUTOINCREMENT);";
            if (![_dataBase executeUpdate:createSql]) {
                NSLog(@"create dataBase error:%@",_dataBase.lastError);
            }
        }
    }
    return self;
}

- (void)inserDataWIthUid:(NSString *)uid msg:(NSString *)msg state:(NSString *)state code:(NSString *)code dateTime:(NSString *)datetime check:(NSString *)check
{
    NSString *insertSql = @"insert into detail values(?,?,?,?,?,?,?)";
    if (![_dataBase executeUpdate:insertSql,uid,msg,state,code,datetime,check,NULL]) {
        NSLog(@"insert error:%@",_dataBase.lastError);
    }
}

- (BOOL)isExists:(NSString *)uid{
    NSString *selectSql = @"select * from detail where uid = ?";
    FMResultSet *set = [_dataBase executeQuery:selectSql,uid];
    return [set next];
}

- (void)deleteDataWith:(NSString *)uid{
    NSString *deleteSql = @"delete from detail where uid = ?";
    if (![_dataBase executeUpdate:deleteSql,uid]) {
        NSLog(@"delete error:%@",_dataBase.lastError);
    }
}

- (void)deleteDataWith:(NSString *)uid tags:(NSString *)tags{
    NSString *deleteSql = @"delete from detail where uid = ? and tags = ?";
    if (![_dataBase executeUpdate:deleteSql,uid,tags]) {
        NSLog(@"delete error:%@",_dataBase.lastError);
    }
}

- (void)deleteDataWith:(NSString *)uid dateTime:(NSString *)datetime
{
    NSString *deleteSql = @"delete from detail where uid = ? and datetime = ?";
    if (![_dataBase executeUpdate:deleteSql,uid,datetime]) {
        NSLog(@"delete error:%@",_dataBase.lastError);
    }
}

/**
 *  改
 */
- (void)updateDataWithDateTime:(NSString *)datetime check:(NSString *)check uid:(NSString *)uid
{
    NSString *updateSql = @"update detail set checkstr = ? where datetime = ? and uid = ?";
    if(![_dataBase executeUpdate:updateSql,check,datetime,uid]){
        NSLog(@"delete error:%@",_dataBase.lastError);
    }
}
- (void)updateDataWithDateCheck:(NSString *)check uid:(NSString *)uid tags:(NSString *)tag
{
    NSString *updateSql = @"update detail set checkstr = ? where uid = ? and tags = ?";
    if(![_dataBase executeUpdate:updateSql,check,uid,tag]){
        NSLog(@"delete error:%@",_dataBase.lastError);
    }
}


- (NSArray *)selectAllDataWithUid:(NSString *)uid{
    NSMutableArray *array = [[NSMutableArray alloc]init];
    NSString *selectSql = @"select * from detail where uid = ?";
    FMResultSet *set = [_dataBase executeQuery:selectSql,uid];
    while ([set next]){
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        [dic setObject:[set stringForColumnIndex:0] forKey:@"uid"];
        [dic setObject:[set stringForColumnIndex:1] forKey:@"msg"];
        [dic setObject:[set stringForColumnIndex:2] forKey:@"state"];
        [dic setObject:[set stringForColumnIndex:3] forKey:@"code"];
        [dic setObject:[set stringForColumnIndex:4] forKey:@"datetime"];
        
        if ([set stringForColumnIndex:5]!=nil && [set stringForColumnIndex:6] != nil) {
            [dic setObject:[set stringForColumnIndex:5] forKey:@"checkstr"];
            [dic setObject:[set stringForColumnIndex:6] forKey:@"tags"];
        }
        [array addObject:dic];
    }
    return array;
}

@end
