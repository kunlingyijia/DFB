//
//  SettingController.m
//  DWduifubao
//
//  Created by 月美 刘 on 16/9/21.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "SettingController.h"
#import "SuggestionFeedbackController.h"
#import "AddressManageController.h"
#import "LoginController.h"
#import "HelperViewController.h"
#import "AbuotDFBViewController.h"
#import "OpenShopVC.h"
@interface SettingController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;
@end

@implementation SettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showBackBtn];
    self.title = @"更多设置";
    self.dataSource = @[@[@"清除缓存"],@[@"意见反馈",@"问题与帮助",@"关于兑富宝",@"联系我们"]];
    self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    self.tableView.backgroundColor =[UIColor colorWithHexString:kViewBackgroundColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //设置TableView自带Cell的样式
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    self.tableView.frame = CGRectMake(0, 0, Width, 270);
    //设置TableViewCell的高度
    self.tableView.rowHeight = 50;
    //设置TableView不可滑动
    self.tableView.scrollEnabled = NO;
    [self.view addSubview:self.tableView];
    //设置"退出账号"按钮
    UIButton *exitBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.tableView.frame)+30, Width-40, 44)];
    exitBtn.backgroundColor = [UIColor colorWithHexString:kRedColor];
    [exitBtn setTitle:@"退出账号" forState:UIControlStateNormal];
    [exitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [exitBtn addTarget:self action:@selector(exitBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:exitBtn];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}
//"退出账号"的按钮事件
- (void)exitBtnAction:(UIButton *)button {
    //NSLog(@"%@",[AuthenticationModel getLoginToken]);
    [AuthenticationModel moveLoginToken];
    [AuthenticationModel moveLoginKey];
//    [AuthenticationModel moveCarNumber];
    
    NSLog(@"%@",[AuthenticationModel getLoginToken]);
    //退出---通知中心刷新购物车
    [[NSNotificationCenter defaultCenter ]postNotificationName:@"LoginOutRefreshGoodsCar" object:nil userInfo:nil];
    [self.navigationController popViewControllerAnimated:YES];
    //设置别名
      [[NSNotificationCenter defaultCenter]postNotificationName:@"设置别名" object:nil userInfo:[NSDictionary dictionaryWithObject:@"" forKey:@"pushAlias"]];
    //[self requestAction];
    
    
}
-(void)requestAction{
    
    NSString *Token =[AuthenticationModel getLoginToken];
    if (Token.length!= 0) {
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.token = [AuthenticationModel getLoginToken];
        baseReq.encryptionType = AES;
        baseReq.data = [AESCrypt encrypt:[@{} yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
        __weak typeof(self) weakSelf = self;
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:Request_Login sign:[baseReq.data MD5Hash] requestMethod:GET PushVC:self success:^(id response) {
            NSLog(@"%@",response);
            if ([response[@"resultCode"] isEqualToString:@"1"]) {
                [AuthenticationModel moveLoginToken];
                [AuthenticationModel moveLoginKey];
                [AuthenticationModel moveCarNumber];
                [AuthenticationModel moveindiana_moblie];
                NSLog(@"%@",[AuthenticationModel getLoginToken]);
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [weakSelf showToast:response[@"msg"]];
                
            }
            
        } faild:^(id error) {
            NSLog(@"%@", error);
        }];
        
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

#pragma mark - UITableViewDataSource
//设置分区的个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

//设置每个分区的cell
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *arr = self.dataSource[section];
    return arr.count;
}

//设置cell的样式
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    cell.textLabel.text = self.dataSource[indexPath.section][indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:kthirdTitleFont];
    cell.textLabel.textColor = [UIColor colorWithHexString:kTitleColor];
    //设置点击tableViewCell不会变成灰色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //仅在Wi-Fi下显示图片
    if (indexPath.section == 0) {
        //        if (indexPath.row == 0) {
        //            //设置一个开关控件
        //            UISwitch *imageSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(Width-70, 7, 60, cell.frame.size.height)];
        //            //2.设置UISwitch的初始化状态
        //
        //            imageSwitch.on  = [[NSUserDefaults standardUserDefaults]boolForKey:@"switchType"];
        ////            if (imageSwitch.isOn) {
        ////                NSLog(@"打开");
        ////            }else{
        ////                NSLog(@"关闭");
        ////            }
        //
        //           // 3.UISwitch事件的响应
        //
        //            [imageSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        //
        //           // [cell addSubview:imageSwitch];
        //        }
        if (indexPath.row == 0) {
            //设置右侧文字
            UILabel *rightL = [UILabel new];
            rightL.tag = 100010;
            rightL.textColor = [UIColor colorWithHexString:kRedColor];
            rightL.font = [UIFont systemFontOfSize:kthirdTitleFont];
            
            //文本靠右边对齐
            rightL.textAlignment = NSTextAlignmentRight;
            [cell.contentView addSubview:rightL];
            
            //自动布局
            [rightL mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(cell.contentView.mas_right).with.offset(-20);
                make.top.equalTo(cell.contentView);
                make.width.mas_equalTo(@(120));
                make.height.mas_equalTo(cell.contentView.mas_height);
            }];
            
            rightL.text = [NSString stringWithFormat:@"%@",[self checkTmpSize]];
        }
    } else  if (indexPath.row == 3) {
        //设置右侧文字
        UILabel *rightL = [UILabel new];
        rightL.tag = 10001010;
        //rightL.textColor = [UIColor colorWithHexString:kRedColor];
        rightL.font = [UIFont systemFontOfSize:kthirdTitleFont];
        //文本靠右边对齐
        rightL.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:rightL];
        //自动布局
        [rightL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(cell.contentView.mas_right).with.offset(-20);
            make.top.equalTo(cell.contentView);
            make.width.mas_equalTo(@(120));
            make.height.mas_equalTo(cell.contentView.mas_height);
        }];
        
        rightL.text = @"400-0781-836";
    }else {
        //设置cell默认的带右箭头
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}
//缓存大小
- (NSString *)checkTmpSize {
    NSUInteger size = [[SDImageCache sharedImageCache] getSize];
    // 1k = 1024, 1m = 1024k
    CGFloat aFloat = size/(1024 * 1024);
    return [NSString stringWithFormat:@"%.1fM",aFloat];
}
#pragma mark -开关点击事件
-(void)switchAction:(UISwitch*)sender{
    BOOL isOn  =[[NSUserDefaults standardUserDefaults]boolForKey:@"switchType"];
    if (isOn ==NO) {
        NSLog(@"开");
        
        [[NSUserDefaults standardUserDefaults]setObject:@"IsWifi" forKey:@"IsWifi"];
    }else {
        NSLog(@"关");
        [[NSUserDefaults standardUserDefaults]setObject:@"Is&&Wifi" forKey:@"IsWifi"];
    }
    
    
    isOn = !isOn;
    [[NSUserDefaults standardUserDefaults]setBool:isOn forKey:@"switchType"];
    sender.on = isOn;
    
}
#pragma mark - UITableViewDelegate
//每个分区分区头的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

//每个分区分区脚的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

//每个cell的点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //系统输出选中的行号
    //NSLog(@"section = %ld   row = %ld", indexPath.section, indexPath.row);
    NSString *Token =[AuthenticationModel getLoginToken];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString * title =   self.dataSource[indexPath.section][indexPath.row];
    __weak typeof(self) weakSelf = self;
    if ([title isEqualToString:@"清除缓存"]) {
        [self alertWithTitle:@"清除本地缓存?" message:nil OKWithTitle:@"确定" CancelWithTitle:@"取消" withOKDefault:^(UIAlertAction *defaultaction) {
            //添加清除缓存的事件......
            [[SDImageCache sharedImageCache] clearDisk];
            UILabel *label = [weakSelf.tableView viewWithTag:100010];
            label.text = @"0.0M";
        } withCancel:^(UIAlertAction *cancelaction) {
            
        }];
    }
    
    if ([title isEqualToString:@"意见反馈"]&&Token.length !=0) {
        SuggestionFeedbackController *suggestionFeedbackController = [[SuggestionFeedbackController alloc] init];
        [self.navigationController pushViewController:suggestionFeedbackController animated:YES];
    }
    if ([title isEqualToString:@"问题与帮助"]) {
        //Push 跳转
        OpenShopVC * VC = [[OpenShopVC alloc]initWithNibName:@"OpenShopVC" bundle:nil];
        VC.type = @"2";
        VC.name = @"问题与帮助";
        [self.navigationController  pushViewController:VC animated:YES];
    }
    if ([title isEqualToString:@"关于兑富宝"]) {
        //Push 跳转
        AbuotDFBViewController * VC = [[AbuotDFBViewController alloc]initWithNibName:@"AbuotDFBViewController" bundle:nil];
        [self.navigationController  pushViewController:VC animated:YES];
    }
    if ([title isEqualToString:@"联系我们"]) {
         [[DWHelper shareHelper]CallPhoneNumber:@"400-0781-836" inView:self.view];
    }
   
    
    
    
}
#pragma mark - dealloc
- (void)dealloc
{
    NSLog(@"%@销毁了", [self class]);
}
@end
