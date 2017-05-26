//
//  EnNembersViewController.m
//  DWduifubao
//
//  Created by 席亚坤 on 16/10/29.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "EnNembersViewController.h"
#import "UPNembersViewController.h"
#import "FailureViewController.h"
#import "AuditViewController.h"
#import "LoginController.h"
#import "HuiYuanModel.h"
#import "HeaderReusableView.h"
#import "HuiYuanCellOne.h"
#import "HuiYuanCellThree.h"
#import "ChuangyeCell.h"
#import "PuTongHuaiYuanCell.h"
#import "PermissionViewController.h"
#import "MoreNemberViewController.h"
#import "ArticleVC.h"
@interface EnNembersViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong)HeaderReusableView *headerView;
@property(nonatomic,assign)NSInteger index;
///数据
@property (nonatomic,strong)NSMutableArray * dataArray;
///今日新增会员
@property(nonatomic,strong)NSString *newprogeny_num;
//总会员人数
@property(nonatomic,strong)NSString *progeny_num;



@end

@implementation EnNembersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showBackBtn];
   //添加 --权益说明标题

    __weak typeof(self) weakSelf = self;
    [self ShowRightBtnTitle:@"权益说明" Back:^{
        //4-注册协议 5-权益说明 7-O2O收款说明
        
        ArticleVC * VC = [[ArticleVC alloc]initWithNibName:@"ArticleVC" bundle:nil];
        VC.type = @"5";
        [weakSelf.navigationController  pushViewController:VC animated:YES];
    }];

    // 1. 配值数据源对象
    self.view.backgroundColor = [UIColor colorWithHexString:kViewBackgroundColor];
    self.index = 1;
    self.dataArray = [NSMutableArray arrayWithCapacity:1];
    self.title = self.titlee;
    //网络请求
    [self requestAction];
     //注册
    if ([self.titlee isEqualToString:@"普通会员"]) {
        [self.collectionView registerNib:[UINib nibWithNibName:@"PuTongHuaiYuanCell" bundle:nil] forCellWithReuseIdentifier:@"PuTongHuaiYuanCell"];

    }else{
       
        [self.collectionView registerNib:[UINib nibWithNibName:@"ChuangyeCell" bundle:nil] forCellWithReuseIdentifier:@"ChuangyeCell"];

    }

}

-(void)requestAction{
    NSString *Token =[AuthenticationModel getLoginToken];
    HuiYuanModel *model = [[HuiYuanModel alloc]init];
    model.is_today = 1;
    model.pageIndex = self.index;
    model.pageCount = 10;
    
    __weak typeof(self) weakSelf = self;
    if (Token.length!= 0) {
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.token = [AuthenticationModel getLoginToken];
        baseReq.encryptionType = AES;
        baseReq.data = [AESCrypt encrypt:[[model yy_modelToJSONObject ] yy_modelToJSONString ]password:[AuthenticationModel getLoginKey]];
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/User/requestMyInviterList" sign:[baseReq.data MD5Hash] requestMethod:GET PushVC:self success:^(id response) {
            NSLog(@"%@",response);
            if (weakSelf.index == 1) {
                [weakSelf.dataArray removeAllObjects];
            }
            if ([response[@"resultCode"] isEqualToString:@"1"]) {
                
               weakSelf.newprogeny_num = [NSString stringWithFormat:@"今日新增会员: %@",response[@"data"][@"new_progeny_num"] ];
            weakSelf.progeny_num = [NSString stringWithFormat:@"总会员数: %@",response[@"data"][@"progeny_num"] ];
                NSArray * arr = response[@"data"][@"progeny_list"];
                
                for (NSDictionary *dic in arr) {
                    HuiYuanModel *model =[HuiYuanModel yy_modelWithJSON:dic];
                    [weakSelf.dataArray addObject:model];
                }
                [weakSelf.collectionView reloadData];
            }else{
                [weakSelf showToast:response[@"msg"]];

            }
           
            
        } faild:^(id error) {
            NSLog(@"%@", error);
        }];
        
    }
    
    
}

#pragma mark --集合视图代理方法
//集合视图分区个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

        return 3;

   
}
//集合视图分区内item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section ==0) {
        return 1;

    }else if (section ==1){
        return 1;

    }else if (section ==2){
        return self.dataArray.count;

    }else{
        return 0;
    }
}
//item 配置
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath. section ==0) {
        HuiYuanCellOne *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HuiYuanCellOne" forIndexPath:indexPath];
        //配置item
        cell.backgroundColor = [UIColor redColor];
        cell.LeftLabel.text = self.newprogeny_num;
        cell.RightLabe.text = self.progeny_num;
        if ([self.titlee isEqualToString:@"普通会员"]) {
            cell.TopImageView.image = [UIImage imageNamed:@"普通会员"];
             cell.LeftImageView.image = [UIImage imageNamed:@"V1"];
            cell.RightImageView.image = [UIImage imageNamed:@"V2灰色"];
        }
        return cell;
        
    }else if (indexPath. section ==1){
        if ([self.titlee isEqualToString:@"普通会员"]) {

        PuTongHuaiYuanCell *cell1 = [collectionView dequeueReusableCellWithReuseIdentifier:@"PuTongHuaiYuanCell" forIndexPath:indexPath];
            [cell1.MoreBtn addTarget:self action:@selector(MoreBtn:) forControlEvents:(UIControlEventTouchUpInside)];
         return cell1;
        }else{
            ChuangyeCell *cell= [collectionView dequeueReusableCellWithReuseIdentifier:@"ChuangyeCell" forIndexPath:indexPath];

            NSString*   user_type = [AuthenticationModel getuser_type];
            if ([user_type isEqualToString:@"2"]) {
                //创业会员
                cell.HuiYunBtn.hidden = YES;
            }else{
            
                 cell.HuiYunBtn.hidden = NO;
            }
            //实名认证状态
             NSString *type =[NSString stringWithFormat:@"%@", [AuthenticationModel getidcard_status]];
            if (![type isEqualToString:@"0"]) {
                [cell.HuiYunBtn setTitle:@"   查看进度   " forState:(UIControlStateNormal)];
            }
            cell.HuiYunBtn.layer.cornerRadius = 5;
            cell.HuiYunBtn.layer.masksToBounds = YES;
            
            [cell.HuiYunBtn addTarget:self action:@selector(ShengJiHuiYuanAction:) forControlEvents:(UIControlEventTouchUpInside)];
            //更多
             [cell.MoreBtn addTarget:self action:@selector(MoreBtn:) forControlEvents:(UIControlEventTouchUpInside)];
            return cell;
        }
    }else if (indexPath. section ==2){
        HuiYuanCellThree *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HuiYuanCellThree" forIndexPath:indexPath];
        HuiYuanModel *model = self.dataArray[indexPath.row];
        cell.nameLabel.text = model.nick_name;
        cell.timelabel.text = model.create_time;
        //配置item
       // cell.backgroundColor = [UIColor redColor];
        
        return cell;
    }else{
        return nil;
    }

   
}
#pragma mark - cell 更多点击事件
-(void)MoreBtn:(UIButton*)sender{
    NSLog(@"更多");
    //[self requestAction];
    //Push 跳转
    MoreNemberViewController * VC = [[MoreNemberViewController alloc]initWithNibName:@"MoreNemberViewController" bundle:nil];
    [self.navigationController  pushViewController:VC animated:YES];

    
    
}
#pragma 集合视图 --约束代理方法
//item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section ==0) {
        return CGSizeMake(Width, Width/5*2);
        
    }else if (indexPath.section ==1){
        if ([self.titlee isEqualToString:@"普通会员"]) {
            return CGSizeMake(Width, 200);
            
        }else{
            return CGSizeMake(Width, 380);
        }
        
    }
    else if (indexPath.section ==2){
        return CGSizeMake(Width, 50);
        
    }else{
        return CGSizeMake(0, 0);
    }

    
    
}
//设置每个cell上下左右相距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
    
}
//设置最小行间距，也就是前一行与后一行的中间最小间隔
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 0 ;
    
}
// 设置最小列间距，也就是左行与右一行的中间最小间隔
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return 0;
}

//升级会员点击时间
-(void)ShengJiHuiYuanAction:(UIButton*)sender{
    NSString *type =[NSString stringWithFormat:@"%@", [AuthenticationModel getidcard_status]];
    NSString *Token =[AuthenticationModel getLoginToken];
    __weak typeof(self) weakSelf = self;
    
    if (Token.length!= 0) {
        //Push 跳转
        //Push 跳转
       
        if ([type isEqualToString:@"2"]) {
            NSLog(@"认证成功");
            UPNembersViewController * UPVC= [[UPNembersViewController alloc]initWithNibName:@"UPNembersViewController" bundle:nil];
            UPVC.upBtnTitle = @"立即升级";
            [self.navigationController pushViewController:UPVC animated:YES];
           
        }  else if ([type  isEqualToString:@"1"]){
            NSLog(@"认证审核中");
            AuditViewController * adVC = [[AuditViewController alloc]initWithNibName:@"AuditViewController" bundle:nil];
            adVC.titleStr =@"实名认证";
            [self.navigationController pushViewController:adVC animated:YES];
        }else if( [type  isEqualToString:@"3"]){
            NSLog(@"认证失败");
            FailureViewController * adVC = [[FailureViewController alloc]initWithNibName:@"FailureViewController" bundle:nil];
            [self.navigationController pushViewController:adVC animated:YES];
           
        }else{
            NSLog(@"未认证");
            UPNembersViewController * VC = [[UPNembersViewController alloc]initWithNibName:@"UPNembersViewController" bundle:nil];
            VC.upBtnTitle =  @"实名认证";
            [self.navigationController pushViewController:VC animated:YES];
        }
    }else{
        
        //Push 跳转
        LoginController * VC = [[LoginController alloc]initWithNibName:@"LoginController" bundle:nil];
        [VC LoginRefreshAction:^{
            
        }];
        [self.navigationController  pushViewController:VC animated:YES];
}

    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
