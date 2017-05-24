//
//  MessageViewController.m
//  DWduifubao
//
//  Created by 席亚坤 on 16/11/3.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageCell.h"
#import "MessageModel.h"
#import "HomePageVC.h"
#import "MyPageController.h"
#import "AppDelegate.h"
@interface MessageViewController ()<UITableViewDelegate,UITabBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
///分页参数
@property(nonatomic,assign) int pageIndex;
@property (nonatomic,strong)NSMutableArray *dataArray;

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showBackBtn];
//    __weak typeof(self) weakSelf = self;
//    [self showBackBtn:^{
//
//        for (BaseViewController *tempVC in weakSelf.navigationController.viewControllers) {
//            if ([tempVC isKindOfClass:[HomePageVC class]]) {
//                 [weakSelf.navigationController popToViewController:tempVC animated:YES];
//                return ;
//            }else if ([tempVC isKindOfClass:[MyPageController class]]){
//                 [weakSelf.navigationController popToViewController:tempVC animated:YES];
//                return;
//            }else{
//               
//                //Push 跳转
//                DWTabBarController * VC = [[DWTabBarController alloc]init];
//                VC.selectedIndex = 0;
//                [weakSelf presentViewController:VC animated:NO completion:nil];
//                return;
//            }}
//
//    }];
    self.title = @"我的消息";
    self.view.backgroundColor = [UIColor colorWithHexString:kViewBackgroundColor];
    self.tableView.rowHeight =  UITableViewAutomaticDimension;//设置cell的高度为自动计算，只有才xib或者storyboard上自定义的cell才会生效，而且需要设置好约束
    self.tableView.estimatedRowHeight = 240;//必须设置好预估值
    self.pageIndex = 1;
    self.dataArray = [NSMutableArray arrayWithCapacity:1];
    //用storyboard 进行自适应布局
//    self.tableView.estimatedRowHeight = 44;
//    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.tableFooterView= [[UIView alloc]init];
    [self.tableView registerNib:[UINib nibWithNibName:@"MessageCell" bundle:nil] forCellReuseIdentifier:@"MessageCell"];

    //上拉刷新下拉加载
    [self Refresh];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
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
    NSMutableDictionary *dic  =[ @{@"pageIndex":@(self.pageIndex),@"pageCount":@(10)}mutableCopy];
    __weak typeof(self) weakself = self;
    if (Token.length!= 0) {
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.token = [AuthenticationModel getLoginToken];
        baseReq.encryptionType = AES;
        baseReq.data = [AESCrypt encrypt:[dic yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/Message/requestMessageList" sign:[baseReq.data MD5Hash] requestMethod:GET PushVC:self success:^(id response) {
            if (weakself.pageIndex == 1) {
                [weakself.dataArray removeAllObjects];
            }
            NSLog(@"消息----%@",response);
            if ([response[@"resultCode"] isEqualToString:@"1"]) {
                NSArray *arr = response[@"data"];
                for (NSDictionary *dicdata in arr) {
                MessageModel *model = [MessageModel yy_modelWithJSON:dicdata];
                    [weakself.dataArray addObject:model];
                }
            //刷新
                [weakself.tableView reloadData];
 
            }else{
                [weakself showToast:response[@"msg"]];

            }
            
        } faild:^(id error) {
            NSLog(@"%@", error);
        }];
        
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
    MessageCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MessageCell" forIndexPath:indexPath];
    MessageModel * model = self.dataArray[indexPath.row];
    
    [cell cellGetData:model];
    
       return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 240;
    return self.tableView.rowHeight;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
