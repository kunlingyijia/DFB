//
//  AddressManageController.m
//  DWduifubao
//
//  Created by 月美 刘 on 16/9/21.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "AddressManageController.h"
#import "AddressManageCell.h"
#import "ReceiveAddressController.h"
#import "AddressModel.h"
#import "SubmitOrdersVC.h"
@interface AddressManageController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
///分页参数
@property(nonatomic,assign) int pageIndex;
@property (nonatomic,strong)NSMutableArray *dataArray;

@end

@implementation AddressManageController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.pageIndex = 1;
    self.dataArray = [NSMutableArray arrayWithCapacity:1];
    [self showBackBtn];
    self.title = @"地址管理";
    self.view.backgroundColor = [UIColor colorWithHexString:kViewBackgroundColor];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Width, Height-144)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //设置tableView的背景色
    self.tableView.backgroundColor = [UIColor colorWithHexString:kViewBackgroundColor];
    
    //设置tableViewCell的高度
    self.tableView.rowHeight = 131;
    
    //设置tableViewCell之间的那条线隐藏掉
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //设置TableView自定义Cell的样式
    [self.tableView registerNib:[UINib nibWithNibName:@"AddressManageCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"AddressManageCell"];
    [self.view addSubview:self.tableView];
    
    //设置"新增收货地址"的按钮样式
    UIButton *addAddressBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, Height-124, Width-40, 44)];
    addAddressBtn.backgroundColor = [UIColor colorWithHexString:kRedColor];
    [addAddressBtn setTitle:@"新增收货地址" forState:UIControlStateNormal];
    [addAddressBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    addAddressBtn.titleLabel.font = [UIFont systemFontOfSize:ksecondTitleFont];
    [addAddressBtn addTarget:self action:@selector(addAddressBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addAddressBtn];
    //请求数据
   // [self requestAction];
    //上拉刷新下拉加载
    [self Refresh];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //请求数据
    [self requestAction];
}
-(void)Refresh{
    //下拉刷新
    __weak typeof(self) weakself = self;
    self.tableView.mj_header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakself.pageIndex =1 ;
        [weakself requestAction];
        
        // 进入刷新状态后会自动调用这个block
        [weakself.tableView.mj_header endRefreshing];
        
    }];
    //上拉加载
    self.tableView. mj_footer=
    [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakself.pageIndex ++ ;
        NSLog(@"%d",weakself.pageIndex);
        [weakself requestAction];
        // 进入刷新状态后会自动调用这个block
        [weakself.tableView.mj_footer endRefreshing];
    }];
    
}
-(void)requestAction{
    NSString *Token =[AuthenticationModel getLoginToken];
    __weak typeof(self) weakSelf = self;

    NSMutableDictionary *dic  =[ @{@"pageIndex":@(self.pageIndex),@"pageCount":@(10)}mutableCopy];
    
    if (Token.length!= 0) {
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.token = [AuthenticationModel getLoginToken];
        baseReq.encryptionType = AES;
        baseReq.data = [AESCrypt encrypt:[dic yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:Request_AddressList sign:[baseReq.data MD5Hash] requestMethod:GET PushVC:self  success:^(id response) {
            if (self.pageIndex == 1) {
                [self.dataArray removeAllObjects];
            }
           
            BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
            if (baseRes.resultCode == 1) {
                NSArray *arr = response[@"data"];
                for (NSDictionary *dicdata in arr) {
                    AddressModel *model = [AddressModel yy_modelWithJSON:dicdata];
                    [self.dataArray addObject:model];
                }

            }else {
                [self showToast:response[@"msg"]];
            }
            //刷新
            [weakSelf.tableView reloadData];
            
        } faild:^(id error) {
            NSLog(@"%@", error);
        }];
        
    }else {
        
    }
    
   
    
}

#pragma mark - UITableViewDelegate
//设置Cell的个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    [tableView tableViewDisplayWitimage:nil ifNecessaryForRowCount:self.dataArray.count];
    return self.dataArray.count;
}

//设置Cell的样式
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AddressManageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddressManageCell" forIndexPath:indexPath];
    //设置点击tableViewCell不会变成灰色
    AddressModel *model = self.dataArray[indexPath.row];
    //cell赋值
    [cell cellGetData:model];
    cell.editBtn.indexPath = indexPath;
    [cell.editBtn addTarget:self action:@selector(editBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    cell.deleteBtn.indexPath= indexPath;
    [cell.deleteBtn addTarget:self action:@selector(deleteBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    cell.defaultAddressBtn.indexPath = indexPath;
    [cell.defaultAddressBtn addTarget:self action:@selector(defaultAddressBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
#pragma mark-- Cell上btn点击事件
-(void)editBtn:(PublicBtn*)sender{
    
    
    ReceiveAddressController *receiveAddressController = [[ReceiveAddressController alloc] initWithNibName:@"ReceiveAddressController" bundle:nil];
    receiveAddressController.addressModel = (AddressModel*)self.dataArray[sender.indexPath.row];
    receiveAddressController.Type = @"编辑";
    [self.navigationController pushViewController:receiveAddressController animated:YES];

}
///默认地址
-(void)defaultAddressBtn:(PublicBtn*)sender{
    AddressModel *model = self.dataArray[sender.indexPath.row];
    NSString *Token =[AuthenticationModel getLoginToken];
    NSMutableDictionary *dic  =[ @{@"address_id":model.address_id}mutableCopy];
    if (Token.length!= 0) {
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.token = [AuthenticationModel getLoginToken];
        baseReq.encryptionType = AES;
        baseReq.data = [AESCrypt encrypt:[dic yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:Request_SetDefaultAddress sign:[baseReq.data MD5Hash] requestMethod:GET PushVC:self  success:^(id response) {
         
            BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
            if (baseRes.resultCode == 1) {
                [self requestAction];

            }else {
                [self showToast:response[@"msg"]];
            }

            
            
        } faild:^(id error) {
            NSLog(@"%@", error);
        }];
        
    }
    



}
-(void)deleteBtn:(PublicBtn*)sender{
    
    if (self.dataArray.count>0) {
        [self alertWithTitle:@"删除地址" message:nil OKWithTitle:@"确定" CancelWithTitle:@"取消" withOKDefault:^(UIAlertAction *defaultaction) {
            AddressModel *model = self.dataArray[sender.indexPath.row];
            NSString *Token =[AuthenticationModel getLoginToken];
            
            NSMutableDictionary *dic  =[ @{@"address_id":model.address_id}mutableCopy];
            
            if (Token.length!= 0) {
                BaseRequest *baseReq = [[BaseRequest alloc] init];
                baseReq.token = [AuthenticationModel getLoginToken];
                baseReq.encryptionType = AES;
                baseReq.data = [AESCrypt encrypt:[dic yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
                [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:Request_DelAddress sign:[baseReq.data MD5Hash] requestMethod:GET PushVC:self  success:^(id response) {
                    BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
                    if (baseRes.resultCode == 1) {
                        [self requestAction];

                    }else {
                        [self showToast:response[@"msg"]];
                    }
 
                    
                    
                } faild:^(id error) {
                    NSLog(@"%@", error);
                }];
                
            }
            
            

        } withCancel:^(UIAlertAction *cancelaction) {
            
        }];
    
   
}

    
}
//"新增收货地址"的按钮事件
- (void)addAddressBtnAction:(UIButton *)button {
    ReceiveAddressController *receiveAddressController = [[ReceiveAddressController alloc] initWithNibName:@"ReceiveAddressController" bundle:nil];
    receiveAddressController.Type = @"增加";

    [self.navigationController pushViewController:receiveAddressController animated:YES];
}


#pragma mark - UITableViewDelegate
//每个cell的点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    AddressModel *model = self.dataArray[indexPath.row];
   
    ///添加通知 ---返回信息
    [[NSNotificationCenter defaultCenter ]postNotificationName:@"AddressManageController" object:nil userInfo:[NSDictionary dictionaryWithObject:model forKey:@"AddressManageController"]];
    for ( BaseViewController *tempVC in self.navigationController.viewControllers) {
        if ([tempVC isKindOfClass:[SubmitOrdersVC class]]) {
            self.addressVC(model);
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }
    
    
}
-(void)AddressVCReturn:(AddressVC)addressVC{
     self.addressVC = addressVC;
}
@end
