//
//  PushModel.h
//  Sainuo_Project
//
//  Created by 薛俊强 on 16/2/17.
//  Copyright © 2016年 薛俊强. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "FMDB.h"

@interface JKDBHelper : NSObject

@property (nonatomic, retain, readonly) FMDatabaseQueue *dbQueue;

+ (JKDBHelper *)shareInstance;

+ (NSString *)dbPath;

- (BOOL)changeDBWithDirectoryName:(NSString *)directoryName;

@end
