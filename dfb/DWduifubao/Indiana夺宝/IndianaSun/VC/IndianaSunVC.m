//
//  IndianaSunVC.m
//  DWduifubao
//
//  Created by 席亚坤 on 17/5/3.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "IndianaSunVC.h"
#import "IndianaMyThreeCell.h"
#import "IndianaMyTwoCell.h"
#import "PhotoViewController.h"
#import "HotSubCell.h"
#import "IndianaUserSunModel.h"
@interface IndianaSunVC ()<UITableViewDelegate,UITableViewDataSource
>
@property(nonatomic,strong)UITableView *tableView;
///分页参数
@property (nonatomic, assign) NSInteger pageIndex;
///数据
@property (nonatomic,strong)NSMutableArray * dataArray;


@end
@implementation IndianaSunVC
#pragma mark - 视图将出现在屏幕之前
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
   // self.title = @"晒单";
    [self showBackBtn];
    [self setUpTableView];
    
}
#pragma mark - 关于tableView
-(void)setUpTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Width, Height-64) style:(UITableViewStylePlain)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
    [_tableView tableViewregisterClassArray:@[@"UITableViewCell"]];
    [_tableView tableViewregisterNibArray:@[@"IndianaMyThreeCell",@"IndianaMyTwoCell"]];
    
}
#pragma mark - 关于数据
-(void)SET_DATA{
    self.dataArray = [NSMutableArray arrayWithCapacity:0];

    self.pageIndex =1;
    [self requestAction];
    //上拉刷新下拉加载
    [self Refresh];
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
    NSMutableDictionary *dic;
    if ([self.title isEqualToString:@"晒单"]) {
        dic  =[ @{@"pageIndex":@(self.pageIndex),@"pageCount":@(10)}mutableCopy];
    }else{
        dic  =[ @{@"pageIndex":@(self.pageIndex),@"pageCount":@(10),@"goods_id":self.goods_id}mutableCopy];
    }
    
    __weak typeof(self) weakself = self;
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.encryptionType = RequestMD5;
        baseReq.data =dic;
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:Request_DbCommentList sign:[[baseReq.data yy_modelToJSONString] MD5Hash] requestMethod:GET PushVC:self success:^(id response) {
            BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
            if (weakself.pageIndex == 1) {
                [weakself.dataArray removeAllObjects];
            }
            if (baseRes.resultCode ==1) {
                NSMutableArray *arr = baseRes.data;
                for (NSDictionary *dicData in arr) {
                    IndianaUserSunModel *model = [IndianaUserSunModel yy_modelWithJSON:dicData];
                    CGFloat goods_nameHeight = [NSString getTextHight:model.goods_name withSize:Width-30 withFont:15];
                    CGFloat times_noHeight = [NSString getTextHight:model.times_no withSize:Width-30 withFont:14];
                    CGFloat contentHeight = [NSString getTextHight:model.content withSize:Width-30.0 withFont:14];
                    model.CellHeight = 22+goods_nameHeight+times_noHeight+contentHeight;
                    [weakself.dataArray addObject:model];
                }
                //刷新
                [weakself.tableView reloadData];
            }else{
                [weakself showToast:baseRes.msg];
            }
        } faild:^(id error) {
            NSLog(@"%@", error);
        }];
   
    
}
#pragma tableView 代理方法
//tab分区个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //分区个数
     [tableView tableViewDisplayWitimage:nil ifNecessaryForRowCount:self.dataArray.count];
    return self.dataArray.count;
}
///tab个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    return 3;
}
//tab设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //分割线
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
        if (indexPath.row==0) {
            IndianaMyTwoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"IndianaMyTwoCell" forIndexPath:indexPath];
            //cell 赋值
            cell.model = indexPath.section >= self.dataArray.count ? nil :self.dataArray[indexPath.section];
            // cell 其他配置
            return cell;
            
        }else if (indexPath.row==1){
            IndianaMyThreeCell * cell = [tableView dequeueReusableCellWithIdentifier:@"IndianaMyThreeCell" forIndexPath:indexPath];
            //cell 赋值
            IndianaUserSunModel *model = self.dataArray[indexPath.section];
            [cell CellGetData:model.images];
      
            // cell 其他配置
            return cell;
        }else{
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
            cell.contentView.backgroundColor = [UIColor colorWithHexString:kViewBackgroundColor];
            //cell选中时的颜色 无色
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }

   
}




#pragma mark - Cell点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    
}
#pragma mark - Cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    IndianaUserSunModel *model = self.dataArray[indexPath.section];

    if (indexPath.row==0) {
        //用storyboard 进行自适应布局
//        self.tableView.estimatedRowHeight = 2000;
//        self.tableView.rowHeight = UITableViewAutomaticDimension;
//        return self.tableView.rowHeight;
        return model.CellHeight+0.125*Width;

    }else if (indexPath.row==1){
        //cell 赋值
                 return  [self setupCellHeight:model.images.count];
        //return  [self setupCellHeight:self.ImageArray.count];
    }else{
        return Width*0.02;
    }
    
    
    
}

/**
 更新 Cell 高度
 */
- (CGFloat)setupCellHeight:(NSInteger)Count {
    
    NSInteger row = ceil(Count / 3.0);
    return Count==0 ? 0 : (Width-20)/3*row+5*(row+1);
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - dealloc
- (void)dealloc
{
    NSLog(@"%@销毁了", [self class]);
}

@end
