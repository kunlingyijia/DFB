//
//  LuckyNumberVC.m
//  DWduifubao
//
//  Created by 席亚坤 on 17/5/17.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "LuckyNumberVC.h"
#import "IndianaUserSunModel.h"
#import "UIView+Toast.h"
#define Controller  LuckyNumberVC
@interface LuckyNumberVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
///分页参数
@property (nonatomic, assign) NSInteger pageIndex;
///数据
@property (nonatomic,strong)NSMutableArray * dataArray;
@property(nonatomic,strong)UIButton * btn;
@end
@implementation LuckyNumberVC
#pragma mark -  视图将出现在屏幕之前
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     [self SET_DATA];
}
#pragma mark - 视图已在屏幕上渲染完成
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}
#pragma mark -  载入完成
- (void)viewDidLoad {
    [super viewDidLoad];
    //控制器通明的关键代码
    self.modalPresentationStyle =UIModalPresentationCustom;
    __weak typeof(self) weakSelf = self;
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        //关于数据
//       
//        
//    });
    
    //关于UI
    [self SET_UI];
    
    
}
#pragma mark - 关于UI
-(void)SET_UI{
//    self.title = @"<#标题#>";
//    [self showBackBtn];
    
    
    
    [self setUpTableView];
    
}

#pragma mark - 关于tableView
-(void)setUpTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(Width*0.2, Height*0.25, Width-Width*0.4, Height-Height*0.5) style:(UITableViewStylePlain)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    [_tableView.layer setLaberMasksToBounds:YES cornerRadius:10 borderWidth:0 borderColor:nil];
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
    [_tableView tableViewregisterClassArray:@[@"UITableViewCell"]];
    //[_tableView tableViewregisterNibArray:@[@"<#UITableViewCell#>",@"<#UITableViewCell#>",@"<#UITableViewCell#>",@"<#UITableViewCell#>",@"<#UITableViewCell#>"]];
    UILabel *label= [[UILabel alloc]initWithFrame:CGRectMake(Width*0.2,Height*0.25-Width*0.1-12 ,Width-Width*0.4, Width*0.1)];
    label.backgroundColor = [UIColor whiteColor];
     [label.layer setLaberMasksToBounds:YES cornerRadius:5.0 borderWidth:0 borderColor:nil];
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:16];
    label.textAlignment =NSTextAlignmentCenter;
    label.text = @"YY编号";
    [self.view addSubview:label];
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
    NSString *Token =[AuthenticationModel getLoginToken];
    NSMutableDictionary *dic  =[ @{@"pageIndex":@(self.pageIndex),@"pageCount":@(10),@"order_no":self.order_no}mutableCopy];
    __weak typeof(self) weakself = self;
    if (Token.length!= 0) {
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.token = [AuthenticationModel getLoginToken];
        baseReq.encryptionType = AES;
        baseReq.data = [AESCrypt encrypt:[dic yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:Request_DbLuckNoList sign:[baseReq.data MD5Hash] requestMethod:GET PushVC:self success:^(id response) {
            BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];            if (weakself.pageIndex == 1) {
                [weakself.dataArray removeAllObjects];
            }
            if (baseRes.resultCode ==1) {
                NSMutableArray *arr = baseRes.data[@"list"];
                for (NSString *dicData in arr) {
                    [weakself.dataArray addObject:dicData];
                }
                //刷新
                [weakself.tableView reloadData];
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
    //分区个数
    return 1;
}
///tab个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    [tableView tableViewDisplayWitimage:nil ifNecessaryForRowCount:self.dataArray.count];
    return self.dataArray.count;
}
//tab设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //分割线
    //tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    __weak typeof(self) weakSelf = self;
    if (indexPath.row>self.dataArray.count-1||self.dataArray.count==0) {
        return [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    }else{
                UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
                //cell 赋值
                cell.textLabel.text = self.dataArray[indexPath.row];
                cell.textLabel.textColor = [UIColor lightGrayColor]
                ;
                cell.textLabel.font = [UIFont systemFontOfSize:14];
                cell.textLabel.textAlignment =NSTextAlignmentCenter;
                // cell 其他配置
                return cell;
        
    }
}
#pragma mark - Cell点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row> self.dataArray.count-1||self.dataArray.count==0) {
        return;
    }
    
   
    
}
#pragma mark - Cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return Width*0.08;
            
    
}

- (IBAction)BackAction:(UIButton *)sender {
     [self dismissViewControllerAnimated:YES completion:nil];
}


//只要拖拽就会触发(scrollView 的偏移量发生改变)
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    scrollView= _tableView;
    if (scrollView.contentOffset.y>_tableView.frame.size.height) {
         if (!_btn) {
            self.btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
            _btn.frame = CGRectMake(CGRectGetMaxX(self.tableView.frame)  -Width*0.1-10,CGRectGetMaxY(self.tableView.frame) -Width*0.1-10, Width*0.1, Width*0.1);
            [_btn setImage:[UIImage imageNamed:@"向上返回箭头"] forState:(0)];
            _btn.contentMode =UIViewContentModeScaleAspectFill;
            _btn .backgroundColor = [UIColor colorWithHexString:kViewBackgroundColor];
            [_btn.layer setLaberMasksToBounds:YES cornerRadius:Width*0.05 borderWidth:0.3 borderColor:[UIColor grayColor]];
            [_btn addTarget:self action:@selector(UpTo) forControlEvents:(UIControlEventTouchUpInside)];
            [self.view addSubview:self.btn];
        }
    }else{
        if (_btn) {
            [_btn removeFromSuperview];
            _btn = nil;
        }
    }
    

    
    
    
}


-(void)UpTo{
    [_tableView setContentOffset:CGPointMake(0,0) animated:YES];
    //[self.tableView scr];
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
