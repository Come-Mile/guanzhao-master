//
//  QuestionList.m
//  ouye
//
//  Created by Sino on 16/4/11.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import "QuestionList.h"
#import "ListTableCell.h"
#import "FillNoteCell.h"
#import "QuenstionModel.h"

@interface QuestionList()<UITableViewDelegate , UITableViewDataSource ,UITextViewDelegate>

@property (nonatomic , weak)UITableView *listTab;
@end

@implementation QuestionList

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
       
        
        [self setUpTabViewWith:frame];
        
      
    }
    return self;
}
- (void)setUpTabViewWith:(CGRect )frame
{
    UITableView *tab = [[UITableView alloc]initWithFrame:frame style:UITableViewStylePlain];
    
    tab.delegate =self;
    tab.dataSource = self;
    tab.scrollEnabled = NO;
    [self addSubview:tab];
    self.listTab = tab;
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.listTab.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

//去掉 UItableview headerview 黏性(sticky)
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _listTab)
    {
        CGFloat sectionHeaderHeight =44.0; //sectionHeaderHeight
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}

- (void)setQuestionArray:(NSMutableArray *)questionArray
{
    _questionArray = [questionArray copy];
    [self setUpDatas];
    [self.listTab reloadData];
}

- (void)setUpDatas
{
    [self.dataSoure removeAllObjects];
    if (self.questionArray.count !=0) {
        for (QuenstionModel *model in self.questionArray) {
            
            for (OptionalAnswerModel *option in model.optionalAnswers ) {
                 MWLog(@"互斥：%@",option.strMutex_id);
            }
            if([model.type isEqualToString:@"2"]){
//                for (OptionalAnswerModel *optionModel in model.optionalAnswers) {
//                    
//                }
                
            }else if([model.type isEqualToString:@"3"]){//判断
                for (NSInteger i= 0; i<2; i++) {
                    OptionalAnswerModel *answerModel = [[OptionalAnswerModel alloc]init];
                    answerModel.aid = [NSString stringWithFormat:@"%ld",i];
                    answerModel.optionalAnswerSummary = [NSString stringWithFormat:@"%c.%@",(char)('A' +i),i==0?@"错":@"对"];
                    
                    answerModel.isSelected = NO;
                    [model.optionalAnswers addObject:answerModel];
                }
            }else if([model.type isEqualToString:@"4"]){
                OptionalAnswerModel *answerModel = [[OptionalAnswerModel alloc]init];
                answerModel.fillNotes = @"";
                [model.optionalAnswers addObject:answerModel];
            }
            [self.dataSoure addObject:model];
        }
    }
}
- (void)getSubData
{
    for (NSUInteger section =0; section <4; section ++) {
        QuenstionModel *quenstionModel = [[QuenstionModel alloc]init];
        quenstionModel.questionSummary = [NSString stringWithFormat:@"这是第%ld题",section];
        quenstionModel.question_num = [NSString stringWithFormat:@"%ld",section +1];
        if(section ==0 ){
//            quenstionModel.jumpStr = @"1";
        }
        
        if (section == 3) {
            quenstionModel.type = @"填空";
        }
        for (NSUInteger row =0; row<4; row ++) {
            OptionalAnswerModel *answerModel = [[OptionalAnswerModel alloc]init];
            
            answerModel.aid = [NSString stringWithFormat:@"%ld",row+1];
            answerModel.optionalAnswerSummary = [NSString stringWithFormat:@"%c.可选答案%ld",(char)('A' +row),row +1];
            
            answerModel.isSelected = NO;
            [quenstionModel.optionalAnswers addObject:answerModel];
        }
        // 分配互斥A与B互斥、C与D互斥的情况
        OptionalAnswerModel *modelA = [quenstionModel.optionalAnswers objectAtIndex:0];
        modelA.strMutex_id = @"4";
        OptionalAnswerModel *modelB = [quenstionModel.optionalAnswers objectAtIndex:1];
        modelB.strMutex_id = @"4";
        OptionalAnswerModel *modelC = [quenstionModel.optionalAnswers objectAtIndex:2];
        modelC.strMutex_id = @"4";
        OptionalAnswerModel *modelD = [quenstionModel.optionalAnswers objectAtIndex:3];
        modelD.strMutex_id = @"1,2,3";
        
        [self.dataSoure addObject:quenstionModel];
    }
}

- (NSMutableArray *)dataSoure
{
    if (_dataSoure ==nil) {
        _dataSoure = [NSMutableArray array];
    }
    
    return _dataSoure;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QuenstionModel *model = self.dataSoure[indexPath.section];
    if ([model.type isEqualToString:@"4"]) {
        OptionalAnswerModel *anwerModel = model.optionalAnswers[indexPath.row];
        FillNoteCell *cell = [FillNoteCell cellWithTableView:tableView ];
        cell.fillTextView.delegate =self;
        [cell configCellWithModel:anwerModel atIndexPath:indexPath];
        
        return cell;
    }else{
        OptionalAnswerModel *anwerModel = model.optionalAnswers[indexPath.row];
        ListTableCell *cell = [ListTableCell cellWithTableView:tableView];
        
     
        [cell configCellWithModel:anwerModel atIndexPath:indexPath];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self endEditing:YES];
    QuenstionModel *model = self.dataSoure[indexPath.section];
    OptionalAnswerModel *anwerModel = model.optionalAnswers[indexPath.row];
    anwerModel.isSelected = !anwerModel.isSelected;
    //单选或者判断
    if ([model.type isEqualToString:@"1"] || [model.type isEqualToString:@"3"]) {
        for (OptionalAnswerModel *otherAnswerModel in model.optionalAnswers) {
            if (otherAnswerModel != anwerModel && otherAnswerModel.isSelected) {
                otherAnswerModel.isSelected = !anwerModel.isSelected;
            }
        }
    }
    //后台配置的互斥选项
    if (anwerModel.isSelected) {
        for (OptionalAnswerModel *otherAnswerModel in model.optionalAnswers) {
            if (otherAnswerModel != anwerModel &&[anwerModel.mutexIds containsObject:otherAnswerModel.option_num]) {
                otherAnswerModel.isSelected = !anwerModel.isSelected;
            }
        }
    }
   
    [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
   if ([model.type isEqualToString:@"1"] || [model.type isEqualToString:@"3"]) {
       //题跳
       if ([model.forced_jump isEqualToString:@"1"]) {
           if (model.jump_question.length>0) {
               NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:[model.jump_question integerValue]-1];
               [self fitScroll:index];
               MWLog(@"题跳：%ld ",[model.jump_question integerValue]);
           }
       }
       //选择项跳
       if ([anwerModel.jump isEqualToString:@"1"]) {
           if (anwerModel.jumpquestion.length >0) {
               NSIndexPath *index = [NSIndexPath indexPathForRow:1 inSection:[anwerModel.jumpquestion integerValue]-1];
               [self fitScroll:index];
               MWLog(@"选项跳：%ld ",[anwerModel.jumpquestion integerValue]);
           }
       }
   }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
     QuenstionModel *model = [self.dataSoure objectAtIndex:indexPath.section];
    if ([model.type isEqualToString:@"4"]) {
        return textViewH;
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"headerIdentifeir"];
    UILabel *questionLabel = nil;
    
    if (view == nil) {
        view = [[UIView alloc] initWithFrame:CGRectMake(10, 0, self.frame.size.width-10, 44)];

        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(10, 0, self.frame.size.width-20, 44)];
        bgView.backgroundColor = [UIColor colorWithWhite:0.800 alpha:0.691];
        
        [view addSubview:bgView];
        
        questionLabel = [[UILabel alloc] init];
        questionLabel.frame = CGRectMake(10, 0, view.frame.size.width - 30, 44);
        questionLabel.numberOfLines = 0;
        [bgView addSubview:questionLabel];
        questionLabel.tag = 100;
    }
    
    if (questionLabel == nil) {
        questionLabel = [view viewWithTag:100];
    }
    
    QuenstionModel *model = [self.dataSoure objectAtIndex:section];
    questionLabel.text = model.questionSummary;
    
    return view;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSoure.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    QuenstionModel *model = [self.dataSoure objectAtIndex:section];
    if ([model.type isEqualToString:@"4"]) {
        return 1;
    }
    return model.optionalAnswers.count;
}

+(CGFloat )getHeightWith:(NSMutableArray *)array
{
    CGFloat  height =0.0f;
    if (array.count !=0) {
        for (QuenstionModel *model in array) {
            height +=44;
            if ([model.type isEqualToString:@"3"]) {
                height += 2*44;
            }else if([model.type isEqualToString:@"4"]){
                height += textViewH;
            }else{
                height += model.optionalAnswers.count *44;
            }
        }
    }
    return height;
}
/**
 *  计算当前题目在lis中与屏幕中的相对位置
 */
- (void)fitScroll:(NSIndexPath *)index
{
    //获取当前cell在tableview中的位置
    CGRect rectintableview=[self.listTab rectForRowAtIndexPath:index];
    //获取当前cell在屏幕中的位置
    CGRect rectinsuperview = [self.listTab convertRect:rectintableview fromView:[self.listTab superview]];
    if ([self.delegate respondsToSelector:@selector(scrollShouldScrollWith:)]) {
        [self.delegate scrollShouldScrollWith:rectinsuperview];
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    //获取cell所在的indexpath
    NSIndexPath *indexpath=[self.listTab indexPathForCell:((FillNoteCell *)textView.superview.superview) ];
    [self fitScroll:indexpath];
//    //获取当前cell在tableview中的位置
//    
//    CGRect rectintableview=[self.listTab rectForRowAtIndexPath:indexpath];
//    
//    //获取当前cell在屏幕中的位置
    
//    CGRect rectinsuperview=[self.listTab convertRect:rectintableview fromView:[self.listTab superview]];

//    if ((rectintableview.origin.y+60-self.listTab.contentOffset.y) > 200) {
//   
//        if ([self.delegate respondsToSelector:@selector(keyBoardShow:)]) {
//            [self.delegate keyBoardShow:CGPointMake(self.listTab.contentOffset.x,((rectintableview.origin.y-self.listTab.contentOffset.y)-160)+self.listTab.contentOffset.y)];
//        }
//    }
    
  
}
- (void)textViewDidChange:(UITextView *)textView
{
    //获取cell所在的indexpath
    NSIndexPath *indexpath=[self.listTab indexPathForCell:((FillNoteCell *)textView.superview.superview) ];
    QuenstionModel *model = self.dataSoure[indexpath.section];
    OptionalAnswerModel *anwerModel = model.optionalAnswers[indexpath.row];
    anwerModel.fillNotes = textView.text;
    
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

@end
