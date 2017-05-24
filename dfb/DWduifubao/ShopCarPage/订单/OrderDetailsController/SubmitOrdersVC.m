//
//  SubmitOrdersVC.m
//  DWduifubao
//
//  Created by 席亚坤 on 16/12/28.
//  Copyright © 2016年 bianming. All rights reserved.
//
//填写订单
#import "SubmitOrdersVC.h"
#import "SubmitOrdersCell.h"
#import "SubmitAddressCell.h"
#import "PayGoodsVC.h"
#import "AddressManageController.h"
#import "CarModel.h"
#import "HeaderModel.h"
#import "AddressModel.h"
#import "SubmitOrderHeaderView.h"
#import "SubmitOrderFooterView.h"
#import "AddressHeaderView.h"

@interface SubmitOrdersVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong) AddressHeaderView *headerView ;
///价格地址
@property(nonatomic,strong)NSMutableArray * addressArr;
@property(nonatomic,strong)AddressModel *addressModel;

///数据
@property (nonatomic,strong)NSMutableArray * dataArray;
@end

@implementation SubmitOrdersVC
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [BackgroundService requestPushVC:self MyselfAction:^{
        
    }];
    //UI
    [self SET_UI];
    //数据
    [self  SET_DATA];
    
}
#pragma mark - 关于UI
-(void)SET_UI{
    [self showBackBtn];
    [self ShowNodataView];
    self.title = @"填写订单";
    [self.tableView tableViewregisterNibArray:@[@"SubmitOrdersCell"]];
    [self.tableView registerNib:[UINib nibWithNibName:@"SubmitOrderFooterView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"SubmitOrderFooterView"];
    [self.tableView registerClass:[SubmitOrderHeaderView class] forHeaderFooterViewReuseIdentifier:@"SubmitOrderHeaderView"];
    self.headerView =[NIBHelper instanceFromNib:@"AddressHeaderView"];
    _headerView.frame = CGRectMake(0, 0, Width, 0.2*Width);
    [_headerView.AddAddressBtn addTarget:self action:@selector(AddAddressBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    _headerView.backgroundColor = [UIColor redColor];
    self.tableView.tableHeaderView =  _headerView;
    
    
    
}
#pragma mark - 关于数据
-(void)SET_DATA{
    self.addressArr = [NSMutableArray arrayWithCapacity:0];
    self.addressModel = [[AddressModel alloc]init];
    self.dataArray= [NSMutableArray arrayWithCapacity:0];
    [self requestAddressAction];

}
#pragma mark - 整合前面传来的数据
-(void)Data{
    
    NSMutableArray* tempArr = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray * merchant_idArr = [NSMutableArray
                                       arrayWithCapacity:0];
    for (CarModel *model in self.choseArr) {
        [merchant_idArr addObject:model.merchant_id];
    }
    //数组去重
    NSMutableArray *listAry = [[NSMutableArray alloc]init];
    for (NSString *str in merchant_idArr) {
        if (![listAry containsObject:str]) {
            [listAry addObject:str];
        }
    }
    for (NSString * listStr in listAry) {
        NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:0];
        NSMutableArray * modelArr= [NSMutableArray arrayWithCapacity:1];
        NSMutableArray * priceArr= [NSMutableArray arrayWithCapacity:0];
        for (CarModel *model in self.choseArr) {
            model.remark = @"";
            if ([listStr isEqualToString:model.merchant_id]) {
                [dic setObject:model.merchant_id forKey:@"merchant_id"];
                [dic setObject:model.merchant_name forKey:@"merchant_name"];
                [dic setObject:model.remark forKey:@"remark"];
                CGFloat price = [model.price floatValue];
                CGFloat number = [model.number floatValue];
                NSString *allPlrice = [NSString stringWithFormat:@"%.2f",price*number];
                [priceArr addObject:allPlrice];
                [modelArr addObject:model];
            }
            //分区总价格
            NSNumber *sum = [priceArr valueForKeyPath:@"@sum.floatValue"];
            NSString *allPrice = [NSString stringWithFormat:@"%@",sum];
            [dic setObject:allPrice forKey:@"Allprice"];
            [dic setObject:modelArr forKey:@"goods"];
        }
        [tempArr addObject:dic];
        
    }
    NSMutableArray *actualAllPrice = [NSMutableArray arrayWithCapacity:0];
    for (NSMutableDictionary *merchant_dic  in tempArr) {
        HeaderModel * model = [HeaderModel yy_modelWithJSON:merchant_dic];
        
        //[actualAllPrice addObject: model.Allprice];
        model.goods =merchant_dic[@"goods"];
        [self.dataArray addObject:model];
        
    }
//    //提交时总价格
//    NSNumber *sum = [actualAllPrice valueForKeyPath:@"@sum.floatValue"];
//    self.actualAllPrice.text = [NSString stringWithFormat:@"%@",sum];
    //计算运费
    [self requestFreightAction];
    
    
}
//计算运费
-(void)requestFreightAction{
    
    NSDictionary * dic = @{@"GoodsOrder":self.dataArray};
    __weak typeof(self) weakSelf = self;
    NSString *Token =[AuthenticationModel getLoginToken];
    if (Token.length!= 0) {
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.token = [AuthenticationModel getLoginToken];
        baseReq.encryptionType = AES;
        baseReq.data = [AESCrypt encrypt:[dic yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/Mall/requestOrderFreight" sign:[baseReq.data MD5Hash] requestMethod:GET  PushVC:self  success:^(id response) {
            BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
            NSLog(@"计算运费----%@",response);
            if (baseRes.resultCode == 1) {
                [weakSelf HiddenNodataView];
                [weakSelf.dataArray removeAllObjects];
                
                NSMutableArray *actualAllPrice = [NSMutableArray arrayWithCapacity:0];
                NSMutableArray *actualFreight = [NSMutableArray arrayWithCapacity:0];

                NSMutableArray *FreightArr= response[@"data"];
                for (NSDictionary *Fdic in FreightArr) {
                     HeaderModel * model = [HeaderModel yy_modelWithJSON:Fdic];
                    NSMutableArray *goodArr =Fdic[@"goods"];
                    NSMutableArray *goods = [NSMutableArray arrayWithCapacity:0];
                    for (NSMutableDictionary* gooddic in goodArr) {
                        CarModel *carModel = [CarModel yy_modelWithJSON:gooddic];
                        [goods addObject:carModel];
                    }
                    model.goods = goods;
                    [actualAllPrice addObject: model.Allprice];
                    [actualFreight addObject: model.freight];
                    [weakSelf.dataArray addObject:model];

                }
                
                //提交时总价格
                NSNumber *sumactualAllPrice  = [actualAllPrice valueForKeyPath:@"@sum.floatValue"];
                NSNumber *sumactualFreight = [actualFreight valueForKeyPath:@"@sum.floatValue"];

                weakSelf.actualAllPrice.text = [NSString stringWithFormat:@"%.2f",sumactualAllPrice.floatValue+sumactualFreight.floatValue];
                [weakSelf.tableView reloadData];
                
                
            }else{
                [weakSelf showToast:baseRes.msg];
            }
            
        } faild:^(id error) {
            NSLog(@"%@", error);
        }];
        
    }else {
        
    }
    

    
}
#pragma mark - 地址
-(void)requestAddressAction{
    NSString *Token =[AuthenticationModel getLoginToken];
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *dic  =[ @{@"pageIndex":@(1),@"pageCount":@(10)}mutableCopy];
    if (Token.length!= 0) {
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.token = [AuthenticationModel getLoginToken];
        baseReq.encryptionType = AES;
        baseReq.data = [AESCrypt encrypt:[dic yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:Request_AddressList sign:[baseReq.data MD5Hash] requestMethod:GET PushVC:self  success:^(id response) {
            
            BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
            if (baseRes.resultCode == 1) {
                NSArray *arr = response[@"data"];
                for (NSDictionary *dicdata in arr) {
                    AddressModel *model = [AddressModel yy_modelWithJSON:dicdata];
                    [self.addressArr addObject:model];
                }
                
            }else {
                [self showToast:response[@"msg"]];
            }
            
            if (self.addressArr.count>0) {
                self.addressModel = self.addressArr[0];
                [_headerView cellGetData:self.addressModel];
                [_headerView.AddAddressBtn setTitle:@"" forState:(UIControlStateNormal)];
                self.SubmitBtn.backgroundColor = [UIColor redColor];
                self.SubmitBtn.userInteractionEnabled = YES;
            }
            //整合前面传来的数据
            [weakSelf Data];
            //刷新
            [weakSelf.tableView reloadData];
            
        } faild:^(id error) {
            NSLog(@"%@", error);
        }];
        
    }else {
        
    }
    
    
    
}
#pragma mark - 添加收货地址
-(void)AddAddressBtn:(UIButton*)sender{
    
    //Push 跳转
    AddressManageController * VC = [[AddressManageController alloc]init];
    __weak typeof(self) weakSelf = self;
    [VC AddressVCReturn:^(AddressModel *model) {
        weakSelf.addressModel = model;
        [_headerView cellGetData:self.addressModel];
        [_headerView.AddAddressBtn setTitle:@"" forState:(UIControlStateNormal)];
        _SubmitBtn.backgroundColor = [UIColor redColor];
       _SubmitBtn.userInteractionEnabled = YES;
    }];
    [self.navigationController  pushViewController:VC animated:YES];

    
}
#pragma tableView 代理方法
//tab分区个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //分区个数
    return self.dataArray.count;
}
///tab个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    HeaderModel *model = self.dataArray[section];
    return model.goods.count;
}
//tab设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
     tableView.separatorStyle = UITableViewCellAccessoryNone;

    SubmitOrdersCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SubmitOrdersCell" forIndexPath:indexPath];
    HeaderModel *model = self.dataArray[indexPath.section];
    NSArray * arr = model.goods;
    [cell cellGetData:(CarModel *)arr[indexPath.row]];
            //cell选中时的颜色 无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;

    
    }



#pragma mark - 分区页眉
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    SubmitOrderHeaderView * header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"SubmitOrderHeaderView" ];
    [header cellGetData:(HeaderModel*)self.dataArray[section]];
    return header;
    
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    SubmitOrderFooterView * footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"SubmitOrderFooterView" ];
    

    NSIndexPath * ind = [NSIndexPath indexPathWithIndex:section];
    HeaderModel* model = self.dataArray[section];
    footer.remark.indexPath = ind;
    [footer.remark addTarget:self action:@selector(remarkEditingDidEnd:) forControlEvents:(UIControlEventEditingDidEnd)];
    
   [footer cellGetData:model];
   return footer;
    
    
}
-(void)remarkEditingDidEnd:(PublicTF*)sender{
    HeaderModel* model = self.dataArray[sender.indexPath. section];
     model.remark = sender.text;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:sender.indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
    
    
}
#pragma mark - Cell点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:
        {

        }
            break;
        case 1:
        {
            
        }
            break;
        
        default:{
            
        }
            break;
    }

    
}
#pragma mark - Cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 0.25*Width;

    
}
- (IBAction)SubmitOrdersAction:(UIButton *)sender {
    
    //提交网络请求
    [self requestSubmitOrdersAction];

}
#pragma mark - 提交网络请求
-(void)requestSubmitOrdersAction{
    
    NSDictionary * dic = @{@"GoodsOrder":self.dataArray,@"address_id":self.addressModel.address_id};
    __weak typeof(self) weakSelf = self;

    NSString *Token =[AuthenticationModel getLoginToken];
        if (Token.length!= 0) {
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.token = [AuthenticationModel getLoginToken];
        baseReq.encryptionType = AES;
        baseReq.data = [AESCrypt encrypt:[dic yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/Mall/requestGoodsOrder" sign:[baseReq.data MD5Hash] requestMethod:GET  PushVC:self  success:^(id response) {
            BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
            NSLog(@"新建订单----%@",response);
            if (baseRes.resultCode == 1) {
                NSDictionary * orderData=  response[@"data"];
                
                //添加通知刷新购物车
                [[NSNotificationCenter defaultCenter ]postNotificationName:@"RefreshGoodsCar" object:nil userInfo:nil];
                
                //Push 跳转
                PayGoodsVC * VC = [[PayGoodsVC alloc]initWithNibName:@"PayGoodsVC" bundle:nil];
                VC.allPrice = weakSelf.actualAllPrice.text;
                VC.orderData = orderData;
                [weakSelf.navigationController  pushViewController:VC animated:YES];
            }else{
                [weakSelf showToast:baseRes.msg];
            }
            
        } faild:^(id error) {
            NSLog(@"%@", error);
        }];
        
    }else {
        
    }

    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return Width/10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.4*Width;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
