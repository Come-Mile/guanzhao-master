//
//  RecordModel.h
//  ouye
//
//  Created by Sino on 16/4/13.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import "CommentModel.h"
#import "QuenstionModel.h"
@interface RecordModel : CommentModel



@property (nonatomic ,copy)NSString *note;//任务说明
@property (nonatomic ,copy)NSString *questionnaire_type;
@property (nonatomic ,copy)NSString *task_name;


@property (nonatomic ,strong)NSMutableArray *questionArray;

@property (nonatomic ,copy)NSString *questionId;//问题Id
@property (nonatomic ,copy)NSString *selectStr;//问题答案
@end
