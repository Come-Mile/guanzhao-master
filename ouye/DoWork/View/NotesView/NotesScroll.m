//
//  NotesScroll.m
//  ouye
//
//  Created by Sino on 16/4/12.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import "NotesScroll.h"
#import "QuestionList.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "RecordModel.h"
#import "QuenstionModel.h"
#import "CurrrentAppTool.h"

@interface NotesScroll()<QuestionListDelegate>
@property (weak, nonatomic)UILabel *titleLabel;
@property (weak, nonatomic)UIView *devideView;


@property (nonatomic ,weak)UIButton *sureBtn;
@property(nonatomic , weak)QuestionList *questionList;

@property (weak, nonatomic)UILabel *taskNameLabel;
@property (weak, nonatomic)UILabel *detailLabel;


@property (nonatomic, weak)UIView *keyBoardBgView;


/**
 *  单选情况下保存数据的数组
 */
@property (nonatomic ,strong)NSMutableArray *datasForSingle;
@end

@implementation NotesScroll
{
    int currentIndex ;//当前显示的题目题号
}
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUpSubViews];
    }
    return self;
}
- (NSMutableArray *)datasForSingle
{
    if (_datasForSingle ==nil) {
        _datasForSingle = [NSMutableArray array];
    }
    return _datasForSingle;
}

- (void)setUpSubViews
{
    UILabel *labe = [[UILabel alloc]init];
    labe.text = @"北京赛诺营销";
    self.titleLabel = labe;
    [self addSubview:labe];
    
    UIView *lin = [[UIView alloc]init];
    lin.backgroundColor = [UIColor lightGrayColor];
    self.devideView = lin;
    [self addSubview:lin];
    
    UILabel *labe02 = [[UILabel alloc]init];
    labe02.text = @"任务说明：";
    self.taskNameLabel = labe02;
    [self addSubview:labe02];
    
    UILabel *labe03 = [[UILabel alloc]init];
    labe03.numberOfLines = 0;
    
    self.detailLabel = labe03;
    [self addSubview:labe03];
    
    QuestionList *list = [[QuestionList alloc]init];
    list.delegate = self;
    self.questionList = list;
    list.backgroundColor = [UIColor redColor];
    [self addSubview:list];
    
    UIButton *sure = [UIButton buttonWithType:UIButtonTypeCustom];
    [sure setBackgroundColor:[UIColor colorWithRed:0.400 green:0.600 blue:0.000 alpha:1.000] ];
    [sure setTitle:@"确认" forState:UIControlStateNormal];
    [sure setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sure setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
   
    [sure addTarget:self action:@selector(sureBtnHaveClick:) forControlEvents:UIControlEventTouchUpInside];
     self.sureBtn = sure;
    [self addSubview:sure];
    
    [self addKeyBgView];
}
- (void)addKeyBgView
{
    /**
     自定义收起键盘
     */
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillShow:)
     
                                                 name:UIKeyboardWillShowNotification
     
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillHide:)
     
                                                 name:UIKeyboardWillHideNotification
     
                                               object:nil];

}
- (void)keyboardWillShow:(NSNotification *)notification {
    UIView *bg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH )];
    
    bg.backgroundColor = [UIColor clearColor];
    [self.window addSubview:bg];
    self.keyBoardBgView = bg;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
    
    [bg addGestureRecognizer:tap];
}

- (void)tapClick
{
    [self endEditing:YES];
}
- (void)keyboardWillHide:(NSNotification *)notification
{
    [self.keyBoardBgView removeFromSuperview];
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
      
    } completion:^(BOOL finished) {
        
    }];
}


- (void)setRecoItem:(RecordModel *)RecoItem
{
    _RecoItem = RecoItem;
    currentIndex =0;
    [self setUpDatasWith:0];
}
- (void)setUpDatasWith:(int )count
{
    currentIndex = count;
    self.titleLabel.text = self.RecoItem.task_name;
    self.detailLabel.text = self.RecoItem.note;
    if ([self.RecoItem.questionnaire_type isEqualToString:@"2"]) {
    self.questionList.questionArray = self.RecoItem.questionArray;
    }else if([self.RecoItem.questionnaire_type isEqualToString:@"1"]){//单题形式
        self.questionList.questionArray = [NSMutableArray arrayWithObject:self.RecoItem.questionArray[count]];
        [self layoutSubviews];
    }

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat maginX = 20;
    self.titleLabel.frame = CGRectMake(maginX, 10, ScreenW-2*maginX, 21);
    self.devideView.frame = CGRectMake(10, CGRectGetMaxY(self.titleLabel.frame)+8, ScreenW-10, 1);
    self.taskNameLabel.frame = CGRectMake(maginX, CGRectGetMaxY(self.devideView.frame)+8, ScreenW-2*maginX, 21);
    self.detailLabel.frame = CGRectMake(maginX, CGRectGetMaxY(self.taskNameLabel.frame)+8, ScreenW-30, 30);
    self.detailLabel.size = [self.detailLabel boundingRectWithSize:CGSizeMake(ScreenW -30, MAXFLOAT)];
    CGFloat listH =0.0f;
    if([self.RecoItem.questionnaire_type isEqualToString:@"1"]){
       listH  = [QuestionList getHeightWith:[NSMutableArray arrayWithObject:self.RecoItem.questionArray[currentIndex]]];
       
    }else{
        listH  = [QuestionList getHeightWith:self.RecoItem.questionArray];
    }
     self.questionList.frame = CGRectMake(0, CGRectGetMaxY(self.detailLabel.frame)+8, ScreenW, listH);
    self.sureBtn.frame = CGRectMake(20, CGRectGetMaxY(self.questionList.frame)+20, ScreenW - 40, 25*floatScreenH);
    
    [self setContentSize:CGSizeMake(ScreenW, CGRectGetMaxY(self.sureBtn.frame)+10)];
}
- (void)scrollShouldScrollWith:(CGRect)rect
{
    // 建议:尽量使用animateWithDuration, 不要使用animateKeyframesWithDuration
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [self setContentOffset:CGPointMake(rect.origin.x, rect.origin.y)];
    } completion:^(BOOL finished) {
        
    }];
}

//- (void)keyBoardShow:(CGPoint)point
//{
//    // 建议:尽量使用animateWithDuration, 不要使用animateKeyframesWithDuration
//    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
//        [self setContentOffset:point];
//    } completion:^(BOOL finished) {
//        
//    }];
//}

- (void)sureBtnHaveClick:(UIButton *)button
{
    if ([self.RecoItem.questionnaire_type isEqualToString:@"1"]) {
        /**
         *  单题形式
         */
        for (int index =0; index <self.RecoItem.questionArray.count; index++) {
            QuenstionModel *orginModel = self.RecoItem.questionArray[index];
            for ( QuenstionModel *model in self.questionList.dataSoure) {
                if ([model.qid isEqualToString: orginModel.qid]) {
                    [self.RecoItem.questionArray replaceObjectAtIndex:index withObject:model];
                    break;
                }
            }
        }
        for (QuenstionModel *model in self.questionList.dataSoure) {
             MWLog(@"**********单题*************");
            model.isSelected = NO;
            NSString *optionNumQ;
            for (OptionalAnswerModel *option in model.optionalAnswers) {
                if (option.isSelected) {
                    model.isSelected = YES;
                }
                optionNumQ = [self optionTiaoTi:option];
            }
            if (optionNumQ !=nil) {
                if ([optionNumQ intValue] <self.RecoItem.questionArray.count) {
                   [self setUpDatasWith:[optionNumQ intValue]-1];
                }else{
                    [CurrrentAppTool showMessage:[NSString stringWithFormat:@"此选项为必跳选项，题目跳转有误，跳转题的题号:%@ 大于总题目数",optionNumQ]];
                }
            }else{
                if ([model.isrequired isEqualToString:@"0"]) {
                    if (model.isSelected ==NO) {
                        [CurrrentAppTool showMessage:@"该题为必选题"];
                        return;
                    }else{
                        [self tiaoti:model];
                    }
                }else{
                    [self tiaoti:model];
                }
            }
            /**
             *  如果是最后一道题就开始上传
             */
            if ([model.question_num intValue] == self.RecoItem.questionArray.count) {
                MWLog(@"单题开始上传");
                [self dataStrForQuestionWith:self.RecoItem.questionArray];
                /***  上传*/
                [self up];
            }
        }
    }else if ([self.RecoItem.questionnaire_type isEqualToString:@"2"]){
        MWLog(@"多题上传: ");
        NSMutableString *bixuan =[NSMutableString string];//保存必选题的题号
        for (QuenstionModel *model in self.questionList.dataSoure) {
            model.isSelected = NO;
            for (OptionalAnswerModel *option in model.optionalAnswers) {
                if (option.isSelected) {
                    model.isSelected = YES;
                }
            }
            if ([model.isrequired isEqualToString:@"1"]) {
                if (model.isSelected ==NO) {
                    [bixuan appendFormat:@"%@,",model.question_num];
                }
            }
        }
        if (bixuan.length ==0) {
            [self dataStrForQuestionWith:self.questionList.dataSoure];
            [self up];
        }else{
            [CurrrentAppTool showMessage:[NSString stringWithFormat:@"请注意，第%@题为必选题！",[bixuan removeChactString:@","]]];
        }
        MWLog(@"bixuan:%@",bixuan);
    }
}

- (void)tiaoti:(QuenstionModel *)model
{
    //题跳
    if ([model.forced_jump isEqualToString:@"1"]) {
        if([model.jump_question intValue] >0){
            if (model.isSelected) {
                [self setUpDatasWith:[model.jump_question intValue]-1];
            }else{
                [CurrrentAppTool showMessage:[NSString stringWithFormat:@"此题为必跳题，题为非必选题"]];
                [self setUpDatasWith:[model.jump_question intValue]-1];
            }
        }else{
            [CurrrentAppTool showMessage:[NSString stringWithFormat:@"此题为必跳题，题目跳转有误，跳转题的题号:%@",model.jump_question]];
        }
    }else{
        if ([model.question_num intValue] < self.RecoItem.questionArray.count) {
            [self setUpDatasWith:[model.question_num intValue]];//到下一题
        }else{
//            [CurrrentAppTool showMessage:[NSString stringWithFormat:@"跳转到下一题有误，跳转题号:%@",model.question_num]];
        }
    }
}

- (NSString *)optionTiaoTi:(OptionalAnswerModel *)option
{
    //选项跳
    if ([option.jump isEqualToString:@"1"]) {
        if ([option.jumpquestion intValue] >0) {
            if(option.isSelected){
//                [self setUpDatasWith:[option.jumpquestion intValue]-1];
                
                return option.jumpquestion;
            }else{
                return nil;
            }
            
        }else{
            [CurrrentAppTool showMessage:[NSString stringWithFormat:@"此选项为必跳选项，题目跳转有误，跳转题的题号:%@",option.jumpquestion]];
            return nil;
        }
    }else{
        return nil;
    }
 
}
- (void)dataStrForQuestionWith:(NSMutableArray *)array
{
    /**题目*/
    self.RecoItem.selectStr = [[NSString alloc]init];
    NSMutableArray *answerArray = [NSMutableArray array];
    for (QuenstionModel *model in array) {
        NSMutableDictionary *questionDic = [[NSMutableDictionary alloc]init];
        NSMutableString *answerStr = [[NSMutableString alloc]init];
        NSMutableString *notes = [[NSMutableString alloc]init];
        
        for (OptionalAnswerModel *option in model.optionalAnswers) {
            if ([model.type isEqualToString:@"1"]||[model.type isEqualToString:@"2"]) {
                if (option.isSelected) {
                    MWLog(@"选项：%@ , %@",option.aid,option.option_num);
                    [answerStr appendString:MWSTRFormat(@",", option.aid)];
#warning 选项备注？？？？？？
                    [notes appendString:MWSTRFormat(@",", @" ")];
                }
            }else if([model.type isEqualToString:@"3"]){//判断
                if (option.isSelected) {
                    [answerStr appendString:option.aid];
#warning 选项备注？？？？？？
                    [notes appendString:MWSTRFormat(@",", @" ")];
                }
            }else if([model.type isEqualToString:@"4"]){
                [answerStr appendString:option.fillNotes];
            }
        }
        [questionDic setObject:model.qid forKey:@"question_id"];
        self.RecoItem.questionId = model.qid;
        [questionDic setObject:[answerStr removeChactString:@","] forKey:@"answers"];
        [questionDic setObject:model.type forKey:@"question_type"];
        
        if (model.question_num.length >0 && model.question_num !=NULL) {
            [questionDic setObject:model.question_num forKey:@"question_num"];
        }
        
        [questionDic setObject:[notes removeChactString:@","] forKey:@"note"];
        [answerArray addObject:questionDic];
    }
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:answerArray,@"answers", nil];
    NSData *jasonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSMutableData *tempJsonData = [NSMutableData dataWithData:jasonData];
    self.RecoItem.selectStr = [[NSString alloc] initWithData:tempJsonData encoding:NSUTF8StringEncoding];
    MWLog(@"上传 JSON:%@",self.RecoItem.selectStr);//jasonData 转化成字符串；
}

- (void)up
{
    if ([self.baseDelegate respondsToSelector:@selector(summitBtnHaveClick:)]) {
        [self.baseDelegate performSelector:@selector(summitBtnHaveClick:) withObject:nil];
    }
}
@end
