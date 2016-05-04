//
//  ManyNoteScroll.m
//  ouye
//
//  Created by Sino on 16/4/12.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import "ManyNoteScroll.h"
#import "QuestionList.h"
#import "CheckModel.h"
#import "CheckMaterialCell.h"
#import "CheckAddCell.h"
#import "DeviderWorkModel.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "PickerModel.h"
#import "QuenstionModel.h"
/**
 *  单备注
 */

@interface ManyNoteScroll()<UINavigationControllerDelegate, UIImagePickerControllerDelegate ,UIActionSheetDelegate ,CheckMaterialCellDelegate , UITextViewDelegate,CheckAddCellDelegate,UIScrollViewDelegate>

@property (nonatomic ,weak)UILabel *titleLabel;
@property (weak, nonatomic)UIView *lineView;

@property(nonatomic , weak)QuestionList *questionList;



@property (nonatomic , weak)CheckAddCell* addView;
@property (nonatomic ,strong)NSMutableArray *dataArray;

@property (nonatomic ,weak)UIButton *sureBtn;

@end

@implementation ManyNoteScroll
{
    CGFloat x;
    CGFloat y;
    int editingNum;
    float lastHight;
    CGPoint wPiont;
    
    int maxPic;//最大拍摄数量
}
- (NSMutableArray *)dataArray
{
    if (_dataArray ==nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
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
    
    CGFloat maginX = 20;
    self.titleLabel.frame = CGRectMake(maginX, 10, ScreenW-2*maginX, 21);
    self.lineView.frame = CGRectMake(10, CGRectGetMaxY(self.titleLabel.frame)+8, ScreenW-10, 1);
    CGFloat listH = [QuestionList getHeightWith:self.pickerModel.questionArray];
    self.questionList.frame = CGRectMake(0, CGRectGetMaxY(self.lineView.frame), ScreenW, listH);
    
    [self setAddImageView];
   
    [self setContentSize:CGSizeMake(ScreenW, CGRectGetMaxY(self.sureBtn.frame)+10)];
   
//    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardWillHideNotification object:nil];
}

//- (void) keyboardWasHidden:(NSNotification *) notif
//{
//    [self setContentOffset:wPiont];
//
//}

-(void)setAddImageView
{
    maxPic = [self.DeviderItem.num intValue];
    CGFloat marginX = (self.frame.size.width - 3 * IWPhotoH) / (3 + 1);
    x= marginX;
    y= CGRectGetMaxY(self.questionList.frame) +8;
    
    CheckAddCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"CheckAddCell" owner:Nil options:Nil]objectAtIndex:0];
    cell.frame = CGRectMake(0, y, ScreenW, 88);
    [self addSubview:cell];
    cell.delegate = self;
    cell.tag = 1000;
    self.addView = cell;
    
    UIButton *sure = [UIButton buttonWithType:UIButtonTypeCustom];
    sure.frame = CGRectMake(20, CGRectGetMaxY(self.addView.frame)+20, ScreenW - 40, 25*floatScreenH);
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
    CheckModel * model = [[CheckModel alloc]init];
    [self.dataArray addObject:model];
    
    CheckMaterialCell *  cell = [[[NSBundle mainBundle]loadNibNamed:@"CheckMaterialCell" owner:Nil options:Nil]objectAtIndex:0];
    if (self.dataArray.count == 1) {
        MWLog(@"y==%f",y);
        cell.frame = CGRectMake(0, y+98*([self.dataArray count]-1), ScreenW, 88);
    }
    else
    {
        UIView * view = [self viewWithTag:[self.dataArray count] - 1+1000];
        cell.frame = CGRectMake(0, view.frame.size.height + view.frame.origin.y+10, self.frame.size.width, 88);
    }
    
    cell.delegate = self;
    cell.tag = 1000+self.dataArray.count;
    cell.explain.tag = cell.tag;
    cell.alpha = 0;
    cell.explain.delegate  = self;
    [self addSubview:cell];
    [self setimage:(int)cell.tag];
    
    CGRect rect = self.addView.frame;
    if ([self.dataArray count] == maxPic) {
        self.addView.hidden = YES;
    }else
    {
        rect.origin.y = cell.frame.size.height + cell.frame.origin.y + 10;
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        self.addView.frame = rect;
        cell.alpha = 1.0;
    }];
    [self setScrollViewContentSize];
}

-(void)setScrollViewContentSize
{
    CGRect rect = self.addView.frame;
    if (rect.origin.y + rect.size.height + 30 > self.sureBtn.frame.origin.y||self.contentSize.height >self.frame.size.height) {
        CGRect rect1 = self.sureBtn.frame;
        rect1.origin.y = rect.origin.y + rect.size.height + 30;
        self.sureBtn.frame = rect1;
        
        self.contentSize = CGSizeMake(self.frame.size.width, self.sureBtn.frame.origin.y + 40);
        
    }
}

#pragma mark 选择从手机选择还是拍照
-(void)setimage:(int)tag
{
    [self endEditing:YES];
    editingNum = tag;
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
        //        pickerImage.allowsEditing = YES;
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

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self endEditing:YES];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    CheckModel * model = [self.dataArray objectAtIndex:editingNum - 1001];
    model.photo =  image;
    
    
    CheckMaterialCell * cell = (CheckMaterialCell*)[self viewWithTag:editingNum];
    cell.checkBtn.image = image;
    [cell.promptLabel setTitle:@"" forState:UIControlStateNormal];
    //    model.haveImage = YES;
    //
    //    CheckMaterialCell * cell =(CheckMaterialCell *) [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:editingNum]];
    //    [cell.checkBtn setImage:image];
    //
    //    [self.tableView reloadData];
    
    [picker dismissViewControllerAnimated:YES completion:Nil];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:Nil];
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
//    [textView setContentOffset:CGPointMake(textView.contentOffset.x, 10)];
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    wPiont = self.contentOffset;
//    UIView * view = [self viewWithTag:textView.tag];
//    [self fitKeyBoard:view];
}
-(void)textViewDidChange:(UITextView *)textView
{
    CheckModel * model = [self.dataArray objectAtIndex:textView.tag-1000-1];
    model.explain = textView.text;
    CGSize size =  [self boundingRectWithSize:CGSizeMake(textView.frame.size.width-10, 0) String:textView.text font:textView.font];
//    [textView setContentOffset:CGPointMake(textView.contentOffset.x, 10)];
    if (lastHight == (float)size.height)
    {
        return;
    }
    if (size.height>40) {
        
        UIView * view = [self viewWithTag:textView.tag];
        CGRect frame2 = view.frame;
        frame2.size.height = 40+size.height;
        [view setFrame:frame2];
//        [self aaa:(int)textView.tag+1];
    }
    else
    {
        UIView * view = [self viewWithTag:textView.tag];
        CGRect frame2 = view.frame;
        frame2.size.height = 88;
        [view setFrame:frame2];
//        [self aaa:(int)textView.tag+1 ];
    }
//    UIView * view = [self viewWithTag:textView.tag];
//    [self fitKeyBoard:view];
    lastHight = size.height;
    
}

-(void)aaa:(int)t
{    int i = t;
    for ( i = t; i< [self.dataArray count]+1000+1; i++) {
        UIView * view1 = [self viewWithTag:i-1];
        UIView * view = [self viewWithTag:i];
        CGRect frame2 = view.frame;
        frame2.origin.y = view1.frame.size.height + view1.frame.origin.y+10;
        [view setFrame:frame2];
    }
    UIView * view1 = [self viewWithTag:1000+self.dataArray.count];
    UIView * view = [self viewWithTag:1000];
    CGRect frame2 = view.frame;
    if ((int)[self.dataArray count]!= maxPic) {
        frame2.origin.y = view1.frame.size.height + view1.frame.origin.y+10;
    }
    else{
        frame2 = view1.frame;
    }
    [view setFrame:frame2];
    [self setScrollViewContentSize];
}

-(void)fitKeyBoard:(UIView *)view
{
    CGPoint point  = [view convertPoint:CGPointZero toView:self];
    float  higth = self.frame.size.height - point.y - view.frame.size.height;
    if (higth< 265) {
        [self setContentOffset:CGPointMake(0, self.contentOffset.y+265-higth +10)];
    }
    
}
- (CGSize)boundingRectWithSize:(CGSize)size String:(NSString *)string font:(UIFont*)font
{
    NSDictionary *attribute = @{NSFontAttributeName: font};
    
    CGSize retSize = [string boundingRectWithSize:size
                                          options:
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                       attributes:attribute
                                          context:nil].size;
    return retSize;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self endEditing:YES];
}

- (void)summitBtnHaveClick:(UIButton *)sender
{
    /**
     *  问题答案转化为jason串
     */
    [self dataStrForQuestion];
    
    NSMutableArray * imageArray = [[NSMutableArray alloc]init];
    NSMutableArray * textArray = [[NSMutableArray alloc]init];
    for (int i = 0; i<[self.dataArray count]; i++) {
        
        CheckModel * model = [self.dataArray objectAtIndex:i];
        if (model.photo) {
            NSData * imageData = UIImageJPEGRepresentation(model.photo,0.5);
            NSString * imageStr = [imageData base64EncodedStringWithOptions:kNilOptions];
            [imageArray addObject:imageStr];
            if (model.explain) {
                [textArray addObject:model.explain];
            }
            else
            {
                [textArray addObject:@""];
            }
            
        }
    }
    
    self.pickerModel.imageArray = imageArray;
    self.pickerModel.textArray = textArray;
//    MWLog(@"照片：%@， 备注：%@",imageArray, textArray);
    
    if ([self.baseDelegate respondsToSelector:@selector(manyPickerSummitBtnHaveClick:)]) {
        [self.baseDelegate performSelector:@selector(manyPickerSummitBtnHaveClick:) withObject:sender];
        
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

