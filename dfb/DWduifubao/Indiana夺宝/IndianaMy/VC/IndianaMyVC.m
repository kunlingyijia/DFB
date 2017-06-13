//
//  IndianaMyVC.m
//  DWduifubao
//
//  Created by 席亚坤 on 17/4/28.
//  Copyright © 2017年 bianming. All rights reserved.
//
#import "IndianaMyVC.h"
#import "IndianaMyOneCell.h"
#import "IndianaMyTwoCell.h"
#import "IndianaMyThreeCell.h"
#import "IndianaCommentsVC.h"
#import "IndianaShopDetailsVC.h"
#import "IndianaHomeVC.h"
#import "IndianaUserSunModel.h"
#import "IndianaShopModel.h"
#import "LuckyNumberVC.h"
@interface IndianaMyVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
///分页参数
@property (nonatomic, assign) NSInteger pageIndex;
///数据
@property (nonatomic,strong)NSMutableArray * dataArray;
/// 1-夺宝记录  2-夺中记录 3-晒单记录
@property(nonatomic,assign)NSInteger MenuType;
@property(nonatomic,strong)UIView *redView;

@end
@implementation IndianaMyVC
#pragma mark -  视图将出现在屏幕之前
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
#pragma mark - 视图已在屏幕上渲染完成
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}
#pragma mark -  载入完成
- (void)viewDidLoad {
    [super viewDidLoad];
    //关于UI
    [self SET_UI];
    //关于数据
    [self  SET_DATA];
    
}
#pragma mark - 关于UI
-(void)SET_UI{
    self.title = @"我的记录";
    __weak typeof(self) weakSelf = self;
    [self showBackBtn:^{
        for (UIViewController *tempVC in weakSelf.navigationController.viewControllers) {
            if ([tempVC isKindOfClass:[IndianaHomeVC class]]) {
                [weakSelf.navigationController popToViewController:tempVC animated:YES];
            }
        }
    }];
    self.redView = [[UIView alloc]init ];
    _redView.frame =CGRectMake(20, Width*0.111111-2, Width/3-20, 2);
    _redView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_redView];
    [self setUpTableView];
}
#pragma mark - 关于tableView
-(void)setUpTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, Width*0.111111, Width, Height-64-Width*0.111111) style:(UITableViewStylePlain)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
    [_tableView tableViewregisterClassArray:@[@"UITableViewCell"]];
    [_tableView tableViewregisterNibArray:@[@"IndianaMyOneCell",@"IndianaMyTwoCell",@"IndianaMyThreeCell"]];
    

}
#pragma mark - 关于数据
-(void)SET_DATA{
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    self.pageIndex =1;
    /// 1-夺宝记录  2-夺中记录 3-晒单记录
    self.MenuType = 1;
    //上拉刷新下拉加载
    [self Refresh];
    [self.tableView.mj_header  beginRefreshing];
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
        NSLog(@"%ld",(long)weakself.pageIndex);
        [weakself requestAction];
        // 进入刷新状态后会自动调用这个block
        [weakself.tableView.mj_footer endRefreshing];
    }];
    
}
#pragma mark - 网络请求
-(void)requestAction{
    NSString *Token =[AuthenticationModel getLoginToken];
    //status		int	4	状态1:全部，2-已中奖
    NSMutableDictionary *dic  =[ @{@"pageIndex":@(self.pageIndex),@"pageCount":@(10),@"status":@(self.MenuType)}mutableCopy];
    __weak typeof(self) weakself = self;
    NSString * act;
    act = self.MenuType ==3 ? Request_DbMyCommentList : Request_DbMyOrderList;
        if (Token.length!= 0) {
                    BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.token = [AuthenticationModel getLoginToken];
        baseReq.encryptionType = AES;
        baseReq.data = [AESCrypt encrypt:[dic yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:act sign:[baseReq.data MD5Hash] requestMethod:GET PushVC:self success:^(id response) {
            BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
            if (baseRes.resultCode ==1) {
                if (weakself.pageIndex == 1) {
                    [weakself.dataArray removeAllObjects];
                }
                NSMutableArray *arr = baseRes.data;
                for (NSDictionary *dicData in arr) {
                IndianaUserSunModel *model = [IndianaUserSunModel yy_modelWithJSON:dicData];
                    CGFloat goods_nameHeight = [NSString getTextHight:model.goods_name withSize:Width-30.0 withFont:15];
                    CGFloat times_noHeight = [NSString getTextHight:model.times_no withSize:Width-30.0 withFont:14];
                    CGFloat contentHeight = [NSString getTextHight:model.content withSize:Width-30.0 withFont:14];
                    model.CellHeight = 22.0+goods_nameHeight+times_noHeight+contentHeight;
                [weakself.dataArray addObject:model];
                }
                NSLog(@"-----%ld",weakself.dataArray .count);
                //刷新
                [weakself.tableView reloadData];
                [weakself HiddenNodataView];
              
            }else{
                [weakself showToast:baseRes.msg];
            }
        } faild:^(id error) {
            NSLog(@"%@", error);
        }];
    }else {
        
    }
    
}
#pragma tableView 代理方法
//tab分区个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.MenuType==1||self.MenuType==2) {
        //分区个数
        return 1;
    }else if(self.MenuType==3){
        return self.dataArray.count;
    }else{
        return 0;
    }
}
///tab个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    [tableView tableViewDisplayWitimage:nil ifNecessaryForRowCount:self.dataArray.count];
    if (self.MenuType==1||self.MenuType==2) {
        //分区个数
        return self.dataArray.count;
;
    }else if(self.MenuType==3){
        
        return 3;
    }else{
        return 0;
    }

}
//tab设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof(self) weakSelf = self;
    //分割线
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
//    if (indexPath.row>self.dataArray.count-1||self.dataArray.count==0) {
//        return [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
//    }else{
        if (self.MenuType==1||self.MenuType==2) {
           IndianaMyOneCell  * cell = [tableView dequeueReusableCellWithIdentifier:@"IndianaMyOneCell" forIndexPath:indexPath];
                cell.IndianaMyOneCellBlock = ^(NSInteger tag){
                if (tag==0) {
                   if (weakSelf.MenuType ==1) {
                       LuckyNumberVC* VC = [[LuckyNumberVC alloc]initWithNibName:@"LuckyNumberVC" bundle:nil];
                       VC.order_no =((IndianaUserSunModel*)weakSelf.dataArray[indexPath.row]).order_no;
                       VC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
                       [weakSelf presentViewController:VC animated:YES completion:nil];
                   }else{
                    //Push 跳转
                   IndianaCommentsVC* VC = [[IndianaCommentsVC alloc]initWithNibName:@"IndianaCommentsVC" bundle:nil];
                       IndianaUserSunModel * model = [IndianaUserSunModel new];
                       model.goods_id = ((IndianaUserSunModel*)weakSelf.dataArray[indexPath.row]).goods_id;
                       model.times_id = ((IndianaUserSunModel*)weakSelf.dataArray[indexPath.row]).times_id;
                       model.times_no = ((IndianaUserSunModel*)weakSelf.dataArray[indexPath.row]).times_no;
                       model.goods_name = ((IndianaUserSunModel*)weakSelf.dataArray[indexPath.row]).goods_name;
                       model.number =((IndianaUserSunModel*)weakSelf.dataArray[indexPath.row]).number;
                       model.goods_image = ((IndianaUserSunModel*)weakSelf.dataArray[indexPath.row]).goods_image;
                       VC.UserSunModel = model;
                    VC.IndianaCommentsVCBlock = ^(){
                        weakSelf.pageIndex = 1;
                        [weakSelf requestAction];
                    };
                    [weakSelf.navigationController  pushViewController:VC animated:YES];
                   }
                }
                if (tag==1) {
                    //Push 跳转
                    IndianaShopDetailsVC* VC = [[IndianaShopDetailsVC alloc]initWithNibName:@"IndianaShopDetailsVC" bundle:nil];
                    VC.goods_id = ((IndianaUserSunModel*)weakSelf.dataArray[indexPath.row]).goods_id;
                    [weakSelf.navigationController  pushViewController:VC animated:YES];
                }
            };
            //cell 赋值
            cell.model = indexPath.row >= self.dataArray.count ? nil :self.dataArray[indexPath.row];
            // cell 其他配置
            return cell;
        }else if(self.MenuType==3) {
            if (indexPath.row==0) {
                IndianaMyTwoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"IndianaMyTwoCell" forIndexPath:indexPath];
                //cell 赋值
                cell.model =indexPath.section >= self.dataArray.count ? nil : self.dataArray[indexPath.section];
                // cell 其他配置
                return cell;
            }else if (indexPath.row==1){
                IndianaMyThreeCell * cell = [tableView dequeueReusableCellWithIdentifier:@"IndianaMyThreeCell" forIndexPath:indexPath];
                //cell 赋值
                IndianaUserSunModel * model = indexPath.section >= self.dataArray.count ? nil : self.dataArray[indexPath.section];
                [cell CellGetData:model.images];
                cell.IndianaMyThreeCellBlock=^(NSInteger tag){
                };
                // cell 其他配置
                return cell;
            }else{
             UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
                cell.contentView.backgroundColor = [UIColor colorWithHexString:kViewBackgroundColor];
                //cell选中时的颜色 无色
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
            
        }else{
             return [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
        }

    //}
}
#pragma mark - Cell点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.MenuType==1||self.MenuType==2) {
    }else{
    }
    
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
#pragma mark - Cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //用storyboard 进行自适应布局
    self.tableView.estimatedRowHeight = 200;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
   if (self.MenuType==1||self.MenuType==2) {
        return self.tableView.rowHeight;
       
    }else{
        IndianaUserSunModel * model =indexPath.section >= self.dataArray.count ? nil : self.dataArray[indexPath.section];
        if (indexPath.row==0) {
            //return 100;
            
            return model.CellHeight+0.125*Width;

        }else if (indexPath.row==1){
            
            
             return  [self setupCellHeight:model.images.count];
            
        }
        else{
            return Width*0.02;
        }
       
    }
     return 80;
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - 菜单选中
- (IBAction)MenuAction:(UIButton *)sender {
    UIView * view =[sender superview];
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf. redView.frame = CGRectMake(view.frame.origin.x, view.frame.size.height, view.frame.size.width, weakSelf.redView.frame.size.height);
        
    }];
    for (int i=0; i<3; i++) {
        UIButton *btn = [self.view viewWithTag:300+i];
        [btn setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
    }
    [sender setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
    /// 1-夺宝记录  2-夺中记录 3-晒单记录
    self.MenuType = sender.tag-299;
    self.pageIndex =1;
   [self.tableView.mj_header  beginRefreshing];
   [self ShowNodataView];
   self.baseBottomView.frame = CGRectMake(0, Width*0.111111, Width, Height);

}

/**
 更新 Cell 高度
 */
- (CGFloat)setupCellHeight:(NSInteger)Count {
    NSInteger row = ceil(Count / 3.0);
    return Count==0 ? 0 :   (Width-20)/3*row+5*(row+1);
}


//只要拖拽就会触发(scrollView 的偏移量发生改变)
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    }

#pragma mark - dealloc
- (void)dealloc
{
    NSLog(@"%@销毁了", [self class]);
}
@end









