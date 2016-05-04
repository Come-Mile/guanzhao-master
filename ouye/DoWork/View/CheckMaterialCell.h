//
//  CheckMaterialCell.h
//  Research
//
//  Created by pang on 15/1/31.
//  Copyright (c) 2015年 pang. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "CheckModel.h"
#import "IWTextView.h"
@protocol  CheckMaterialCellDelegate<NSObject>

-(void)setimage:(int)tag;
-(void)addImage;

@end
@interface CheckMaterialCell : UITableViewCell<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    IBOutlet UIImageView * imageView1;
}
@property(nonatomic,strong)CheckModel * check;
@property(nonatomic,strong)IBOutlet UIImageView * checkBtn;
@property(nonatomic,strong)IBOutlet IWTextView * explain;
@property(nonatomic,strong) IBOutlet UIButton * promptLabel;
@property(nonatomic,strong)id <CheckMaterialCellDelegate> delegate;
@end
