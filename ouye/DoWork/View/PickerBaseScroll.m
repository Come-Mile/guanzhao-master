//
//  PickerBaseScroll.m
//  ouye
//
//  Created by Sino on 16/4/11.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import "PickerBaseScroll.h"
#import "QuestionList.h"
#import "SingleNoteView.h"
#import "PickerAndAddView.h"
#import "DeviderWorkModel.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "PickerModel.h"
#import "QuenstionModel.h"
/**
 *  单备注
 */

@interface PickerBaseScroll()<UINavigationControllerDelegate, UIImagePickerControllerDelegate ,PickerAndAddViewDelegate,UIActionSheetDelegate>

@property (nonatomic ,weak)UILabel *titleLabel;
@property (weak, nonatomic)UIView *lineView;

@property(nonatomic , weak)QuestionList *questionList;

@property (nonatomic ,weak)SingleNoteView *singleView;

@property (nonatomic ,weak)PickerAndAddView *pickerView;

@property (nonatomic , weak)UIButton* addBtn;

@property (nonatomic ,weak)UIButton *sureBtn;

@end

@implementation PickerBaseScroll
{
    CGFloat x;
    CGFloat y;
    int imageCount;
    
    int selectBtn;
    
    int maxPic;
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
//        [self setBackgroundColor:[UIColor colorWithRed:0.800 green:1.000 blue:1.000 alpha:1.000]];
        
    }
    return self;
}

- (void)setPickerModel:(PickerModel *)pickerModel
{
    _pickerModel = pickerModel;
    
    [self setUpDatas];
}
- (void)setUpDatas
{
    [self setUpSubViews];
    self.questionList.questionArray = self.pickerModel.questionArray;
    self.titleLabel.text = self.pickerModel.title;
}
- (void)setUpSubViews
{
    UILabel *labe01 = [[UILabel alloc]init];
    labe01.text = @"任务标题";
    self.titleLabel = labe01;
    [self addSubview:labe01];
    
    UIView *lin = [[UIView alloc]init];
    lin.backgroundColor = [UIColor lightGrayColor];
    self.lineView = lin;
    [self addSubview:lin];
    
    QuestionList *list = [[QuestionList alloc]init];
   
    self.questionList = list;
    list.backgroundColor = [UIColor redColor];
    [self addSubview:list];
    
    SingleNoteView *singleView = [[SingleNoteView alloc]init];
    self.singleView = singleView;
    [self addSubview:singleView];
    

    CGFloat maginX = 20;
    self.titleLabel.frame = CGRectMake(maginX, 10, ScreenW-2*maginX, 21);
    self.lineView.frame = CGRectMake(10, CGRectGetMaxY(self.titleLabel.frame)+8, ScreenW-10, 1);
    CGFloat listH = [QuestionList getHeightWith:self.pickerModel.questionArray];
    self.questionList.frame = CGRectMake(0, CGRectGetMaxY(self.lineView.frame), ScreenW, listH);
    
    self.singleView.frame = CGRectMake(0, CGRectGetMaxY(self.questionList.frame)+8, ScreenW,149);
    
    [self addButton];
    [self setContentSize:CGSizeMake(ScreenW, CGRectGetMaxY(self.sureBtn.frame)+10)];
}



- (void)addButton
{
    maxPic = [self.DeviderItem.num intValue];
    CGFloat marginX = (self.frame.size.width - 3 * IWPhotoH) / (3 + 1);
    x= marginX;
    y= CGRectGetMaxY(self.singleView.frame) +8;
    UIButton *add = [[UIButton alloc]initWithFrame:CGRectMake(x, y, IWPhotoH, IWPhotoH)];
    imageCount =0;
    [add setBackgroundImage:[UIImage imageNamed:@"tianjiazhaopian.png"] forState:UIControlStateNormal];
    [add addTarget:self action:@selector(addImage) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:add];
    self.addBtn = add;
    
    
    UIButton *sure = [UIButton buttonWithType:UIButtonTypeCustom];
    sure.frame = CGRectMake(20, CGRectGetMaxY(self.addBtn.frame)+20, ScreenW - 40, 25*floatScreenH);
    [sure setBackgroundColor:[UIColor colorWithRed:0.400 green:0.600 blue:0.000 alpha:1.000] ];
    [sure setTitle:@"确认" forState:UIControlStateNormal];
    [sure setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sure setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [sure addTarget:self action:@selector(summitBtnHaveClick:) forControlEvents:UIControlEventTouchUpInside];
    self.sureBtn = sure;
    [self addSubview:sure];
 
}
-(void)addImage
{
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:self.addBtn.frame];
    imageView.tag = 800 + imageCount;
    
    imageView.layer.cornerRadius = 5.0;
    imageView.clipsToBounds = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:imageView];
    UIButton * button = [[UIButton alloc]initWithFrame:imageView.frame];
    [button setBackgroundImage:[UIImage imageNamed:@"tianjiazhaopian.png"] forState:UIControlStateNormal];
    button.tag = 1000+imageCount;
    [button addTarget:self action:@selector(setimageView:) forControlEvents:UIControlEventTouchUpInside];
//    [button setTitle:@"点击添加图片" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:12];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self setimageView:button];
    [self addSubview:button];
    button.alpha = 0;
    imageCount ++;
    
     CGFloat marginX = (self.frame.size.width - 3 * IWPhotoH) / (3 + 1);
    [UIView animateWithDuration:0.5 animations:^{
        button.alpha = 1.0;
        if (imageCount < maxPic) {
            CGRect rect = self.addBtn.frame;
            rect.origin.x = marginX +imageCount%3*(IWPhotoH +marginX);
            
            rect.origin.y = y+imageCount/3*(IWPhotoH +marginX) ;
            
            self.addBtn.frame = rect;
        }
        else
        {
            self.addBtn.alpha = 0;
        }
        
    } completion:^(BOOL finished) {
        if (imageCount == maxPic) {
            self.addBtn.hidden = YES;
        }
    }];
    [self setButton];
    
}
-(void)setimageView:(id)sender
{
    UIButton * button = (UIButton*)sender;
    [self endEditing:YES];
    selectBtn =(int) button.tag;
    
    if ([self.DeviderItem.isphoto isEqualToString:@"0"]) {//不可调用相册
        
        [self takePhoto];
    }else{
    
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:nil
                                      delegate:self
                                      cancelButtonTitle:@"取消"
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:@"从手机选择",@"拍照",nil];
        [actionSheet showInView:self];
    }
}


-(void)setButton
{
    if (self.sureBtn.frame.origin.y - self.addBtn.frame.origin.y - 80<=20||self.sureBtn.frame.origin.y + self.sureBtn.frame.size.height > self.frame.size.height) {
        CGRect rect = self.sureBtn.frame;
        rect.origin.y = self.addBtn.frame.origin.y+self.addBtn.frame.size.height +20;
        self.sureBtn.frame = rect;
    }
    
    if (self.sureBtn.frame.origin.y + self.sureBtn.frame.size.height > self.frame.size.height)
    {
        [self setContentSize:CGSizeMake(self.frame.size.width, self.sureBtn.frame.origin.y + self.sureBtn.frame.size.height +10)];
    }
    else
    {
        [self setContentSize:self.frame.size];
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [actionSheet removeFromSuperview];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex ==1) {
        [self takePhoto];
        
    }
    else if (buttonIndex ==0)
    {
        UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            //pickerImage.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            //            pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
            NSString *requiredMediaType1 = ( NSString *)kUTTypeImage;
            
            NSArray *arrMediaTypes=[NSArray arrayWithObjects: requiredMediaType1,nil];
            
            pickerImage.mediaTypes = arrMediaTypes;
        }
        pickerImage.delegate = self;
        
        [self.window.rootViewController presentViewController:pickerImage animated:YES completion:Nil];
    }
}

- (void)takePhoto
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
    
    picker.delegate = self;
    //        picker.allowsEditing = YES;//设置可编辑
    picker.sourceType = sourceType;
    [self.window.rootViewController presentViewController:picker animated:YES completion:Nil];//进入照相界面
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    //    CheckModel * model = [dataArray objectAtIndex:editingNum - 1001];
    //    model.photo =  image;
    
    UIButton* button = (UIButton*)[self viewWithTag:selectBtn];
    [button setTitle:@"" forState:UIControlStateNormal];
    [button setBackgroundImage:nil forState:UIControlStateNormal];
    UIImageView * imageView = (UIImageView *)[self viewWithTag:selectBtn - 200];
    imageView.image = image;
    [picker dismissViewControllerAnimated:YES completion:Nil];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:Nil];
    
}

- (void)summitBtnHaveClick:(UIButton *)sender
{
    /**
     照片
     */
    NSMutableArray * imageArray = [[NSMutableArray alloc]init];
    for (int i = 0; i<imageCount; i++) {
        UIImageView * imageView = (UIImageView *)[self viewWithTag:800+i];
        if (imageView.image) {
            NSData * imageData = UIImageJPEGRepresentation(imageView.image,0.5);
            NSString * imageStr = [imageData base64EncodedStringWithOptions:kNilOptions];
            [imageArray addObject:imageStr];
        }
    }
    
    self.pickerModel.imageArray = imageArray;
    /**
     *  问题答案转化为jason串
     */
    [self dataStrForQuestion];

    self.pickerModel.textStr = self.singleView.textView.text;
    
    MWLog(@"备注：%@",self.pickerModel.textStr);
   
    if ([self.baseDelegate respondsToSelector:@selector(pickerSummitBtnHaveClick:)]) {
        [self.baseDelegate performSelector:@selector(pickerSummitBtnHaveClick:) withObject:sender];
        
    }
}

- (void)dataStrForQuestion
{
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
}
@end
