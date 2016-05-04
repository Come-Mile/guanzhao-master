//
//  QuenstionModel.m
//  Questionnaire
//
//  Created by Sino on 16/3/9.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import "QuenstionModel.h"

@implementation QuenstionModel

- (NSMutableArray *)optionalAnswers {
    if (_optionalAnswers == nil) {
        _optionalAnswers = [[NSMutableArray alloc] init];
    }
    return _optionalAnswers;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqual:@"id"]) {
        self.qid = value;
    }else if([key isEqualToString:@"question_name"]){
        self.questionSummary = value;
    }else if([key isEqualToString:@"question_type"]){
        self.type = value;
    }else if([key isEqualToString:@"jump_question"]){

        self.jump_question = value;
    }
}

@end

@implementation OptionalAnswerModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqual:@"id"]) {
        self.aid = value;
    }else if([key isEqualToString:@"option_name"]){
        self.optionalAnswerSummary = value;
    }else if([key isEqualToString:@"mutex_id"]){
        self.strMutex_id = value;
        
    }
}

- (NSString *)strMutex_id
{
    return [_strMutex_id stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
}

- (NSArray *)mutexIds {
    if (self.strMutex_id == nil || self.strMutex_id.length == 0) {
        return nil;
    }
    
    NSArray *array = [self.strMutex_id componentsSeparatedByString:@","];
    return array;
}
@end
