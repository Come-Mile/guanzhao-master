//
//  SettingVC.m
//  ouye
//
//  Created by Sino on 16/3/23.
//  Copyright © 2016年 夏明伟. All rights reserved.
//

#import "SettingVC.h"
#import "MJSettingCell.h"
#import "NavigationBarView.h"
#import "ButtonView.h"
#import "LoginViewController.h"
#import "MJSettingItem.h"
#import "MJSettingArrowItem.h"
#import "CurrrentAppTool.h"
#import "AppCheckController.h"
#import "AboutUsViewController.h"
#import "SuggestionViewController.h"
#import "JPUSHService.h"

@interface SettingVC()<UITableViewDataSource , UITableViewDelegate,ButtonViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *listTab;

@property (nonatomic , strong)NSMutableArray *datas;
@end

@implementation SettingVC
- (void)viewWillAppear:(BOOL)animated
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NavigationBarView *nav = [[NavigationBarView alloc]init];
    nav.titleLabel.text = @"设置";
    [nav setController:self];
    
    [self setUpDatas];
}

- (void)setUpDatas
{
    MJSettingItem *name = [MJSettingArrowItem itemWithIcon:nil title:@"关于我们" destVcClass:[AboutUsViewController class]];
    MJSettingItem *name1 = [MJSettingArrowItem itemWithIcon:nil title:@"软件版本" destVcClass:[AppCheckController class]];
    NSDictionary *appDic = [CurrrentAppTool getCurrentDeviceInfo];
    name1.subtitle = [NSString stringWithFormat:@"V%@",appDic[@"appversion"]];
    MJSettingItem *name2 = [MJSettingArrowItem itemWithIcon:nil title:@"意见反馈" destVcClass:[SuggestionViewController class]];
    [self.datas addObjectsFromArray:@[name,name1,name2]];
}

- (NSMutableArray*)datas
{
    if (_datas == nil) {
        _datas = [NSMutableArray array];
    }
    return  _datas;
}

#pragma mark tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.datas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1.创建cell
    MJSettingCell *cell = [MJSettingCell cellWithTableView:tableView];
    
    // 2.给cell传递模型数据
    MJSettingItem *item = self.datas[indexPath.section];
    cell.item = item;
    
    // 3.返回cell
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section ==self.datas.count -1) {
        ButtonView *view = [[[NSBundle mainBundle]loadNibNamed:@"ButtonView" owner:self options:nil]lastObject];
        view.delegate = self;
        return view;
    }
    return nil;
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section ==self.datas.count -1) {
        return 80*floatScreenH;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1.取消选中这行
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 2.模型数据
    MJSettingItem *item = self.datas[indexPath.section];
    if ([item isKindOfClass:[MJSettingArrowItem class]]) { // 箭头
        MJSettingArrowItem *arrowItem = (MJSettingArrowItem *)item;
        
        // 如果没有需要跳转的控制器
        if (arrowItem.destVcClass == nil) return;
        
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        AppCheckController * pushVC = [board instantiateViewControllerWithIdentifier:NSStringFromClass(arrowItem.destVcClass)];
        pushVC.title = item.title;
        
        [self.navigationController pushViewController:pushVC  animated:YES];
    }
}

- (void)logoutBtnClick
{
    MWLog(@"退出");
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"退出后将无法收到通知，确定退出吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex ==1) {
        [MWUserDefaul removeObjectForKey:Apptoken];
        [MWUserDefaul removeObjectForKey:PassWord];
        //退出需要删掉当前登录的人的shopid
        [MWUserDefaul removeObjectForKey:SHOPID];
        
        //给程序设置别名
        [JPUSHService setTags:nil alias:@"" callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginViewController * longin = [board instantiateViewControllerWithIdentifier:@"LoginViewController"];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:longin];
        [self.navigationController presentViewController:nav animated:YES completion:^{
            
        }];
    }
}
-(void)tagsAliasCallback:(int)iResCode
                    tags:(NSSet*)tags
                   alias:(NSString*)alias
{
    MWLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}
@end
