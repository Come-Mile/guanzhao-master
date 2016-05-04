//
//  HeadView.m
//  ouye
//
//  Created by Sino on 16/4/7.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import "HeadView.h"
#import "WorkListModel.h"
#import "PresentView.h"

@interface HeadView()<PresentViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *headBtn;
@property (weak, nonatomic) IBOutlet UISwitch *switchBtn;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@end

@implementation HeadView

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        
    }
    return self;
}


- (void)setItem:(WorkListModel *)item
{
    _item = item;
    
    [self setUpData];
}

- (void)setUpData
{
    self.headBtn.tag = self.item.indexPath.section;
    self.titleLabel.text = self.item.task_name;
    
    if (self.item.isClose) {
        if (self.item.isClose ==0) {
            self.switchBtn.on = NO;
        }else{
            self.switchBtn.on = YES;
        }
    }
    
}
- (IBAction)headBtnClick:(UIButton *)sender {
    
    MWLog(@"isOpen:%d",self.item.isOpen);
  
    
    if ([self.delegate respondsToSelector:@selector(HeadBtnHaveClickWith:)]) {
        [self.delegate performSelector:@selector(HeadBtnHaveClickWith:) withObject:sender];
       
    }
    
}
- (IBAction)switchBtnClick:(UISwitch *)sender {
    PresentView *view =  [[[NSBundle mainBundle]loadNibNamed:@"PresentView" owner:nil options:nil]lastObject];
    view.delegate = self;
    [view show];
    
//    if ([self.delegate respondsToSelector:@selector(switchBtnHaveClickWith:)]) {
//        
//        [self.delegate performSelector:@selector(switchBtnHaveClickWith:) withObject:sender];
//    }
}

- (void)presentViewCloseBtnClick
{
    self.switchBtn.on = !self.switchBtn.on;
}

- (void)sureBtnHaveClick
{
    self.item.isClose = !self.item.isClose;
}
@end
