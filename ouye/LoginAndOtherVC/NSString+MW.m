//
//  NSString+MW.m
//  ouye
//
//  Created by Sino on 16/3/25.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import "NSString+MW.h"

@implementation NSString (MW)


+ (BOOL)checkPWDWithString:(NSString *)pwd
{
    NSString *passWordRegex = @"^[a-zA-Z0-9]{6,20}+$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    
    BOOL isPwd=[passWordPredicate evaluateWithObject:pwd];
    return isPwd;
}

+ (BOOL)checkSpace:(NSString *)str
{
    NSString *_string = [NSString stringWithFormat:@"%@",str];
    NSRange _range = [_string rangeOfString:@" "];
    if (_range.location != NSNotFound) {
        //有空格
        return YES;
    }else {
        //没有空格
        return NO;
    }
}

+ (BOOL)checkNameWith:(NSString *)name
{
    //     	[\u4e00-\u9fa5]
    NSString *regex = @"[\u4e00-\u9fa5][\u4e00-\u9fa5]*";
    //    NSString *regex = @"[\u4e00-\u9fa5]+";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isName=[pred evaluateWithObject:name];
    
    return isName;
}

+(NSString*)DataTOjsonString:(id)object
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

- (NSString *)removeChactString:(NSString *)str
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:str]];
}
@end
