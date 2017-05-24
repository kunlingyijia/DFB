//
//  ShopCarController.m
//  京东购物车
//
//  Created by 席亚坤 on 16/11/21.
//  Copyright © 2016年 席亚坤. All rights reserved.
//

#import "ShopCarController.h"

#import "ShopCaCell.h"
#import "HeaderCarView.h"

#import "HeaderModel.h"
#import "CarModel.h"
#import "SubmitOrdersVC.h"
#import "LoginController.h"
#import "GoodsMain1ViewController.h"
@interface ShopCarController ()<UITableViewDelegate,UITableViewDataSource>{
    HeaderCarView * header;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
///数据
@property (nonatomic,strong)NSMutableArray * dataArray;
///全选set
@property(nonatomic,strong)NSMutableSet *chooseAllSet;

///被选中
@property (nonatomic,strong)NSMutableArray * choseArr;
///数据
@property (nonatomic,strong)NSMutableArray * submitArr;
///被选中总价格
@property (nonatomic,strong)NSMutableArray * totalPriceArr;
@property(nonatomic,assign)NSInteger CarNumber;
@property(nonatomic,assign)BOOL is_Editing;
@end

@implementation ShopCarController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   
}
#pragma mark - 退出账号刷新购物车
-(void)LoginOutRefreshGoodsCar:(NSNotification*)sender{
     [self.dataArray removeAllObjects];
     self.tabBarItem.badgeValue = nil;
     [self.tableView reloadData];
    [AuthenticationModel moveCarNumber];

    
    
}
#pragma mark - 刷新购物车
-(void)RefreshGoodsCar:(NSNotification*)sender{
    NSLog(@"-----");
    //请求购物车接口
    [self requestAction];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
   
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //添加观察者
   //刷新购物车
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(RefreshGoodsCar:) name:@"RefreshGoodsCar" object:nil];
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(LoginOutRefreshGoodsCar:) name:@"LoginOutRefreshGoodsCar" object:nil];
    
    //UI
    [self SET_UI];
    //数据
    [self  SET_DATA];
}
#pragma mark - 关于UI
-(void)SET_UI{
    [self.view endEditing:NO];
    self.title = @"购物车";
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:(UIBarButtonItemStyleDone) target:self action:@selector(rightBarButtonItem:)];
    rightItem.tintColor = [UIColor grayColor];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.tableView.tableFooterView =[[UIView alloc]init];
    [self.tableView tableViewregisterNibArray:@[@"ShopCaCell"]];
    [self.tableView registerClass:[HeaderCarView class] forHeaderFooterViewReuseIdentifier:@"HeaderCarView"];
    self.tableView.rowHeight = 100;
    
}
-(void)rightBarButtonItem:(UIBarButtonItem*)sender{
    _totalLabel.hidden= !_totalLabel.hidden;
    [self.view endEditing:NO];
    if ([sender.title isEqualToString:@"编辑"]) {
        sender.title = @"保存";
        _is_Editing = YES;
        [_payAndDeleteBtn setTitle:@"删除" forState:(UIControlStateNormal)];
        [self.tableView reloadData];

        
    }else{
        sender.title = @"编辑";
        _is_Editing = NO;
        [_payAndDeleteBtn setTitle:@"去兑换" forState:(UIControlStateNormal)];
        //修改购物车网络请求
        [self changeGoodCar];
    }
}

#pragma mark - 关于数据
-(void)SET_DATA{
    self.dataArray = [NSMutableArray arrayWithCapacity:1];
    self.chooseAllSet = [NSMutableSet setWithCapacity:1];
    self.choseArr = [NSMutableArray arrayWithCapacity:1];
    self.submitArr = [NSMutableArray arrayWithCapacity:1];
    self.totalPriceArr = [NSMutableArray arrayWithCapacity:1];
    self.CarNumber = 0;
    _is_Editing = NO;//是否编辑
    //去兑换或者删除按钮状态
    [self ChangepayAndDeleteBtn];
    //上拉刷新下拉加载
    [self Refresh];
    //请求购物车接口
    [self requestAction];
    

}
-(void)Refresh{
    //下拉刷新
    __weak typeof(self) weakself = self;
    self.tableView.mj_header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
       // weakself.pageIndex =1 ;
        [weakself requestAction];
        // 进入刷新状态后会自动调用这个block
        [weakself.tableView.mj_header endRefreshing];
        
    }];
//    //上拉加载
//    self.tableView. mj_footer=
//    [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//       // weakself.pageIndex ++ ;
//        //NSLog(@"%d",weakself.pageIndex);
//        [weakself requestAction];
//        // 进入刷新状态后会自动调用这个block
//        [weakself.tableView.mj_footer endRefreshing];
//    }];
    
}

#pragma mark -  请求购物车接口
-(void)requestAction{
       NSString *Token =[AuthenticationModel getLoginToken];
    NSLog(@"%@",Token);
    if (Token.length!= 0) {
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.token = [AuthenticationModel getLoginToken];
        baseReq.encryptionType = AES;
        baseReq.data = [AESCrypt encrypt:[@{} yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/Cart/requestCartList" sign:[baseReq.data MD5Hash] requestMethod:GET  PushVC:self  success:^(id response) {
            BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
            if (baseRes.resultCode == 1) {
                NSLog(@"获取购物车信息----%@",response);
                [self.dataArray removeAllObjects];
                self.CarNumber=0;
                NSMutableArray * Mainarr = response[@"data"];
                for (NSMutableDictionary * MainDic in Mainarr) {
                    HeaderModel * headerModel = [HeaderModel yy_modelWithJSON:MainDic];
                    NSMutableArray * CarArray = MainDic[@"goods"];
                    NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
                    
                    for (NSDictionary * CarDic in CarArray) {
                        CarModel  * carModel = [CarModel yy_modelWithDictionary:CarDic];
                        self.CarNumber = (self.CarNumber+[carModel.number integerValue]);
                                    NSLog(@"--%@",     carModel.number);
                        [array addObject:carModel];
                        if ([carModel.goods_select isEqualToString:@"1"]) {
                            NSString * allPrice = [NSString stringWithFormat:@"%.2f",[carModel.price floatValue]*[carModel.number floatValue]];
                            //被选中的数据
                            [self.choseArr addObject:carModel];
                            [self.submitArr addObject:carModel];                            //被选中的总价格
                            [self.totalPriceArr addObject: allPrice];
                        }
                    }
                    headerModel.goods = array;
                    
                    [self.dataArray addObject:headerModel];
    }
                
                
//                NSNumber *sum = [self.totalPriceArr valueForKeyPath:@"@sum.floatValue"];
//                self.totalLabel.text = [NSString stringWithFormat:@"合计:  %@",sum];
                //总价格
                NSString *sum = [self.totalPriceArr valueForKeyPath:@"@sum.floatValue"];
                
                self.totalLabel.text = [NSString stringWithFormat:@"合计: %.2f",[sum floatValue]];

                [self.tableView reloadData];
                [self ChangeAllSelection];
                //去兑换或者删除按钮状态
                [self ChangepayAndDeleteBtn];
                 [[NSUserDefaults standardUserDefaults]setValue:[NSString stringWithFormat:@"%ld",(long)self.CarNumber] forKey:@"CarNumber"];
                if (self.CarNumber !=0) {
                    
                    self.tabBarItem.badgeValue = [[AuthenticationModel getCarNumber] intValue] >99 ? @"99+" : [AuthenticationModel getCarNumber];
                  
                }else{
                    self.tabBarItem.badgeValue = nil;
                }
                
            }
            
        } faild:^(id error) {
            NSLog(@"%@", error);
        }];
        
    }else {
       // [self pushLoginController];
    }
    
}
#pragma mark - 修改购物车
-(void)changeGoodCar{
    NSString *Token =[AuthenticationModel getLoginToken];
    __weak typeof(self) weakSelf = self;
    if (Token.length!= 0) {
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.token = [AuthenticationModel getLoginToken];
        baseReq.encryptionType = AES;
        baseReq.data = [AESCrypt encrypt:[self.choseArr yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/Cart/requestChangeCart" sign:[baseReq.data MD5Hash] requestMethod:GET  PushVC:self  success:^(id response) {
            BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
              NSLog(@"修改购物车----%@",response);
            if (baseRes.resultCode == 1) {
              //请求获取购物车接口
                [weakSelf requestAction];
            }else if(baseRes.resultCode == 31){
                //请求获取购物车接口
                [weakSelf requestAction];
            }else{
                [weakSelf showToast:baseRes.msg];
            }
            
        } faild:^(id error) {
            NSLog(@"%@", error);
        }];
        
    }else {
       // [self pushLoginController];
    }
    

    
}
#pragma mark - 修改购物车
-(void)deleteGoodCar{
    
    NSString *Token =[AuthenticationModel getLoginToken];
    if (Token.length!= 0) {
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.token = [AuthenticationModel getLoginToken];
        baseReq.encryptionType = AES;
        baseReq.data = [AESCrypt encrypt:[self.choseArr yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/Cart/requestUpdateCartList" sign:[baseReq.data MD5Hash] requestMethod:GET  PushVC:self  success:^(id response) {
            BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
            NSLog(@"删除购物车----%@",response);
            if (baseRes.resultCode == 1) {
                //删除数据
                [self deleteCarData];
                [self requestAction];
                NSInteger deleteCar =[[AuthenticationModel getCarNumber]integerValue];
                for (CarModel *model in self.choseArr) {
                    deleteCar = (deleteCar -[model.number integerValue]);
                }
                [[NSUserDefaults standardUserDefaults]setValue:[NSString stringWithFormat:@"%ld",(long)deleteCar] forKey:@"CarNumber"];
               
            }
            
        } faild:^(id error) {
            NSLog(@"%@", error);
        }];
        
    }else {
        [self pushLoginController];
    }
    
    
    
}


#pragma tableView 代理方法
//tab分区个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //分区个数
    [tableView tableViewDisplayWitimage:@"您的购物车是空的" ifNecessaryForRowCount:self.dataArray.count];
    return self.dataArray.count;
    
}
///tab个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    HeaderModel *headerM=self.dataArray[section];
    return ((NSMutableArray*)headerM.goods).count;
}
//tab设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ShopCaCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ShopCaCell" forIndexPath:indexPath];
    
    //cell 赋值
    if (_is_Editing == NO) {
        cell.AddAndDelView.userInteractionEnabled = NO;
    }else{
        cell.AddAndDelView.userInteractionEnabled = YES;
    }
    cell.addBtn.indexPath = indexPath;
    cell.deleteBtn.indexPath = indexPath;
    cell.textTf.indexPath = indexPath;
    cell.choseBtn.indexPath = indexPath;
    [cell.addBtn addTarget:self action: @selector(addBtnAction:)  forControlEvents:(UIControlEventTouchUpInside)];
    [cell.deleteBtn addTarget:self action: @selector(addBtnAction:)  forControlEvents:(UIControlEventTouchUpInside)];
    [cell.textTf addTarget:self action:@selector(celltextTf:) forControlEvents:UIControlEventEditingDidEnd];
    [cell.choseBtn addTarget:self action:@selector(cellchoseBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    HeaderModel *headerM=self.dataArray[indexPath.section];
    NSMutableArray * arr= (NSMutableArray *)headerM.goods;
    CarModel * car = arr[indexPath.row];
    [cell cellGetData:car];
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    return cell;
}
#pragma mark - Cell点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_is_Editing !=YES) {
        HeaderModel *headerM=self.dataArray[indexPath.section];
        NSMutableArray * arr= (NSMutableArray *)headerM.goods;
        CarModel * car = arr[indexPath.row];
        //Push 跳转
        GoodsMain1ViewController * VC = [[GoodsMain1ViewController alloc]initWithNibName:@"GoodsMain1ViewController" bundle:nil];
        VC.goods_id = car.goods_id;
        [self.navigationController  pushViewController:VC animated:YES];

    }
    
}
#pragma mark - celltextTf
-(void)celltextTf:(PublicTF*)sender{
    ShopCaCell *cell = [self.tableView cellForRowAtIndexPath:sender.indexPath];
    HeaderModel *headerM=self.dataArray[sender.indexPath.section];
    NSMutableArray * JDArray= (NSMutableArray *)headerM.goods;
    CarModel * car = JDArray[sender.indexPath.row];
    [cell.choseBtn setImage:[UIImage imageNamed:@"购物车-选中打钩"] forState:UIControlStateNormal];
    NSString * chose = @"1";
    car.goods_select = @"1";
    car.number =[NSString stringWithFormat:@"%@", cell.textTf.text];
    NSMutableArray *YesOrNo = [NSMutableArray arrayWithCapacity:0];
    for (CarModel * carmodel in headerM.goods ) {
        NSString  *cho =[NSString stringWithFormat:@"%@",carmodel.goods_select];
        [YesOrNo addObject:cho];
    }
    NSSet  * set =[NSSet setWithArray:YesOrNo];
    if (set.count == 1) {
        headerM.merchant_select = [NSString stringWithFormat:@"%@", chose];
        
    }
    ///改变全选按钮状态
    [self ChangeAllSelection];
    [self.tableView reloadData];
    
    
}
#pragma mark - addBtnAction
-(void)addBtnAction:(PublicBtn*)sender{
    ShopCaCell *cell = [self.tableView cellForRowAtIndexPath:sender.indexPath];
    HeaderModel *headerM=self.dataArray[sender.indexPath.section];
    NSMutableArray * JDArray= (NSMutableArray *)headerM.goods;
    CarModel * car = JDArray[sender.indexPath.row];
    [cell.choseBtn setImage:[UIImage imageNamed:@"购物车-选中打钩"] forState:UIControlStateNormal];
    NSString * chose = @"1";
    car.goods_select = @"1";
    car.number =[NSString stringWithFormat:@"%@", cell.textTf.text];
    NSMutableArray *YesOrNo = [NSMutableArray arrayWithCapacity:0];
    for (CarModel * carmodel in headerM.goods ) {
        NSString  *cho =[NSString stringWithFormat:@"%@",carmodel.goods_select];
        [YesOrNo addObject:cho];
    }
    NSSet  * set =[NSSet setWithArray:YesOrNo];
    if (set.count == 1) {
        headerM.merchant_select = [NSString stringWithFormat:@"%@", chose];
        
    }
    ///改变全选按钮状态
    [self ChangeAllSelection];
    [self.tableView reloadData];
}
#pragma mark - cellchoseBtn
-(void)cellchoseBtn:(PublicBtn*)sender{
    HeaderModel *headerM=self.dataArray[sender.indexPath.section];
    NSMutableArray * JDArray= (NSMutableArray *)headerM.goods;
    CarModel * car = JDArray[sender.indexPath.row];
    if ([car.goods_select isEqualToString:@"1"]) {
        car.goods_select = @"0";
        [sender setImage:[UIImage imageNamed:@"购物车-未选中"] forState:UIControlStateNormal];
    }else{
        car.goods_select = @"1";
        [sender setImage:[UIImage imageNamed:@"购物车-选中打钩"] forState:UIControlStateNormal];
    }
    
    NSMutableArray *YesOrNo = [NSMutableArray arrayWithCapacity:0];
    for (CarModel * carmodel in headerM.goods ) {
        NSString  *cho =[NSString stringWithFormat:@"%@",carmodel.goods_select];
        [YesOrNo addObject:cho];
    }
    NSSet  * set =[NSSet setWithArray:YesOrNo];
    if (set.count == 1) {
        headerM.merchant_select = [NSString stringWithFormat:@"%@", car.goods_select];
    }else{
        headerM.merchant_select = [NSString stringWithFormat:@"0"];
    }
    
    ///改变全选按钮状态
    [self ChangeAllSelection];
    [self.tableView reloadData];
    
    
}

#pragma mark - 分区页眉
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    //if (!header) {
        header= [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HeaderCarView" ];
       
   // }
    if (header) {
        header.oneBtn.indexPath = [NSIndexPath indexPathWithIndex:section];
        [header.oneBtn addTarget:self action:@selector(headeroneBtn:) forControlEvents:(UIControlEventTouchUpInside)];
        HeaderModel *headerM = self.dataArray[section];
        
        [header headerGetData:headerM];

    }
    
    
    return header;
    
}
#pragma mark - 分区页眉 勾选时间
-(void)headeroneBtn:(PublicBtn*)sender{
    HeaderModel *headerM =self.dataArray[sender.indexPath.section];
    NSMutableArray * arr = (NSMutableArray *)headerM.goods;
    if ([headerM.merchant_select isEqualToString:@"1"]) {
        headerM.merchant_select = @"0";
        for (int i=0; i<arr.count; i++) {
            CarModel *carModel =headerM.goods[i];
            carModel.goods_select = [NSString stringWithFormat:@"0"];
        }
        [sender setImage:[UIImage imageNamed:@"购物车-未选中"] forState:(UIControlStateNormal)];
    }else{
        headerM.merchant_select = @"1";
        for (int i=0; i<arr.count; i++) {
            CarModel *carModel =headerM.goods[i];
            carModel.goods_select = [NSString stringWithFormat:@"1"];
        }
        [sender setImage:[UIImage imageNamed:@"购物车-选中打钩"] forState:(UIControlStateNormal)];
    }
    ///改变全选按钮状态
    [self ChangeAllSelection];
    [self.tableView reloadData];
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
    
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return _is_Editing;
}
//iOS 8.0 后才有的方法
-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof(self) weakSelf = self;
    UITableViewRowAction *delete = [UITableViewRowAction rowActionWithStyle:(UITableViewRowActionStyleDefault) title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        ShopCaCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        HeaderModel *headerM=self.dataArray[indexPath.section];
        NSMutableArray * JDArray= (NSMutableArray *)headerM.goods;
        CarModel * car = JDArray[indexPath.row];
        car.goods_select = @"1";
        if ([car.goods_select isEqualToString:@"1"]) {
            [cell.choseBtn setImage:[UIImage imageNamed:@"购物车-未选中"] forState:UIControlStateNormal];
        }else{
            [cell.choseBtn setImage:[UIImage imageNamed:@"购物车-选中打钩"] forState:UIControlStateNormal];
        }
        NSMutableArray *YesOrNo = [NSMutableArray arrayWithCapacity:0];
        for (CarModel * carmodel in headerM.goods ) {
            NSString  *cho =[NSString stringWithFormat:@"%@",carmodel.goods_select];
            [YesOrNo addObject:cho];
        }
        NSSet  * set =[NSSet setWithArray:YesOrNo];
        if (set.count == 1) {
            headerM.merchant_select = [NSString stringWithFormat:@"%@", car.goods_select];
        }else{
            headerM.merchant_select = [NSString stringWithFormat:@"0"];
        }
        
//        ///改变全选按钮状态
        [self ChangeAllSelection];
        [self.tableView reloadData];
        
       
        NSMutableArray * arr = ( NSMutableArray *)headerM.goods;
         NSLog(@"arr--%@",[arr yy_modelToJSONObject]);
        
        NSMutableArray * deleteArray =[NSMutableArray arrayWithCapacity:0];
       deleteArray= arr[indexPath.row];
         NSLog(@"deleteArray--%@",[deleteArray yy_modelToJSONObject]);
        NSString *Token =[AuthenticationModel getLoginToken];
        if (Token.length!= 0) {
            BaseRequest *baseReq = [[BaseRequest alloc] init];
            baseReq.token = [AuthenticationModel getLoginToken];
            baseReq.encryptionType = AES;
            baseReq.data = [AESCrypt encrypt:[@[deleteArray] yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
            [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/Cart/requestUpdateCartList" sign:[baseReq.data MD5Hash] requestMethod:GET  PushVC:self  success:^(id response) {
                BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
                NSLog(@"删除购物车----%@",response);
                if (baseRes.resultCode == 1) {
                    NSMutableArray *YesOrNo = [NSMutableArray arrayWithCapacity:0];
                    for (CarModel * carmodel in headerM.goods ) {
                        NSString  *cho =[NSString stringWithFormat:@"%@",carmodel.goods_select];
                        [YesOrNo addObject:cho];
                    }
                    NSSet  * set =[NSSet setWithArray:YesOrNo];
                    if (set.count == 1) {
                        headerM.merchant_select = [NSString stringWithFormat:@"%@", car.goods_select];
                    }else{
                        headerM.merchant_select = [NSString stringWithFormat:@"0"];
                    }

                    //删除数据
                    if (arr.count==1) {
                        [weakSelf.dataArray removeObjectAtIndex:indexPath.section];
                        [weakSelf.tableView reloadData];
                    }else{
                        [arr removeObjectAtIndex:indexPath.row];
                        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                        [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
                    }

                    [weakSelf ChangeAllSelection];
                    //[self requestAction];
                    NSInteger deleteCar =[[AuthenticationModel getCarNumber]integerValue];
                    for (CarModel *model in self.choseArr) {
                        deleteCar = (deleteCar -[model.number integerValue]);
                    }
                    [[NSUserDefaults standardUserDefaults]setValue:[NSString stringWithFormat:@"%ld",(long)deleteCar] forKey:@"CarNumber"];
                     NSLog(@"%@",weakSelf.choseArr);
                    
                }
                
            } faild:^(id error) {
                NSLog(@"%@", error);
            }];
            
        }else {
            [self pushLoginController];
        }
        
        

       
       
        
    }];
    return @[delete];
}


#pragma mark - 全选点击事件
- (IBAction)choseAllAction:(UIButton *)sender {
    NSMutableArray *DimageArray = [NSMutableArray arrayWithCapacity:0];
    for (HeaderModel *headerMin in self.dataArray ) {
        [DimageArray addObject: headerMin.merchant_select];
    }
    NSSet * set = [NSSet setWithArray:DimageArray];
    for (NSString *str in set) {
        if ([str isEqualToString:@"1"]) {
            for (int i = 0; i<self.dataArray.count; i++) {
                HeaderModel * heade = self.dataArray[i];
                for (int i=0; i<heade.goods.count; i++) {
                    CarModel *car = heade.goods[i];
                    car.goods_select = @"0";
                    [(NSMutableArray*)heade.goods replaceObjectAtIndex:i withObject:car];
                }
                heade.merchant_select = @"0" ;
            }
        }else{
            for (int i = 0; i<self.dataArray.count; i++) {
                HeaderModel * heade = self.dataArray[i];
                for (int i=0; i<heade.goods.count; i++) {
                    CarModel *car = heade.goods[i];
                    car.goods_select = @"1";
                    [(NSMutableArray*)heade.goods replaceObjectAtIndex:i withObject:car];
                }
                heade.merchant_select = @"1" ;
            }
        }
    }
    [self.tableView reloadData];
    [self ChangeAllSelection];
    
}
#pragma mark - 支付 点击事件
- (IBAction)payActionOrdeleteAction:(UIButton *)sender {
    if (_is_Editing==YES) {
        [self alertWithTitle:[NSString stringWithFormat: @"确定删除所选商品?"] message:nil OKWithTitle:@"删除" CancelWithTitle:@"再想想" withOKDefault:^(UIAlertAction *defaultaction) {
            //删除的网络请求
            [self deleteGoodCar];
            } withCancel:^(UIAlertAction *cancelaction) {
        }];
    }else{
        //去支付下订单
        //Push 跳转
        SubmitOrdersVC * VC = [[SubmitOrdersVC alloc]initWithNibName:@"SubmitOrdersVC" bundle:nil];
        VC.choseArr = self.choseArr;
        
      ///  NSLog(@"购物车--下单--%@",[self.choseArr[0] yy_modelToJSONObject]);
      [self.navigationController  pushViewController:VC animated:YES];
    }
   

}
#pragma mark - 删除购物的事件
-(void)deleteCarData{
    for (int i=0; i<self.dataArray.count; i++) {
        NSLog(@"---%ld",self.dataArray.count);
        HeaderModel *headerM = self.dataArray[i];
        if ([headerM.merchant_select isEqualToString:@"1"]) {
            [self.dataArray removeObject: headerM];
            //一定要移除后 i--;
            i--;
        }else{
            HeaderModel *headerM = self.dataArray[i];
            for (int j=0; j<headerM.goods.count; j++) {
                CarModel * car = headerM.goods[j];
                if ([car.goods_select isEqualToString:@"1"]) {
                    [(NSMutableArray*)headerM.goods removeObject: car];
                    //一定要移除后 j--;
                    j--;
                }
            }
        }
    }
    ///改变全选按钮状态
    [self ChangeAllSelection];
    [self.tableView reloadData];
   
}
#pragma mark -   ///改变全选按钮状态
-(void)ChangeAllSelection{
    [self.choseArr removeAllObjects];
    [self.submitArr removeAllObjects];
    [self.totalPriceArr removeAllObjects];
    NSMutableArray *DimageArray11 = [NSMutableArray arrayWithCapacity:0];
    for (HeaderModel *headerMin11 in self.dataArray ) {
        [DimageArray11 addObject: headerMin11.merchant_select];
        for (CarModel * carmodel in headerMin11.goods) {
            if ([carmodel.goods_select isEqualToString:@"1"]) {
                NSString * allPrice = [NSString stringWithFormat:@"%.2f",[carmodel.price floatValue]*[carmodel.number floatValue]];
                //被选中的数据
                [self.choseArr addObject:carmodel];
                [self.submitArr addObject:headerMin11];
                //被选中的总价格
                [self.totalPriceArr addObject: allPrice];
                
            }
            
            
        }
        
    }
    [self.chooseAllSet removeAllObjects];
    self.chooseAllSet = [NSMutableSet setWithArray:DimageArray11];
    if ( self.chooseAllSet.count == 1) {
        for (NSString *setStr in self.chooseAllSet) {
            if ([setStr isEqualToString:@"1"]) {
                [self.choseAllBtn setImage:[UIImage imageNamed:@"购物车-选中打钩"] forState:(UIControlStateNormal)];
            }else{
                [self.choseAllBtn setImage:[UIImage imageNamed:@"购物车-未选中"] forState:(UIControlStateNormal)];
            }
        }
    }else{
        [self.choseAllBtn setImage:[UIImage imageNamed:@"购物车-未选中"] forState:(UIControlStateNormal)];
        
    }
    //总价格
    NSString *sum = [self.totalPriceArr valueForKeyPath:@"@sum.floatValue"];
    
    self.totalLabel.text = [NSString stringWithFormat:@"合计: %.2f",[sum floatValue]];
    //去兑换或者删除按钮状态
    [self ChangepayAndDeleteBtn];
    }
#pragma mark -  去兑换或者删除按钮状态
-(void)ChangepayAndDeleteBtn{
    //去兑换或者删除按钮状态
    if (self.choseArr.count==0) {
        self.payAndDeleteBtn.backgroundColor = [UIColor grayColor];
        self.payAndDeleteBtn.userInteractionEnabled = NO;
    }else{
        self.payAndDeleteBtn.backgroundColor = [UIColor redColor];
        self.payAndDeleteBtn.userInteractionEnabled = YES;
    }
    
}
#pragma mark-- 跳转到登录界面
-(void)pushLoginController{
    //Push 跳转
    LoginController * VC = [[LoginController alloc]initWithNibName:@"LoginController" bundle:nil];
    __weak typeof(self) weakSelf = self;

    [VC LoginRefreshAction:^{
        
        [weakSelf requestAction];
    }];
    [self.navigationController  pushViewController:VC animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
