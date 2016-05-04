//
//  NSString+MW.h
//  ouye
//
//  Created by Sino on 16/3/25.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MW)
+ (BOOL)checkPWDWithString:(NSString *)pwd;

+ (BOOL)checkSpace:(NSString *)str;
+ (BOOL)checkNameWith:(NSString *)name;
+(NSString*)DataTOjsonString:(id)object;


- (NSString *)removeChactString:(NSString *)str;
@end
