//
//  MyPageController.m
//  DWduifubao
//
//  Created by 月美 刘 on 16/9/12.
//  Copyright © 2016年 月美 刘. All rights reserved.
//

#import "MyPageController.h"
#import "BaseNavigationController.h"
#import "UIColor+DWColor.h"
#import "LoginController.h"
#import "IndianaViewController.h"
#import "SettingController.h"
#import "PersonalCenterController.h"
#import "PersonModel.h"
#import "PublicViewController.h"
#import "ScoreRecordController.h"
#import "EnNembersViewController.h"
#import "MoneyViewController.h"
#import "DFBWebViewVC.h"
#import "SpectrumViewController.h"
#import "UPNembersViewController.h"
#import "AuditViewController.h"
#import "FailureViewController.h"
#import "SupplyShimingController.h"
#import "BuyNemberViewController.h"
#import "PerfectShiBaiViewController.h"
#import "MyShopViewController.h"
#import "AgentViewController.h"
#import "MessageViewController.h"
#import "MyShareEWMViewController.h"
#import "BackgroundService.h"
#import "StoreListViewController.h"
#import "O2OMainViewController.h"
#import "O2OViewController.h"
#import "BankNewChangeViewController.h"


#import "MyOrderController.h"
#import "FocusMainVC.h"

#import "MyServiceVC.h"
#import "OpenShopVC.h"
#import "spectrumVC.h"

#import "MerchantsHomePageVC.h"
#import "MerchantEntrance.h"
#import "IndianaHomeVC.h"

typedef void(^PushOhter)();
@interface MyPageController ()<PersonalCenterControllerDelegate>
@property (nonatomic, strong) PersonModel *personModel ;
@end

@implementation MyPageController
- (void)viewDidLoad {
    [super viewDidLoad];
    if (Height>600) {
        //设置可滑动的高度
        self.myPageContentSizeHeight.constant = Height-40;
        _DiCenImageContentHeight.constant = Width/5*2.1;
    }else{
        //设置可滑动的高度
        self.myPageContentSizeHeight.constant = Height+60;
        _DiCenImageContentHeight.constant = 160;
        
    }
    self.userPhotoImageView.layer.masksToBounds = YES;
    self.userPhotoImageView.layer.cornerRadius = self.userPhotoImageView.frame.size.width/2.0000;
   
    //下拉刷新
    __weak typeof(self) weakself = self;
    self.MainScrollView.mj_header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself requestAction];
        // 进入刷新状态后会自动调用这个block
        [weakself.MainScrollView.mj_header endRefreshing];
        
    }];
    [self LocalData];
    
}
#pragma mark - 本地存储
-(void)LocalData{
    
    NSMutableDictionary * DriverInfo = [AuthenticationModel objectForKey:@"requestUserInfo"];
    NSLog(@"%@",DriverInfo);
    if (DriverInfo.count!=0) {
        self.personModel = [PersonModel yy_modelWithJSON:DriverInfo];
       
    //控件赋值
        [self kongJianFuZhi:_personModel]
        ;
    }
}

#pragma mark - 网络请求
-(void)requestAction{
    NSString *Token =[AuthenticationModel getLoginToken];
    if (Token.length!= 0) {
        self.LoginBtn.alpha = 0.0;
        self.userName.alpha = 1;
        self.typeOfMember.alpha = 1;
        self.GerenBtn.alpha = 1;
        self.virtualglodLabel.alpha =1;
        self.ErWeiMaBtn.alpha = 1;
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.token = [AuthenticationModel getLoginToken];
        baseReq.encryptionType = AES;
        baseReq.data = [AESCrypt encrypt:[@{} yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:Request_UserInfo sign:[baseReq.data MD5Hash] requestMethod:GET  PushVC:self  success:^(id response) {
            BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
            if (baseRes.resultCode == 1) {
                NSLog(@"个人信息----%@",response);
             [AuthenticationModel setValue:response forkey:@"requestUserInfo"];
                
                
                NSDictionary *dic = baseRes.data;
                NSUserDefaults *userDefau = [NSUserDefaults standardUserDefaults];
                [userDefau setObject:dic[@"mobile"] forKey:@"loginmobile"];
                [userDefau setObject:dic[@"idcard_status"] forKey:@"idcard_status"];
                [userDefau setObject:dic[@"isset_paypwd"] forKey:@"isset_paypwd"];
                [userDefau setObject:dic[@"user_type"] forKey:@"user_type"];
                [userDefau setObject:dic[@"openshop_status"] forKey:@"openshop_status"];
                [userDefau setObject:dic[@"score"] forKey:@"score"];
                [userDefau setObject:dic[@"virtual_glod"] forKey:@"virtual_glod"];
                [userDefau setObject:dic[@"cash"] forKey:@"cash"];
                [userDefau setObject:dic[@"score"] forKey:@"score"];
                [userDefau setObject:dic[@"is_handle_password"] forKey:@"is_handle_password"];
                if ([dic[@"bank_account_number"] isEqual:[NSNull null]]) {
                }else{
                    [userDefau setObject:dic[@"bank_account_number"] forKey:@"bank_account_number"];
                }
                [userDefau setObject:dic[@"nick_name"] forKey:@"nick_name"];
                [userDefau setObject:dic[@"gender"] forKey:@"gender"];
                if ([dic[@"cart_num"]isKindOfClass:[NSNull class]]) {
                    
                }else{
                    [userDefau setObject:dic[@"cart_num"] forKey:@"CarNumber"];
                    
                }
                self.personModel = [PersonModel yy_modelWithJSON:response[@"data"]];
               
                
                //控件赋值
                [self kongJianFuZhi:_personModel];
            }
            
        } faild:^(id error) {
            NSLog(@"%@", error);
        }];
        
    }else {
        self.LoginBtn.alpha = 1;
        self.userName.alpha = 0;
        self.typeOfMember.alpha = 0;
        self.GerenBtn.alpha = 0;
        self.virtualglodLabel.alpha = 0;
        self.ErWeiMaBtn.alpha = 0;
        //控件赋值
        self.personModel = [[PersonModel alloc]init];
        [self kongJianFuZhi:_personModel];
    }
    
}
//控件赋值
-(void)kongJianFuZhi:(PersonModel*)model{
    self.userName.text = model.nick_name;
    self.virtualglodLabel.text = [NSString stringWithFormat:@"兑富宝号:%ld", (long)model.inviter_code];
    [self.userPhotoImageView  sd_setImageWithURL:[NSURL URLWithString:model.avatar_url] placeholderImage:[UIImage imageNamed:@"敬请期待"]];
    self.point.text = [NSString stringWithFormat:@"%ld",(long)model.score];
    self.duifuGold.text = [NSString stringWithFormat:@"%.2f",model.virtual_glod];
    self.duifubao.text = [NSString stringWithFormat:@"%.2f",model.cash];
    if (model.user_type ==1) {
        self.generalMemberImg.image = [UIImage imageNamed:@"我的-选中会员-钩"];
        self.SYBMemberImg.image = [UIImage imageNamed:@""];
        [self.typeOfMember setImage:[UIImage imageNamed:@"普通会员)"] forState:
         (UIControlStateNormal)];
    }else if(model.user_type ==2){
        [self.typeOfMember setImage:[UIImage imageNamed:@"创业会员)"] forState:
         (UIControlStateNormal)];
        self.generalMemberImg.image = [UIImage imageNamed:@""];
        self.SYBMemberImg.image = [UIImage imageNamed:@"我的-选中会员-钩"];
    }else{
        self.generalMemberImg.image = [UIImage imageNamed:@""];
        self.SYBMemberImg.image = [UIImage imageNamed:@""];
    }
     //“待付款”的信息个数
    if ([model.dai_fu_kuan intValue]>0) {
        _toPayMessageCount.hidden = NO;
        _toPayMessageCount.text = [NSString stringWithFormat:@"%@",model.dai_fu_kuan];
    }else{
        _toPayMessageCount.hidden = YES;


    }
    
    
//“待收货”的信息个数
    if ([model.dai_shou_huo intValue]>0) {
        _toReceiveMessageCount.hidden = NO;
        _toReceiveMessageCount.text = [NSString stringWithFormat:@"%@",model.dai_shou_huo];
       
    }else{
        _toReceiveMessageCount.hidden = YES;
        
    }
    
      //“待评价”的信息个数
    if ([model.dai_ping_jia intValue]>0) {
        _toEvaluateMessageCount.hidden = NO;
        _toEvaluateMessageCount.text = [NSString stringWithFormat:@"%@",model.dai_ping_jia];
        
    }else{
        _toEvaluateMessageCount.hidden = YES;
        
    }
//“已完成”的信息个数
    if ([model.yi_wan_cheng intValue]>0) {
        _HasCompletedMessageCount.hidden = NO;
        _HasCompletedMessageCount.text = [NSString stringWithFormat:@"%@",model.yi_wan_cheng];
    }else{
        _HasCompletedMessageCount.hidden = YES;
       
        
    }

    
}
#pragma mark -//"设置"的按钮触发事件
- (IBAction)settingBtnAction:(id)sender {
    NSString *Token =[AuthenticationModel getLoginToken];
    if (Token.length!= 0) {
        SettingController *settingController = [[SettingController alloc] init];
        [self.navigationController pushViewController:settingController animated:YES];
    }else{
        [self pushLoginController];
    }
    
    
    
}
#pragma mark - ErWeiMa点击事件
- (IBAction)ErWeiMaBtn:(UIButton *)sender {
    
    //[self showToast:@"跳转到二维码"];
    //Push 跳转
    MyShareEWMViewController * VC = [[MyShareEWMViewController alloc]initWithNibName:@"MyShareEWMViewController" bundle:nil];
    VC.avatar_url = self.personModel.avatar_url;
    [self.navigationController  pushViewController:VC animated:YES];
    
}


#pragma mark - "信息"的按钮触发事件
//"信息"的按钮触发事件
- (IBAction)messageBtnAction:(id)sender {
    // [self GetPublicController];
    NSString *Token =[AuthenticationModel getLoginToken];
    if (Token.length!= 0) {
        //Push 跳转
        MessageViewController * VC = [[MessageViewController alloc]initWithNibName:@"MessageViewController" bundle:nil];
        [self.navigationController  pushViewController:VC animated:YES];
    }else{
        [self pushLoginController];
    }
    
    
}

//"个人中心"的按钮触发事件
- (IBAction)personalCenterBtnAction:(id)sender {
    NSString *Token =[AuthenticationModel getLoginToken];
    if (Token.length!= 0) {
        PersonalCenterController *personalCenterController = [[PersonalCenterController alloc] init];
        personalCenterController.delegate = self;
        personalCenterController.personModel = self.personModel;
        [self.navigationController pushViewController:personalCenterController animated:YES];
    }else{
        [self pushLoginController];
    }
}


#pragma mark - "查看全部订单
- (IBAction)allOrderAction:(UIButton *)sender {
    NSString *Token =[AuthenticationModel getLoginToken];
    if (Token.length!= 0) {     //Push 跳转
        MyOrderController * VC = [[MyOrderController alloc]initWithNibName:@"MyOrderController" bundle:nil];
        VC.titleStr = @"全部";
        [self.navigationController  pushViewController:VC animated:YES];

    }else{
        [self pushLoginController];
    }
    

    
   }


#pragma mark -   "待付款"View事件
- (IBAction)toPayViewAction:(UIButton *)sender {
    NSString *Token =[AuthenticationModel getLoginToken];
    if (Token.length!= 0) {     //Push 跳转
        MyOrderController * VC = [[MyOrderController alloc]initWithNibName:@"MyOrderController" bundle:nil];
        VC.titleStr = @"待付款";
        [self.navigationController  pushViewController:VC animated:YES];
    }else{
        [self pushLoginController];
    }
    

    
    
}
#pragma mark -  "待收货"View事件
- (IBAction)toReceiveViewAction:(UIButton *)sender {
    NSString *Token =[AuthenticationModel getLoginToken];
    if (Token.length!= 0) {     //Push 跳转
        MyOrderController * VC = [[MyOrderController alloc]initWithNibName:@"MyOrderController" bundle:nil];
        VC.titleStr = @"待收货";
        [self.navigationController  pushViewController:VC animated:YES];

    }else{
        [self pushLoginController];
    }
    

    
}

#pragma mark -  "待评价"View事件

- (IBAction)toEvaluateViewAction:(UIButton *)sender {
    
    NSString *Token =[AuthenticationModel getLoginToken];
    if (Token.length!= 0) {
        //Push 跳转
        MyOrderController * VC = [[MyOrderController alloc]initWithNibName:@"MyOrderController" bundle:nil];
        VC.titleStr = @"待评论";
        [self.navigationController  pushViewController:VC animated:YES];
    }else{
        [self pushLoginController];
    }
    

   
}


#pragma mark -  "已完成"View事件
- (IBAction)hasCompletedViewAction:(UIButton *)sender {
    NSString *Token =[AuthenticationModel getLoginToken];
    if (Token.length!= 0) {     //Push 跳转
        MyOrderController * VC = [[MyOrderController alloc]initWithNibName:@"MyOrderController" bundle:nil];
        VC.titleStr = @"已完成";
        [self.navigationController  pushViewController:VC animated:YES];

    }else{
        [self pushLoginController];
    }
    

    
}
#pragma mark -  积分
- (IBAction)integralAction:(UIButton *)sender {
    NSString *Token =[AuthenticationModel getLoginToken];
    if (Token.length!= 0) {    ScoreRecordController * VC = [[ScoreRecordController alloc]initWithNibName:@"ScoreRecordController" bundle:nil];
        
        VC.scoreAll = self.personModel.score;
        [self.navigationController pushViewController:VC animated:YES];
    }else{
        [self pushLoginController];
    }
    
}
#pragma mark - //兑富宝金币
- (IBAction)jinFuJinBiAction:(UIButton *)sender {
    NSString *Token =[AuthenticationModel getLoginToken];
    if (Token.length!= 0) {
        MoneyViewController * VC = [[MoneyViewController alloc]initWithNibName:@"MoneyViewController" bundle:nil];
        VC.title = @"兑富金币记录";
        VC.act = @"act=Api/Score/requestVirtualGlodList";
        VC.virtual_glodAndcash = [self.duifuGold.text floatValue];
        VC.titlelab = @"总兑富金币";
        [self.navigationController pushViewController:VC animated:YES];
    }else{
        [self pushLoginController];
    }
    
}

#pragma mark -//现金
- (IBAction)jingFuBaoAction:(UIButton *)sender {
    NSString *Token =[AuthenticationModel getLoginToken];
    if (Token.length!= 0) {
        MoneyViewController * VC = [[MoneyViewController alloc]initWithNibName:@"MoneyViewController" bundle:nil];
        VC.act = @"act=Api/Score/requestCashList";
        VC.virtual_glodAndcash = self.personModel.cash;
        VC.titlelab = @"总现金";
        VC.title = @"现金记录";
        [self.navigationController pushViewController:VC animated:YES];
    }else{
        [self pushLoginController];
    }
}
#pragma mark -  负资产

- (IBAction)FuZiChanAction:(UIButton *)sender {
//    //Push 跳转
//    MerchantsHomePageVC * VC = [[MerchantsHomePageVC alloc]initWithNibName:@"MerchantsHomePageVC" bundle:nil];
//    __weak typeof(self) weakSelf = self;
//  VC.  merchant_id = @"22";
//    VC.MerchantsHomePageVCBlock =^(){
//         [weakSelf.navigationController setNavigationBarHidden:YES animated:NO];
//    };
//    [self.navigationController  pushViewController:VC animated:YES];

//    //Push 跳转
//    MerchantEntrance * VC = [[MerchantEntrance alloc]initWithNibName:@"MerchantEntrance" bundle:nil];
//    [self.navigationController  pushViewController:VC animated:YES];

    [self GetPublicController];
    
}


#pragma mark - "普通会员"View事件

- (IBAction)generalMemberViewAction:(UIButton *)sender {
    sender.backgroundColor = [UIColor clearColor];
    UIStoryboard *storybard1 = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    EnNembersViewController * ENNC =  [storybard1 instantiateViewControllerWithIdentifier:@"EnNembersViewController"];
    ENNC.titlee = @"普通会员";
    [self.navigationController pushViewController:ENNC animated:YES];
    
}

#pragma mark - "创业会员"View事件
- (IBAction)SYBMemberViewAction:(UIButton *)sender {
    sender.backgroundColor = [UIColor clearColor];
    UIStoryboard *storybard1 = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    EnNembersViewController * ENNC =  [storybard1 instantiateViewControllerWithIdentifier:@"EnNembersViewController"];
    ENNC.titlee = @"创业会员";
    [self.navigationController pushViewController:ENNC animated:YES];
    
    
    
}


#pragma mark - "会员谱"View事件
- (IBAction)memberChartViewAction:(UIButton *)sender {
    sender.backgroundColor = [UIColor clearColor];
//    NSString *Token =[AuthenticationModel getLoginToken];
//    if (Token.length!= 0) {
//        SpectrumViewController *spectrumVC = [[SpectrumViewController alloc]init];
//        [self.navigationController pushViewController:spectrumVC animated:YES];
//    }else{
//        [self pushLoginController];
//    }
    NSString *Token =[AuthenticationModel getLoginToken];
    if (Token.length!= 0) {
        //Push 跳转
        spectrumVC * VC = [[spectrumVC alloc]initWithNibName:@"spectrumVC" bundle:nil];
        [self.navigationController  pushViewController:VC animated:YES];
    }else{
        [self pushLoginController];
    }

    
    
}



#pragma mark -  "关注的商品"View事件
- (IBAction)concernedMerchandiseViewAction:(UIButton *)sender {
//    sender.backgroundColor = [UIColor clearColor];
//    [self GetPublicController];
    NSString *Token =[AuthenticationModel getLoginToken];
    if (Token.length!= 0) {
    //Push 跳转
    FocusMainVC * VC = [[FocusMainVC alloc]initWithNibName:@"FocusMainVC" bundle:nil];
    VC.titlestr = @"商品";
    [self.navigationController  pushViewController:VC animated:YES];
    }else{
        [self pushLoginController];

    }

}


#pragma mark -//"关注的店铺"View事件
- (IBAction)concernedStoreViewAction:(UIButton *)sender {
    sender.backgroundColor = [UIColor clearColor];
    NSString *Token =[AuthenticationModel getLoginToken];
    if (Token.length!= 0) {
        //Push 跳转
//        StoreListViewController * VC = [[StoreListViewController alloc]initWithNibName:@"StoreListViewController" bundle:nil];
//        
//        [self.navigationController  pushViewController:VC animated:YES];
        //Push 跳转
        FocusMainVC * VC = [[FocusMainVC alloc]initWithNibName:@"FocusMainVC" bundle:nil];
        VC.titlestr = @"店铺";
        [self.navigationController  pushViewController:VC animated:YES];

    }else{
        [self pushLoginController];
    }
    
    
    
}


#pragma mark -  //"我要供货"View事件
- (IBAction)supplyOfMaterialViewAction:(UIButton *)sender {
    sender.backgroundColor = [UIColor clearColor];
    [self GetPublicController];
    //我要供货
    //[self  supplyAction];
    
}


#pragma mark - //"我的代理"View事件
- (IBAction)myAgentViewAction:(UIButton *)sender {
    sender.backgroundColor = [UIColor clearColor];
    // [self GetPublicController];
    
    NSString *type =[NSString stringWithFormat:@"%@", [AuthenticationModel getidcard_status]];
    NSString *Token =[AuthenticationModel getLoginToken]
    ;
    __weak typeof(self) weakSelf = self;
    if (Token.length!= 0) {
        
        //Push 跳转
        if ([type isEqualToString:@"2"]) {
            NSLog(@"认证成功");
            [self is_BuyHuiyuan];
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
        [weakSelf.navigationController  pushViewController:VC animated:YES];
        
    }
    
    
    
}
#pragma mark - 我的代理  实名认证 成功 会员够买的状态
-(void)is_BuyHuiyuan{
    NSString*   user_type = [AuthenticationModel getuser_type];//会员状态 1 普通 2 创业
    if ([user_type isEqualToString:@"2"]) {
        //跳转到我的代理界面
        //Push 跳转
        AgentViewController * VC = [[AgentViewController alloc]initWithNibName:@"AgentViewController" bundle:nil];
        [self.navigationController  pushViewController:VC animated:YES];
        
        
    }else{
        UPNembersViewController * UPVC= [[UPNembersViewController alloc]initWithNibName:@"UPNembersViewController" bundle:nil];
        UPVC.upBtnTitle = @"立即升级";
        [self.navigationController pushViewController:UPVC animated:YES];
    }
    
    
    
}



#pragma mark -//"O2O收款"View事件
- (IBAction)O2OCollectMoneyViewAction:(UIButton *)sender {
    sender.backgroundColor = [UIColor clearColor];
    NSString *Token =[AuthenticationModel getLoginToken];
    //    if (Token.length!= 0) {
    //        NSString *url = [NSString stringWithFormat:@"%@",[AuthenticationModel geto2o_url]];
    //        O2OViewController *O2OVC = [[O2OViewController alloc]init];
    //        [self.navigationController pushViewController:O2OVC animated:YES];
    //        [O2OVC loadHTML:url];
    //
    //    }else{
    //        [self pushLoginController];
    //    }
    //    if (Token.length!= 0) {
    //
    //        O2OMainViewController *O2OVC = [[O2OMainViewController alloc]initWithNibName:@"O2OMainViewController" bundle:nil];
    //        [self.navigationController pushViewController:O2OVC animated:YES];
    //
    //    }else{
    //        [self pushLoginController];
    //    }
    __weak typeof(self) weakSelf = self;
    
    [self Realname:^{
        O2OMainViewController *O2OVC = [[O2OMainViewController alloc]initWithNibName:@"O2OMainViewController" bundle:nil];
        [weakSelf.navigationController pushViewController:O2OVC animated:YES];
    }];
    
}


#pragma mark - 我要开店
- (IBAction)duifuSnatchGemViewAction:(UIButton *)sender {
//    sender.backgroundColor = [UIColor clearColor];
//    
//    IndianaViewController *indianaC = [[IndianaViewController alloc] init];
//    // [self .navigationController pushViewController:indianaC animated:YES];
//    [self GetPublicController];
    //Push 跳转
    OpenShopVC * VC = [[OpenShopVC alloc]initWithNibName:@"OpenShopVC" bundle:nil];
    VC.type = @"3";
    VC.name = @"我要开店";
    [self.navigationController  pushViewController:VC animated:YES];

}

#pragma mark - 我的服务
- (IBAction)duifuFinanceViewAction:(UIButton *)sender {
    sender.backgroundColor = [UIColor clearColor];
    //[self GetPublicController];
    
    MyServiceVC * VC = [[MyServiceVC alloc]initWithNibName:@"MyServiceVC" bundle:nil];
    [self.navigationController  pushViewController:VC animated:YES];
}


#pragma mark - 金融资讯

- (IBAction)P2BAllInOneViewAction:(UIButton *)sender {
    sender.backgroundColor = [UIColor clearColor];
    OpenShopVC * VC = [[OpenShopVC alloc]initWithNibName:@"OpenShopVC" bundle:nil];
    VC.type = @"6";
    VC.name = @"金融资讯";
    [self.navigationController  pushViewController:VC animated:YES];
   



}

#pragma mark -   “用户头像”的按钮触发事件
- (IBAction)userPhotoBtnAction:(id)sender {
    NSString *Token =[AuthenticationModel getLoginToken];
    if (Token.length!= 0) {
        PersonalCenterController *personalCenterController = [[PersonalCenterController alloc] init];
        personalCenterController.personModel = self.personModel;
        [self.navigationController pushViewController:personalCenterController animated:YES];
    }else{
        [self pushLoginController];
    }
    
}
//登录按钮
- (IBAction)loginActio:(UIButton *)sender {
    [self pushLoginController];
    
}

#pragma mark -viewWillDisappear
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    //网络请求
    [self requestAction];
}


//修改颜色
- (IBAction)BTNDown:(UIButton *)sender {
    // sender.backgroundColor = [UIColor redColor];
}

-(void)GetPublicController{
    PublicViewController *PBVC = [[PublicViewController alloc] initWithNibName:@"PublicViewController" bundle:nil];
    [self.navigationController pushViewController:PBVC animated:YES];
}
#pragma mark-- 跳转到登录界面
-(void)pushLoginController{
    //Push 跳转
    LoginController * VC = [[LoginController alloc]initWithNibName:@"LoginController" bundle:nil];
    [VC LoginRefreshAction:^{
        
    }];
    [self.navigationController  pushViewController:VC animated:YES];
    
    
}

#pragma mark --- 我要供货
-(void)supplyAction{
    //[self GetPublicController];
    NSString *type =[NSString stringWithFormat:@"%@", [AuthenticationModel getidcard_status]];
    NSString *Token =[AuthenticationModel getLoginToken]
    ;
    NSString*   user_type = [AuthenticationModel getuser_type];
    
    if (Token.length!= 0) {
        //Push 跳转
        if ([type isEqualToString:@"2"]) {
            NSLog(@"认证成功");
            if ([user_type isEqualToString:@"2"]) {
                //供货判断流程
                [self Judgmentofsupply];
            }else{
                UPNembersViewController * UPVC= [[UPNembersViewController alloc]initWithNibName:@"UPNembersViewController" bundle:nil];
                UPVC.upBtnTitle = @"立即升级";
                [self.navigationController pushViewController:UPVC animated:YES];
            }
            
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
            SupplyShimingController * VC = [[SupplyShimingController alloc]initWithNibName:@"SupplyShimingController" bundle:nil];
            VC.upBtnTitle =  @"实名认证";
            [self.navigationController pushViewController:VC animated:YES];
        }
    }else{
        [self pushLoginController];
        
    }
    
}
#pragma mark - 供货判断流程
-(void)Judgmentofsupply{
    //判断
    //是否买过创业会员
    NSString*user_type = [AuthenticationModel getuser_type];
    if ([user_type isEqualToString:@"2"]) {
        //创业会员
        [self ChuangyeHuYuan];
    }else{
        //Push 跳转购买会员
        BuyNemberViewController * VC = [[BuyNemberViewController alloc]initWithNibName:@"BuyNemberViewController" bundle:nil];
        [self.navigationController  pushViewController:VC animated:YES];
        
    }
    
    
    
    
    
}

#pragma mark - 创业会员状态下 开店的四种类型
-(void)ChuangyeHuYuan{
    // 开店（第一家店）0-否 1-未审核 ,2-审核通过, 3-审核拒绝
    NSString * openshop_status = [NSString stringWithFormat:@"%@",[AuthenticationModel getopenshop_status]];
    if ([openshop_status isEqualToString:@"0"]) {
        
        //Push 跳转
        //Push 跳转
        MerchantEntrance * VC = [[MerchantEntrance alloc]initWithNibName:@"MerchantEntrance" bundle:nil];
        [self.navigationController  pushViewController:VC animated:YES];

        
        //未开店
        //Push 跳转
//        SupplyShimingController * VC = [[SupplyShimingController alloc]initWithNibName:@"SupplyShimingController" bundle:nil];
//        VC.upBtnTitle =  @"完善资料";
//        [self.navigationController pushViewController:VC animated:YES];
        NSLog(@"未开店");
    }else if ([openshop_status isEqualToString:@"1"]){
        NSLog(@"未审核");
        //Push 跳转
        AuditViewController * VC = [[AuditViewController alloc]initWithNibName:@"AuditViewController" bundle:nil];
        VC.titleStr =@"我要供货";
        [self.navigationController  pushViewController:VC animated:YES];
        //未审核
    }else if ([openshop_status isEqualToString:@"2"]){
        NSLog(@"审核通过");        //审核通过
//        //Push 跳转
//        MyShopViewController * VC = [[MyShopViewController alloc]initWithNibName:@"MyShopViewController" bundle:nil];
//        VC.act = @"act=Api/Merchant/requestMyMerchantInfo";
//        VC.titleStr = @"我的店铺";
//        [self.navigationController  pushViewController:VC animated:YES];
        
        //Push 跳转
            MerchantsHomePageVC * VC = [[MerchantsHomePageVC alloc]initWithNibName:@"MerchantsHomePageVC" bundle:nil];
            __weak typeof(self) weakSelf = self;
        
            VC.MerchantsHomePageVCBlock =^(){
                 [weakSelf.navigationController setNavigationBarHidden:YES animated:NO];
            };
            [self.navigationController  pushViewController:VC animated:YES];

        
        
    }else if ([openshop_status isEqualToString:@"3"]){
        NSLog(@"审核拒绝");        //审核拒绝
        //Push 跳转
        PerfectShiBaiViewController * VC = [[PerfectShiBaiViewController alloc]initWithNibName:@"PerfectShiBaiViewController" bundle:nil];
        [self.navigationController  pushViewController:VC animated:YES];
        
        
    }
}


#pragma mark - 实名认证公用
-(void)Realname:(PushOhter)pushOhter{
    NSString *type =[NSString stringWithFormat:@"%@", [AuthenticationModel getidcard_status]];
    NSString *Token =[AuthenticationModel getLoginToken]
    ;
    if (Token.length!= 0) {
        //Push 跳转
        if ([type isEqualToString:@"2"]) {
            NSLog(@"认证成功");
            //进行跳转
            //block
            pushOhter();
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
        [self pushLoginController];
    }
    
}
#pragma mark----PersonalCenterControllerDelegate
-(void)PersonalCenterControllerBack{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

@end
