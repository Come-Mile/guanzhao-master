//
//  WorkListTwoViewController.m
//  ouye
//
//  Created by Sino on 16/4/13.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import "WorkListTwoViewController.h"
#import "NavigationBarView.h"
#import "WorkListCell.h"
#import "WorkListModel.h"

#import "DetailItem.h"
#import "DeviderWorkViewController.h"

#import "VideoTaskViewController.h"

#import "NotesViewController.h"
#import "MapWorkViewContrroller.h"

#import "LWHttpTool.h"
#import "CurrrentAppTool.h"
#import <MBProgressHUD.h>


@interface WorkListTwoViewController ()

@property (nonatomic ,strong)NSMutableArray *datas;
@property (weak, nonatomic) IBOutlet UITableView *lisTab;
@end

@implementation WorkListTwoViewController
{
    MBProgressHUD *HUD;
    int reload;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NavigationBarView *nav = [[NavigationBarView alloc]init];
    [nav setController:self];
    nav.titleLabel.text = self.title;
    reload = 1;
     [[NSNotificationCenter defaultCenter]removeObserver:self name:@"dowrkSucess" object:nil];
    [MWNotificationCenter addObserver:self selector:@selector(setRload) name:@"dowrkSucess" object:nil];
}

-(void)setRload
{
    reload = 1;
}
-(void)viewWillAppear:(BOOL)animated
{
    if (reload == 1) {
        [self getListData];
    }
}
- (NSMutableArray *)datas
{
    if (_datas == nil) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}
/**
 *  获取任务列表数据
 */
- (void)getListData
{
//    [self.datas removeAllObjects];
    [HUD removeFromSuperViewOnHide];
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
            NSMutableArray *dataArray = [NSMutableArray array];
            if ([datas isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dic in datas) {
                    WorkListModel *model = [[WorkListModel alloc]init];
                    model.publish_id = self.DetailItem.publish_id;
                    [model setValuesForKeysWithDictionary:dic];
                    [dataArray addObject:model];
                }
                self.datas = dataArray;
            }
            
            if (self.datas.count == 0) {
                [self showAlert:@"任务已完成"];
            }
        }else{
           [CurrrentAppTool showMessage:[NSString stringWithFormat:@"%@",json[@"msg"]]];
        }
        [self.lisTab reloadData];
    } failure:^(NSError *error) {
        [CurrrentAppTool HUDShouldHIddenWithMessage:nil HUD:HUD];
        [CurrrentAppTool showMessage:[NSString stringWithFormat:@"%@",error.localizedDescription]];
    }];
}

- (void)showAlert:(NSString *)message
{
    UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    
    [alert show];
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    [MWNotificationCenter postNotificationName:@"WORKDONE" object:nil];
    
   
}
- (void)dealloc
{
    [MWNotificationCenter removeObserver:self];
}

#pragma mark tab 协议方法

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WorkListCell *cell = [WorkListCell cellWithTableView:tableView];
    WorkListModel *model = self.datas[indexPath.row];
    cell.item = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WorkListModel *model = self.datas[indexPath.row];
    
    if ([model.task_type isEqualToString:@"3"]) {
        NotesViewController  *controller = [[NotesViewController alloc]init];
        
        controller.title = model.task_name;
        controller.workItem = model;
        [self.navigationController pushViewController:controller animated:YES];
    }else if([model.task_type isEqualToString:@"1"]){
        DeviderWorkViewController *controller = [[DeviderWorkViewController alloc]init];
        
        controller.title = model.task_name;
        controller.workItem = model;
        [self.navigationController pushViewController:controller animated:YES];
    }else if([model.task_type isEqualToString:@"2"]){
        VideoTaskViewController *controller = [[VideoTaskViewController alloc]init];
        controller.workItem = model;
        controller.title = model.task_name;
        [self.navigationController pushViewController:controller animated:YES];
    }else if([model.task_type isEqualToString:@"4"]){
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MapWorkViewContrroller * mapVC = [board instantiateViewControllerWithIdentifier:@"MapWorkViewContrroller"];
        mapVC.title = model.task_name;
        mapVC.workItem = model;
        [self.navigationController pushViewController:mapVC  animated:YES];
    }
    
}
@end
