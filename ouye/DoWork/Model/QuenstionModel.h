//
//  QuenstionModel.h
//  Questionnaire
//
//  Created by Sino on 16/3/9.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuenstionModel : NSObject

// 问题id
@property (nonatomic, copy) NSString *qid;
@property (nonatomic, copy) NSString *questionSummary;
@property (nonatomic, strong) NSMutableArray *optionalAnswers;


/**
 *  ，1为单选，2为多选，3为判断，4为填空
 */
@property (nonatomic ,copy)NSString *type;

///**
// *  是否可跳题
// */
//@property (nonatomic ,copy)NSString *jumpStr;

@property (nonatomic ,copy)NSString *answers;

@property (nonatomic ,copy)NSString *code;
//forced_jump：是否强制跳题：0否、1是
@property (nonatomic ,copy)NSString *forced_jump;
//高度
@property (nonatomic ,copy)NSString *high;
//是否必填
@property (nonatomic ,copy)NSString *isrequired;

//跳转的题的题号
@property (nonatomic ,copy)NSString *jump_question;


@property (nonatomic ,copy)NSString *max_option;
@property (nonatomic ,copy)NSString *max_word_num;
@property (nonatomic ,copy)NSString *min_option;
@property (nonatomic ,copy)NSString *min_word_num;
@property (nonatomic ,copy)NSString *note;

//prompt：提示
@property (nonatomic ,copy)NSString *prompt;
//
//@property (nonatomic ,copy)NSString *question_name;
//问题的题号
@property (nonatomic ,copy)NSString *question_num;

//@property (nonatomic ,copy)NSString *question_type;

//辅助字段 标记该题是否已选择
@property (nonatomic, assign) BOOL isSelected;

@end


@interface OptionalAnswerModel : NSObject

// 选项答案id
@property (nonatomic, copy) NSString *aid;
// 选项答案内容描述
@property (nonatomic, copy) NSString *optionalAnswerSummary;

// 辅助字段，标识是否选中
@property (nonatomic, assign) BOOL isSelected;

// 互斥的选项，以英文逗号分割
@property (nonatomic, copy) NSString *strMutex_id;


@property (nonatomic ,copy)NSString *isfill;
@property (nonatomic ,copy)NSString *isforcedfill;
@property (nonatomic ,copy)NSString *jump;
@property (nonatomic ,copy)NSString *jumpquestion;

//@property (nonatomic ,copy)NSString *option_name;

@property (nonatomic ,copy)NSString *option_num;

@property (nonatomic ,copy)NSString *note;//选项备注

@property (nonatomic ,copy)NSString *fillNotes;//填空答案


- (NSArray *)mutexIds;
@end
