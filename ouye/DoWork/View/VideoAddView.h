//
//  VideoAddView.h
//  ouye
//
//  Created by Sino on 16/4/8.
//  Copyright © 2016年 夏明伟. All rights reserved.
//
/**
 * 使用说明:直接创建此view添加到你需要放置的位置即可.
 * 属性images可以获取到当前选中的所有图片对象.
 */

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>

@protocol VideoAddImageDelegate <NSObject>

- (void)VCshouldAddVideoArr:(NSMutableArray *)VideoArray;

@end


@interface VideoAddView : UIView
{
    UIAlertView*                                        _alert;//提示信息
    NSDate*                                             _startDate;
    
    UIImagePickerControllerQualityType                  _qualityType;//拍摄清晰度
    NSString*                                           _mp4Quality;
    
    NSURL*                                              _videoURL;//拍摄的视频地址
    NSString*                                           _mp4Path;//转化为MP4之后的视频地址
    
    BOOL                                                _hasVideo;
    BOOL                                                _networkOpt;
    BOOL                                                _hasMp4;
    
    int   deleBtnTag;
    
}
/**
 *  存储所有的照片(UIImage)
 */
@property (nonatomic, strong) NSMutableArray *images;

@property (nonatomic ,assign)NSInteger canPickerCount;//可以拍摄的数量
@property (nonatomic , weak)id<VideoAddImageDelegate>delegate;
@end
