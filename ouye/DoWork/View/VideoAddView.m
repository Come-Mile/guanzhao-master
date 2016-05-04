//
//  VideoAddView.m
//  ouye
//
//  Created by Sino on 16/4/8.
//  Copyright © 2016年 夏明伟. All rights reserved.
//
//#define imageW 120 // 图片宽度
#define kMaxColumn 3 // 每行显示数量
#define MaxImageCount 3 // 最多显示图片个数
#define deleImageWH 25 // 删除按钮的宽高
#define kAdeleImage @"jiahao.png" // 删除按钮图片
#define kAddImage @"jiahao.png" // 添加按钮图片
#define kAddBackImage @"shiping.png"


#import "VideoAddView.h"
@interface VideoAddView()<UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIAlertViewDelegate ,UIActionSheetDelegate>
{
    // 标识被编辑的按钮 -1 为添加新的按钮
    NSInteger editTag;
}
@end

@implementation VideoAddView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIButton *btn = [self createButtonWithImage:kAddBackImage andSeletor:@selector(addNew:)];
        
        [self addSubview:btn];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        UIButton *btn = [self createButtonWithImage:kAddBackImage andSeletor:@selector(addNew:)];
        
        [self addSubview:btn];
    }
    return self;
}

-(NSMutableArray *)images
{
    if (_images == nil) {
        _images = [NSMutableArray array];
    }
    return _images;
}

// 添加新的控件
- (void)addNew:(UIButton *)btn
{
    // 标识为添加一个新的图片
    
    if (![self deleClose:btn]) {
        editTag = -1;
        [self callImagePicker];
    }
    
}

// 修改旧的控件
- (void)changeOld:(UIButton *)btn
{
    // 标识为修改(tag为修改标识)
    if (![self deleClose:btn]) {
        editTag = btn.tag;
        //        [self callImagePicker];
        
        MPMoviePlayerViewController* playerView = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:[NSString stringWithFormat:@"file://localhost/private%@", self.images[btn.tag -1]]]];
        //        NSLog(@"%@",[NSString stringWithFormat:@"file://localhost/private%@", currModel.videoURL]);
        //  [self presentModalViewController:playerView animated:YES];
        
        [self.window.rootViewController presentViewController:playerView animated:YES completion:nil];
        
    }
}

// 删除"删除按钮"
- (BOOL)deleClose:(UIButton *)btn
{
    if (btn.subviews.count == 2) {
        [[btn.subviews lastObject] removeFromSuperview];
        //        [self stop:btn];
        return YES;
    }
    return NO;
}
// 调用图片选择器
- (void)callImagePicker
{
    /*从相机选择
     UIActionSheet *actionSheet = [[UIActionSheet alloc]
     initWithTitle:nil
     delegate:self
     cancelButtonTitle:@"取消"
     destructiveButtonTitle:nil
     otherButtonTitles:@"从手机选择",@"拍摄",nil];
     [actionSheet showInView:self.window.rootViewController.view];
     */
    
    
    UIImagePickerController* pickerView = [[UIImagePickerController alloc] init];
    pickerView.sourceType = UIImagePickerControllerSourceTypeCamera;
    NSArray* availableMedia = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
    pickerView.mediaTypes = [NSArray arrayWithObject:availableMedia[1]];
    pickerView.videoMaximumDuration = 180.0f;
    pickerView.delegate = self;
    [self.window.rootViewController presentViewController:pickerView animated:YES completion:nil];
    
    
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {//相册
        
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        //        imagePicker.allowsEditing = YES;
        imagePicker.videoQuality = UIImagePickerControllerQualityTypeMedium;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        // 设置所支持的类型，设置只能拍照，或则只能录像，或者两者都可以
        //        NSString *requiredMediaType = ( NSString *)kUTTypeImage;
        NSString *requiredMediaType2 = (NSString *)kUTTypeMovie;
        //        NSString *requiredMediaType3 = (NSString *)kUTTypeQuickTimeMovie;
        
        NSArray *arrMediaTypes=[NSArray arrayWithObjects:requiredMediaType2, nil];
        imagePicker.mediaTypes = arrMediaTypes;
        [self.window.rootViewController presentViewController:imagePicker animated:YES completion:nil];
    }else if(buttonIndex == 1){// 相机
        UIImagePickerController* pickerView = [[UIImagePickerController alloc] init];
        pickerView.sourceType = UIImagePickerControllerSourceTypeCamera;
        NSArray* availableMedia = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        pickerView.mediaTypes = [NSArray arrayWithObject:availableMedia[1]];
        pickerView.videoMaximumDuration = 180.0f;
        pickerView.delegate = self;
        pickerView.videoQuality = UIImagePickerControllerQualityTypeMedium;
        [self.window.rootViewController presentViewController:pickerView animated:YES completion:nil];
    }
}


/**
 *  调用ALAsseet 判断是相片还是视频
 */
- (void)getVideoFromAlAsset
{
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc]init];//生成整个photolibrary句柄的实例
    NSMutableArray *mediaArray = [[NSMutableArray alloc]init];//存放media的数组
    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {//获取所有group
        [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {//从group里面
            NSString* assetType = [result valueForProperty:ALAssetPropertyType];
            if ([assetType isEqualToString:ALAssetTypePhoto]) {
                NSLog(@"Photo");
            }else if([assetType isEqualToString:ALAssetTypeVideo]){
                NSLog(@"Video");
            }else if([assetType isEqualToString:ALAssetTypeUnknown]){
                NSLog(@"Unknow AssetType");
            }
            
            NSDictionary *assetUrls = [result valueForProperty:ALAssetPropertyURLs];
            NSUInteger assetCounter = 0;
            for (NSString *assetURLKey in assetUrls) {
                NSLog(@"Asset URL %lu = %@",(unsigned long)assetCounter,[assetUrls objectForKey:assetURLKey]);
            }
            
            NSLog(@"Representation Size = %lld",[[result defaultRepresentation]size]);
        }];
    } failureBlock:^(NSError *error) {
        NSLog(@"Enumerate the asset groups failed.");
    }];
}


// 根据图片名称或者图片创建一个新的显示控件
- (UIButton *)createButtonWithImage:(id)imageNameOrImage andSeletor : (SEL)selector
{
    UIImage *addImage = nil;
    if ([imageNameOrImage isKindOfClass:[NSString class]]) {
        addImage = [UIImage imageNamed:imageNameOrImage];
    }
    else if([imageNameOrImage isKindOfClass:[UIImage class]])
    {
        addImage = imageNameOrImage;
    }
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [addBtn setImage:addImage forState:UIControlStateNormal];
    [addBtn setBackgroundImage:addImage forState:UIControlStateNormal];
    
    [addBtn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    addBtn.tag = self.subviews.count;
    
    // 添加长按手势,用作删除.加号按钮不添加
    if(addBtn.tag != 0)
    {
        UILongPressGestureRecognizer *gester = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        [addBtn addGestureRecognizer:gester];
    }
    return addBtn;
    
}

// 长按添加删除按钮
- (void)longPress : (UIGestureRecognizer *)gester
{
    if (gester.state == UIGestureRecognizerStateBegan)
    {
        UIButton *btn = (UIButton *)gester.view;
        
        //添加右上角删除按钮
        UIButton *dele = [UIButton buttonWithType:UIButtonTypeCustom];
        dele.bounds = CGRectMake(0, 0, deleImageWH, deleImageWH);
        [dele setImage:[UIImage imageNamed:kAdeleImage] forState:UIControlStateNormal];
        //        [dele addTarget:self action:@selector(deletePic:) forControlEvents:UIControlEventTouchUpInside];
        dele.tag = btn.tag +100;
        
        dele.frame = CGRectMake(btn.frame.size.width - dele.frame.size.width, 0, dele.frame.size.width, dele.frame.size.height);
        [self deletePic:dele];
        [btn addSubview:dele];
        dele.hidden = YES;
        //        [self start : btn];
    }
}
/*
 // 长按开始抖动
 - (void)start : (UIButton *)btn {
 double angle1 = -5.0 / 180.0 * M_PI;
 double angle2 = 5.0 / 180.0 * M_PI;
 CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
 anim.keyPath = @"transform.rotation";
 
 anim.values = @[@(angle1),  @(angle2), @(angle1)];
 anim.duration = 0.25;
 // 动画的重复执行次数
 anim.repeatCount = MAXFLOAT;
 
 // 保持动画执行完毕后的状态
 anim.removedOnCompletion = NO;
 anim.fillMode = kCAFillModeForwards;
 
 [btn.layer addAnimation:anim forKey:@"shake"];
 }
 
 // 停止抖动
 - (void)stop : (UIButton *)btn{
 [btn.layer removeAnimationForKey:@"shake"];
 }
 */
// 删除视频
- (void)deletePic : (UIButton *)btn
{
    //   [self.images removeObject:[(UIButton *)btn.superview imageForState:UIControlStateNormal]];
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"确认删除？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    [alert show];
    deleBtnTag = (int)btn.tag;
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex ==1) {
        [self.images removeObjectAtIndex:deleBtnTag -101];
        [self.delegate VCshouldAddVideoArr:self.images];
        NSLog(@"imags:%@",self.images);
        
        UIButton *currentDeleBtn = (UIButton *)[self viewWithTag:deleBtnTag];
        
        [currentDeleBtn.superview removeFromSuperview];
        
        if ([[self.subviews lastObject] isHidden]) {
            [[self.subviews lastObject] setHidden:NO];
        }
    }
}


// 对所有子控件进行布局
- (void)layoutSubviews
{
    [super layoutSubviews];
    int count =(int)self.subviews.count;
    
    //只有一行的情况
    CGFloat btnW = 80*floatScreenW;
    CGFloat btnH = btnW;
    //    NSLog(@"btnH:%d ,%f",imageH,[[UIScreen mainScreen] bounds].size.height);
    int maxColumn = kMaxColumn > self.frame.size.width / btnW ? self.frame.size.width / btnW : kMaxColumn;
    CGFloat marginX = (self.frame.size.width - maxColumn * btnW) / (3 + 1);
    CGFloat marginY = (self.frame.size.height - btnH)/2;
    for (int i = 0; i < count; i++) {
        UIButton *btn = self.subviews[i];
        btn.tag = i +1;
        
        CGFloat btnX = (i % maxColumn) * (marginX + btnW) + marginX;
        CGFloat btnY = (i / maxColumn) * (marginY + btnH) + marginY;
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    }
}

#pragma mark - UIImagePickerController 代理方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //图片   UIImage *image = info[UIImagePickerControllerEditedImage];
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    NSLog(@"mediaType :%@",mediaType);
    if([mediaType isEqualToString:@"public.movie"]){
        NSURL *videoUrl = info[UIImagePickerControllerMediaURL];
        //    [self getFileSize:[[videoUrl absoluteString] substringFromIndex:16]]
        
        NSLog(@"原始视频大小：%fMB ,原始视频地址：%@ ,压缩后预计：%fMB",
              [self getFileSize:[[videoUrl absoluteString] substringFromIndex:16]],[[videoUrl absoluteString] substringFromIndex:16], [self getFileSize:[[videoUrl absoluteString] substringFromIndex:16]]/5.9);
        float zipVideoSize = [self
                              getFileSize:[[videoUrl absoluteString] substringFromIndex:16]]/5.9 ;
        if (zipVideoSize >10) {
            NSString *str = [NSString
                             stringWithFormat:@"视频压缩之后预计%.2fMB,视频文件大小超出10MB，无法选取",zipVideoSize];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"抱歉"
                                                           message:str delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            [alert show];
        }else{
            [self zipVideoWithVideoURL:videoUrl];
        }
    }else{
        
    }
    // 退出图片选择控制器
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  视频压缩 转码
 */
- (void)zipVideoWithVideoURL:(NSURL *)VideoURL
{
    /**
     *  转化视频级别 ：MP4  目前中等
     */
    _mp4Quality = AVAssetExportPresetMediumQuality;
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:VideoURL options:nil];
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    
    if ([compatiblePresets containsObject:AVAssetExportPresetMediumQuality])
        
    {
        _alert = [[UIAlertView alloc] init];
        [_alert setTitle:@"视频正在处理，请等待..."];
        
        UIActivityIndicatorView* activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        activity.frame = CGRectMake(140,
                                    80,
                                    CGRectGetWidth(_alert.frame),
                                    CGRectGetHeight(_alert.frame));
        [_alert addSubview:activity];
        [activity startAnimating];
        [_alert show];
        _startDate = [NSDate date];
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]initWithAsset:avAsset
                                                                              presetName:_mp4Quality];
        NSDateFormatter* formater = [[NSDateFormatter alloc] init];
        [formater setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
        _mp4Path = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/output-%@.mp4", [formater stringFromDate:[NSDate date]]];
        
        exportSession.outputURL = [NSURL fileURLWithPath: _mp4Path];
        /**
         *  _networkOpt暂时等于yes
         */
        exportSession.shouldOptimizeForNetworkUse = YES;
        exportSession.outputFileType = AVFileTypeMPEG4;
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            switch ([exportSession status]) {
                case AVAssetExportSessionStatusFailed:
                {
                    [_alert dismissWithClickedButtonIndex:0 animated:NO];
                    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"视频转换MP4错误"
                                                                    message:[[exportSession error] localizedDescription]
                                                                   delegate:nil
                                                          cancelButtonTitle:@"好的"
                                                          otherButtonTitles: nil];
                    [alert show];
                    
                    break;
                }
                    
                case AVAssetExportSessionStatusCancelled:
                    NSLog(@"Export canceled");
                    [_alert dismissWithClickedButtonIndex:0
                                                 animated:YES];
                    break;
                case AVAssetExportSessionStatusCompleted:
                    NSLog(@"Successful!");
                    [self performSelectorOnMainThread:@selector(convertFinish) withObject:nil waitUntilDone:NO];
                    break;
                default:
                    break;
            }
            
        }];
    }
    else
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"错误"
                                                        message:@"AVAsset doesn't support mp4 quality"
                                                       delegate:nil
                                              cancelButtonTitle:@"好的"
                                              otherButtonTitles: nil];
        [alert show];
        
    }
}

/**
 *  压缩成功后的处理
 */
- (void) convertFinish
{
    [_alert dismissWithClickedButtonIndex:0 animated:YES];
    
    if (editTag == -1) {
        NSLog(@"MP4视频大小：%f",[self getFileSize:[NSString stringWithFormat:@"%@",_mp4Path]]);
        //        if ([self getFileSize:[NSString stringWithFormat:@"%@",_mp4Path]] >10) {
        //            NSString *str = [NSString stringWithFormat:@"视频太大，无法选取 %f",[self getFileSize:[NSString stringWithFormat:@"%@",_mp4Path]] ];
        //            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"抱歉" message:str delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        //            [alert show];
        //            return;
        //        }
        
        // 创建一个新的控件
        UIButton *btn = [self createButtonWithImage:[self getImage:_mp4Path] andSeletor:@selector(changeOld:)];
        [self insertSubview:btn atIndex:self.subviews.count - 1];
        [self.images addObject:_mp4Path];
        [self.delegate VCshouldAddVideoArr:self.images];
        NSLog(@"imags:%@",self.images);
        if (self.subviews.count - 1 == MaxImageCount|| self.subviews.count -1 == self.canPickerCount) {
            [[self.subviews lastObject] setHidden:YES];
            
        }
    }
    else
    {
        //        // 根据tag修改需要编辑的控件
        //        UIButton *btn = (UIButton *)[self viewWithTag:editTag];
        //        int index = (int)[self.images indexOfObject:[btn imageForState:UIControlStateNormal]];
        //        NSLog(@"index:%d",index);
        
        //        [self.images removeObjectAtIndex:index];
        //        [btn setImage:[self getImage:_mp4Path] forState:UIControlStateNormal];
        //        [self.images insertObject:[self getImage:_mp4Path] atIndex:index];
    }
    
    
    
    //    // UI的更新记得放在主线程,要不然等子线程排队过来都不知道什么年代了,会很慢的
    //    dispatch_async(dispatch_get_main_queue(), ^{
    //        imageView.image = [self getImage:_mp4Path];
    //
    //
    //    });
    
}

/**
 *  加载本地视频的缩略图
 */
-(UIImage *)getImage:(NSString *)videoURL
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:videoURL] options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);//0.0 当前时间，600 每秒钟多少帧
    NSError *error = nil;
    CMTime actualTime;
    
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    
    UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
    
    CGImageRelease(image);
    
    return thumb;
}
//此方法可以获取文件的大小，返回的是单位是MB。
- (CGFloat) getFileSize:(NSString *)path
{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    float filesize = -1.0;
    if ([fileManager fileExistsAtPath:path]) {
        NSDictionary *fileDic = [fileManager attributesOfItemAtPath:path error:nil];//获取文件的属性
        unsigned long long size = [[fileDic objectForKey:NSFileSize] longLongValue];
        filesize = 1.0*size/1024;
    }
    return filesize/1024;
}

- (CGFloat) getVideoLength:(NSURL *)URL
{
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO]
                                                     forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:URL options:opts];
    float second = 0;
    second = urlAsset.duration.value/urlAsset.duration.timescale;
    return second;
}



@end