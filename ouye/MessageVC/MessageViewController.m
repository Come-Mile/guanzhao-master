//
//  MessageViewController.m
//  ouye
//
//  Created by Sino on 16/3/24.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import "MessageViewController.h"
#import "NavigationBarView.h"
#import "LeftTabViewCell.h"
#import "LWHttpTool.h"
#import <MBProgressHUD.h>
#import "CurrrentAppTool.h"
#import "AnnomentModel.h"
#import <MJRefresh.h>
#import "DetailMessageViewController.h"
#import "DBManager2.h"

@interface MessageViewController ()<UITableViewDelegate ,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentBtn;
@property (weak, nonatomic) IBOutlet UITableView *listTab;

@property (nonatomic ,strong)NSMutableArray *announcementDatas;
@property (nonatomic ,copy)NSString *message;
@end

@implementation MessageViewController
{
    MBProgressHUD *HUD;
    int page;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NavigationBarView *nav = [[NavigationBarView alloc]init];
    nav.titleLabel.text = @"消息";
    [nav setController:self];
    page =0;

    if (self.segmentBtn.selectedSegmentIndex ==0) {
        [self example03];
    }

    [self segementBtnClick:self.segmentBtn];
}

//- (void)getMessage:(NSNotification *)info
//{
//    self.segmentBtn.selectedSegmentIndex = 1;
//}
- (NSMutableArray *)announcementDatas
{
    if (_announcementDatas ==nil) {
        _announcementDatas = [[NSMutableArray alloc]init];
    }
    return _announcementDatas;
}

- (IBAction)segementBtnClick:(UISegmentedControl *)sender {
    
    NSInteger index = sender.selectedSegmentIndex;
    if (index ==0) {
       self.message = @"贾建国的；国家的嘎嘎；加；激发；阿加；极光；昂；按国家法；刚进啊；根据";
        [self loadNewData];
        
    }else{
        self.message = @"阿哥的深刻的金卡空间达到健康的科技";
        [self getNoticeData];
    }
   
    [self.listTab reloadData];
    MWLog(@"已选择：%ld",index);
}

#pragma mark UITableView + 下拉刷新 隐藏时间
- (void)example03
{
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    header.automaticallyChangeAlpha = YES;
    
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    
    // 马上进入刷新状态
//    [header beginRefreshing];
    
    // 设置header
    self.listTab.mj_header = header;
    /*** 下拉刷新 */
    [self example11];
}

- (void)loadNewData
{
    if (self.segmentBtn.selectedSegmentIndex == 0) {
        MWLog(@"下拉刷新");
        page = 0;
        [self.announcementDatas removeAllObjects];
        [self getAnnouncementData];
    }else{
        [self getNoticeData];
        [self.listTab .mj_header endRefreshing];
        [self.listTab.mj_footer endRefreshing];
    }
   
}

#pragma mark UITableView + 下拉刷新 默认
- (void)example11
{
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    self.listTab.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
}
- (void)loadMoreData
{
    if (self.segmentBtn.selectedSegmentIndex ==0) {
        page ++;
        if (self.segmentBtn.selectedSegmentIndex == 0) {
            [self getAnnouncementData];
        }
        MWLog(@"上啦加载");
    }else{
        [self.listTab .mj_header endRefreshing];
        [self.listTab.mj_footer endRefreshing];
    }
    
}

- (void)getAnnouncementData
{
    HUD = [CurrrentAppTool showHUDMessageInView:self.view];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    parameter[@"page"] = [NSString stringWithFormat:@"%d",page];
    
    parameter[@"shopid"] = [MWUserDefaul objectForKey:SHOPID];
    parameter[@"token"] = [NSString stringWithFormat:@"%@",[MWUserDefaul objectForKey:Apptoken]];
    MWLog(@"公告：%@",parameter);
    [LWHttpTool postWithURL:MESSAGELIST params:parameter success:^(id json) {
        [CurrrentAppTool HUDShouldHIddenWithMessage:nil HUD:HUD];
        MWLog(@"消息：%@",json);
         [self.listTab .mj_header endRefreshing];
        [self.listTab.mj_footer endRefreshing];
        if ([json[@"code"]isEqualToNumber:@200]) {
            NSArray *datas = json[@"datas"];
            if ([datas isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dic in datas) {
                    AnnomentModel *model = [[AnnomentModel alloc]init];
                    [model setValuesForKeysWithDictionary:dic];
                    [self.announcementDatas addObject:model];
                }
            }
            [self.listTab reloadData];
        }else{
            [CurrrentAppTool showMessage:[NSString stringWithFormat:@"%@",json[@"msg"]]];
        }
        
    } failure:^(NSError *error) {
        [self.listTab .mj_header endRefreshing];
        [self.listTab.mj_footer endRefreshing];
        [CurrrentAppTool HUDShouldHIddenWithMessage:nil HUD:HUD];
        [CurrrentAppTool showMessage:[NSString stringWithFormat:@"%@",error.localizedDescription]];
    }];
}

- (void)getNoticeData
{
    [self.announcementDatas removeAllObjects];
    NSMutableArray *data = [NSMutableArray array];
    NSArray *DBDatas = [[DBManager2 shared]selectAllDataWithUid:[NSString stringWithFormat:@"%@",[MWUserDefaul objectForKey:user_mobile]]];
    if (DBDatas != NULL && [DBDatas isKindOfClass:[NSArray class]]) {

        for (NSDictionary *dic in DBDatas) {
            AnnomentModel *model = [[AnnomentModel alloc]init];
            
            model.title = @"系统消息";
            if ([dic[@"state"]isEqualToString:@"1"]) {
                model.content = @"任务已经执行完成";
            }else{
                model.content = @"任务资料回收完成";
            }
            model.date = dic[@"datetime"];
            model.check = dic[@"checkstr"];
            model.tagStr = dic[@"tags"];
            NSLog(@"check:%@",model.check);
            [data addObject:model];
        }
        self.announcementDatas = [self paixu:data withDes:@"date" withDes2:@"date"];
    }
    [self.listTab reloadData];
    
}

//倒叙排序
- (NSMutableArray *)paixu:(NSMutableArray *)array withDes:(NSString *)des withDes2:(NSString *)des2
{
    NSSortDescriptor *carNameDesc1 = [NSSortDescriptor sortDescriptorWithKey:des ascending:NO];
    NSSortDescriptor *carNameDesc2 = [NSSortDescriptor sortDescriptorWithKey:des2 ascending:NO];
    NSArray *desc = @[carNameDesc1,carNameDesc2];
    NSArray *sortedArray = [array sortedArrayUsingDescriptors:desc];
    NSMutableArray *sortArray = [NSMutableArray arrayWithArray:sortedArray];
    return sortArray;
}
#pragma mark tabView代理方法

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LeftTabViewCell *cell = [LeftTabViewCell cellWithTabView:tableView];

    AnnomentModel *model = self.announcementDatas[indexPath.row];
    cell.item = model;
   
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  
    return self.announcementDatas.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LeftTabViewCell *cell =(LeftTabViewCell *) [self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    return cell.frame.size.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AnnomentModel *model = self.announcementDatas[indexPath.row];
    if (self.segmentBtn.selectedSegmentIndex == 0) {
        
        DetailMessageViewController *vc = [[DetailMessageViewController alloc]init];
        vc.item = model;
        vc.title = @"公告详情";
        [self.navigationController pushViewController:vc animated:YES];
        
    }else{
        
        if ([model.check isEqualToString:@"0"]) {
            model.check = @"1";
        }
        [[DBManager2 shared]updateDataWithDateCheck:model.check uid:[MWUserDefaul objectForKey:user_mobile] tags:model.tagStr];
        [self.listTab reloadData];
    }
}

//要求委托方的编辑风格在表视图的一个特定的位置。
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCellEditingStyle result = UITableViewCellEditingStyleNone;//默认没有编辑风格
    if ([tableView isEqual:self.listTab] && self.segmentBtn.selectedSegmentIndex ==1) {
        result = UITableViewCellEditingStyleDelete;//设置编辑风格为删除风格
    }
    return result;
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated{//设置是否显示一个可编辑视图的视图控制器。
    [super setEditing:editing animated:animated];
    [self.listTab setEditing:editing animated:animated];//切换接收者的进入和退出编辑模式。
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{//请求数据源提交的插入或删除指定行接收者。
    AnnomentModel *model = self.announcementDatas[indexPath.row];
    if (editingStyle ==UITableViewCellEditingStyleDelete) {//如果编辑样式为删除样式
        if (indexPath.row<[self.announcementDatas count]) {
            [self.announcementDatas removeObjectAtIndex:indexPath.row];//移除数据源的数据
            [[DBManager2 shared]deleteDataWith:[MWUserDefaul objectForKey:user_mobile] tags:model.tagStr];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];//移除tableView中的数据
        }
    }
}
@end
