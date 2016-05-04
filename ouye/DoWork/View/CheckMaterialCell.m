//
//  CheckMaterialCell.m
//  Research
//
//  Created by pang on 15/1/31.
//  Copyright (c) 2015年 pang. All rights reserved.
//

#import "CheckMaterialCell.h"

@implementation CheckMaterialCell

- (void)awakeFromNib {
    self.checkBtn.layer.cornerRadius = 5.0;
    self.checkBtn.clipsToBounds = YES;
    self.checkBtn.contentMode = UIViewContentModeScaleAspectFill;
//    [self.explain setContentInset:UIEdgeInsetsMake(-10, 0, 0, 0)];
    UIImage *image = [UIImage imageNamed:@"shuoming.png"];
    image = [image stretchableImageWithLeftCapWidth:floorf(image.size.width/2) topCapHeight:floorf(image.size.height/2)];
    imageView1.image = image;
    
    // 1.添加textView
    self.explain.font = [UIFont systemFontOfSize:15];
    self.explain.frame = self.explain.bounds;
    // 垂直方向上永远可以拖拽
    self.explain.alwaysBounceVertical = YES;
    self.explain.placeholder = @"请输入照片备注...";
    self.explain.backgroundColor = [UIColor colorWithWhite:0.600 alpha:0.4];
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(IBAction)showActionSheet {
    
    [self.delegate  setimage:(int)self.tag];
    
}




@end
