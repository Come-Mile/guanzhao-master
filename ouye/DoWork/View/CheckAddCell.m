//
//  CheckAddCell.m
//  Research
//
//  Created by pang on 15/2/1.
//  Copyright (c) 2015年 pang. All rights reserved.
//

#import "CheckAddCell.h"

@implementation CheckAddCell

- (void)awakeFromNib {
    // Initialization code
//    UITapGestureRecognizer* singleRecognizer;
//    singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SingleTap:)];
//    //点击的次数
//    singleRecognizer.numberOfTapsRequired = 1;
//    [self addGestureRecognizer:singleRecognizer];
    
}
-(void)SingleTap:(UITapGestureRecognizer*)recognizer
{
    [self endEditing:YES];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(IBAction)add:(id)sender
{
    [self.delegate addImage];
}
@end
