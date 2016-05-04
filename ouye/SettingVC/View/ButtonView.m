//
//  ButtonView.m
//  ouye
//
//  Created by Sino on 16/3/23.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import "ButtonView.h"

@interface ButtonView()

@property (weak, nonatomic) IBOutlet UIButton *logoutBtn;

@end

@implementation ButtonView

- (void)awakeFromNib
{
    self.logoutBtn.layer.masksToBounds = YES;
    self.logoutBtn.layer.cornerRadius = 5.0f;
}

- (IBAction)logoutBtnClick:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(logoutBtnClick)]) {
        [self.delegate performSelector:@selector(logoutBtnClick)];
    }
}

@end
