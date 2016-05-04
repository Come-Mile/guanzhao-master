//
//  WorkListViewController.m
//  ouye
//
//  Created by Sino on 16/4/7.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import "WorkListViewController.h"
#import "NavigationBarView.h"
#import "WorkListCell.h"
#import "HeadView.h"
#import "WorkListModel.h"
#import "PresentView.h"

#import "DetailItem.h"
#import "DeviderWorkViewController.h"

#import "VideoTaskViewController.h"

#import "NotesViewController.h"

#import "LWHttpTool.h"
#import "CurrrentAppTool.h"
#import <MBProgressHUD.h>

@interface WorkListViewController ()<UITableViewDelegate , UITableViewDataSource,HeadBtnHaveClickDelegate >

@property (nonatomic ,strong)NSMutableArray *datas;

@property (weak, nonatomic) IBOutlet UITableView *listTab;
@end

@implementation WorkListViewController
{
    MBProgressHUD *HUD;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NavigationBarView *nav = [[NavigationBarView alloc]init];
    [nav setController:self];
    nav.titleLabel.text = self.title;
    
    [self getListData];
}

- (NSMutableArray *)datas
{
    if (_datas == nil) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}

- (void)getListDatas
{
    for (int i=0 ; i<5; i++) {
        WorkListModel *model = [[WorkListModel alloc]init];
        model.task_name = @"测试任务包";
        model.isOpen = NO;
        model.isClose = 1;
        for (int j=0; j<7; j++) {
            WorkListModel *childModel = [[WorkListModel alloc]init];
            childModel.task_name = @"子任务夹";
            model.indexPath = [NSIndexPath indexPathForRow:j inSection:i];
            [model.child addObject:childModel];
        }
        [self.datas addObject:model];
        
    }
    [self.listTab reloadData];
}
/**
 *  获取任务包列表数据
 */
- (void)getListData
{
    [self.datas removeAllObjects];
    HUD = [CurrrentAppTool showHUDMessageInView:self.view];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    parameter[@"shopid"] = [NSString stringWithFormat:@"%@",[MWUserDefaul objectForKey:SHOPID]];
    parameter[@"pid"] = self.DetailItem.p_id;
    parameter[@"token"] = [NSString stringWithFormat:@"%@",[MWUserDefaul objectForKey:Apptoken]];
    [LWHttpTool postWithURL:TASKLIST params:parameter success:^(id json) {
        
        [CurrrentAppTool HUDShouldHIddenWithMessage:nil HUD:HUD];
        MWLog(@"%@",json);
        if ([json[@"code"]isEqualToNumber:@200]) {
             NSArray *datas = json[@"datas"];
            if ([datas isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dic in datas) {
                    WorkListModel *model = [[WorkListModel alloc]init];
                    
                    model.isOpen = NO;
                    [model setValuesForKeysWithDictionary:dic];
                    for (NSDictionary *dic2 in model.child) {
                        WorkListModel *model = [[WorkListModel alloc]init];
                        [model setValuesForKeysWithDictionary:dic2];
                        
                    }
                    [self.datas addObject:model];
                }
            }
        }
        [CurrrentAppTool showMessage:[NSString stringWithFormat:@"%@",json[@"msg"]]];
        
    } failure:^(NSError *error) {
        [CurrrentAppTool HUDShouldHIddenWithMessage:nil HUD:HUD];
        [CurrrentAppTool showMessage:[NSString stringWithFormat:@"%@",error.localizedDescription]];
    }];
}
#pragma mark tab 协议方法

- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.datas.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //对指定节进行“展开”判断
    if (![self isExpanded:(int)section withArray:self.datas]) {
        //若本节是“折叠”的，其行数返回为0
        return 0;
    }
    //    NSDictionary* d=[tableArray objectAtIndex:section];
    WorkListModel *model = self.datas[section];
    return model.child.count;
}

//返回指定节的“isOpen”值
-(Boolean)isExpanded:(int)section withArray:(NSMutableArray *)tableA{
    WorkListModel *modle = tableA[section];
    return modle.isOpen;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WorkListCell *cell = [WorkListCell cellWithTableView:tableView];
    WorkListModel *model = self.datas[indexPath.section];
    
    WorkListModel *childModel = model.child[indexPath.row];
    cell.item = childModel;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    HeadView *view = [[[NSBundle mainBundle]loadNibNamed:@"HeadView" owner:self options:nil]lastObject];
    view.delegate =self;
    
    WorkListModel *model = self.datas[section];
    view.item = model;
   
    if (model.isOpen) {
        [view.downImag setTransform:CGAffineTransformMakeRotation(0)];
    }else{
        [view.downImag setTransform:CGAffineTransformMakeRotation(M_PI)];
    }
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 56;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    DeviderWorkViewController *controller = [[DeviderWorkViewController alloc]init];
//    
//    controller.title = @"拍照任务";
//    [self.navigationController pushViewController:controller animated:YES];
    
    
 
//    VideoTaskViewController *controller = [[VideoTaskViewController alloc]init];
//    
//    controller.title = @"视频任务";
//    [self.navigationController pushViewController:controller animated:YES];
    
    NotesViewController  *controller = [[NotesViewController alloc]init];
    
    controller.title = @"记录任务";
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark headViewDelegate
- (void)HeadBtnHaveClickWith:(UIButton *)senderBtn
{
    MWLog(@"tag:%ld",senderBtn.tag);
    [self collapseOrExpand:(int)senderBtn.tag withTab:self.datas];
    
    //刷新tableview
    [self.listTab reloadData];
 
}

//对指定的节进行“展开/折叠”操作
-(void)collapseOrExpand:(int)section withTab:(NSMutableArray *)tabLeA{
    WorkListModel *model = tabLeA[section];
    model.isOpen = !model.isOpen;
}

@end
