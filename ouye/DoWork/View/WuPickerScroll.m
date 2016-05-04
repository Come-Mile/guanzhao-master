//
//  WuPickerScroll.m
//  ouye
//
//  Created by Sino on 16/4/12.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import "WuPickerScroll.h"
#import "SingleNoteView.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "VideoAddView.h"

#import "DeviderWorkModel.h"
#import "QuestionList.h"
#import "PickerModel.h"
#import "QuenstionModel.h"

@interface WuPickerScroll()<VideoAddImageDelegate>
@property (weak, nonatomic)UILabel *titleLabel;
@property (weak, nonatomic)UIView *devideView;

@property(nonatomic , weak)QuestionList *questionList;

@property (nonatomic ,weak)SingleNoteView *singleView;

@property (nonatomic ,weak)VideoAddView *videoAddView;

@property (nonatomic ,weak)UILabel *desLabel;

@property (nonatomic ,weak)UIButton *sureBtn;


@property (nonatomic ,strong)NSMutableArray *videoData;
@end

@implementation WuPickerScroll

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
//        [self setBackgroundColor:[UIColor colorWithRed:0.800 green:1.000 blue:1.000 alpha:1.000]];
        
        [self setUpSubViews];
    }
    return self;
}

- (NSMutableArray *)videoData
{
    if (_videoData ==nil) {
        _videoData = [NSMutableArray array];
    }
    return _videoData;
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
    
    QuestionList *list = [[QuestionList alloc]init];
    
    self.questionList = list;
    list.backgroundColor = [UIColor redColor];
    [self addSubview:list];
    
    SingleNoteView *singleView = [[SingleNoteView alloc]init];
    self.singleView = singleView;
    [self addSubview:singleView];
    
    VideoAddView *addV = [[VideoAddView alloc]init];
    addV.delegate =self;
    self.videoAddView = addV;
    [self addSubview:addV];
    
    UILabel *label02 = [[UILabel alloc]init];
    label02.text = @"提示：每段视频最大支持3分钟(长按可删除)";
    label02.font = [UIFont systemFontOfSize:15.0f];
    [self addSubview:label02];
    self.desLabel = label02;
    
    UIButton *sure = [UIButton buttonWithType:UIButtonTypeCustom];
    [sure setBackgroundColor:[UIColor colorWithRed:0.400 green:0.600 blue:0.000 alpha:1.000] ];
    [sure setTitle:@"确认" forState:UIControlStateNormal];
    [sure setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sure setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [sure addTarget:self action:@selector(summitBtnHaveClick:) forControlEvents:UIControlEventTouchUpInside];
    self.sureBtn = sure;
    [self addSubview:sure];
}

- (void)setPickerModel:(PickerModel *)pickerModel
{
    _pickerModel = pickerModel;
    
    [self setUpDatas];
}
- (void)setUpDatas
{
    self.questionList.questionArray = self.pickerModel.questionArray;
    self.titleLabel.text = self.pickerModel.title;
    [self layoutSubviews];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat maginX = 20;
    self.titleLabel.frame = CGRectMake(maginX, 10, ScreenW-2*maginX, 21);
    self.devideView.frame = CGRectMake(10, CGRectGetMaxY(self.titleLabel.frame)+8, ScreenW-10, 1);
    
    CGFloat listH = [QuestionList getHeightWith:self.pickerModel.questionArray];
    self.questionList.frame = CGRectMake(0, CGRectGetMaxY(self.devideView.frame), ScreenW, listH);
    
    self.singleView.frame = CGRectMake(0, CGRectGetMaxY(self.questionList.frame)+8, ScreenW,149);
    self.videoAddView.frame = CGRectMake(0, CGRectGetMaxY(self.singleView.frame)+8, ScreenW, 90*floatScreenH);
    self.desLabel.frame = CGRectMake(maginX, CGRectGetMaxY(self.videoAddView.frame)+8, ScreenW - maginX, 21);
    self.sureBtn.frame = CGRectMake(20, CGRectGetMaxY(self.desLabel.frame)+20, ScreenW - 40, 25*floatScreenH);
    
    [self setContentSize:CGSizeMake(ScreenW, CGRectGetMaxY(self.sureBtn.frame)+10)];
}

- (void)VCshouldAddVideoArr:(NSMutableArray *)VideoArray
{
    [self.videoData removeAllObjects];
    self.videoData = [NSMutableArray arrayWithArray:VideoArray];
}
- (void)summitBtnHaveClick:(UIButton *)sender
{
    /**
     视频
     */
    
    self.pickerModel.imageArray = self.videoData;
    /**
     题目
     */
    self.pickerModel.selectStr = [[NSString alloc]init];
    NSMutableArray *answerArray = [NSMutableArray array];
    for (QuenstionModel *model in self.questionList.dataSoure) {
        NSMutableDictionary *questionDic = [[NSMutableDictionary alloc]init];
        NSMutableString *answerStr = [[NSMutableString alloc]init];
        NSMutableString *notes = [[NSMutableString alloc]init];
        
        for (OptionalAnswerModel *option in model.optionalAnswers) {
            if ([model.type isEqualToString:@"1"]||[model.type isEqualToString:@"2"]) {
                if (option.isSelected) {
                    MWLog(@"%@ , %@",option.aid,option.option_num);
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
        self.pickerModel.questionId = model.qid;
        [questionDic setObject:[answerStr removeChactString:@","] forKey:@"answers"];
        [questionDic setObject:model.type forKey:@"question_type"];
        
        if (model.question_num.length >0 && model.question_num !=NULL) {
            [questionDic setObject:model.question_num forKey:@"question_num"];
        }
        
        [questionDic setObject:[notes removeChactString:@","] forKey:@"note"];
        [answerArray addObject:questionDic];
    }
    NSData *jasonData = [NSJSONSerialization dataWithJSONObject:answerArray options:NSJSONWritingPrettyPrinted error:nil];
    NSMutableData *tempJsonData = [NSMutableData dataWithData:jasonData];
    self.pickerModel.selectStr = [[NSString alloc] initWithData:tempJsonData encoding:NSUTF8StringEncoding];
    MWLog(@"上传 JSON:%@",self.pickerModel.selectStr);//jasonData 转化成字符串；
    
    self.pickerModel.textStr = self.singleView.textView.text;
    
    MWLog(@"备注：%@ 视频数组：%@",self.pickerModel.textStr,self.videoData);
    
    if ([self.baseDelegate respondsToSelector:@selector(pickerSummitBtnHaveClick:)]) {
        [self.baseDelegate performSelector:@selector(pickerSummitBtnHaveClick:) withObject:sender];
        
    }
}

@end
