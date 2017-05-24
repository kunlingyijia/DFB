//
//  MerchantDataThreeVC.m
//  DWduifubao
//
//  Created by 席亚坤 on 17/3/19.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "MerchantDataThreeVC.h"
#import "MyPageController.h"
#import "MerchantCertificationModel.h"
#import "DWBankViewController.h"
#import "Bank_Region_Bank_Branch.h"
#import "AccountInformationVC.h"

@interface MerchantDataThreeVC ()
@property(nonatomic,assign)BOOL isBank_card_photo;
@end

@implementation MerchantDataThreeVC
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    self.MCModel.bank_account_number=  self.bank_account_number.text;
    //self.MCModel.subbranch=  self.subbranch.text;
    //self.MCModel.license_no=  self.license_no.text;
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self kongjianfuzhi];
}

-(void)kongjianfuzhi{
    _isBank_card_photo = NO;
    
    [self.bank_name setTitle:self.MCModel.bank_name.length==0 ? @"请选择银行":self.MCModel.bank_name forState:(UIControlStateNormal)];
    self.MCModel.bank_card_type = self.MCModel.bank_card_type.length == 0 ? @"2":self.MCModel.bank_card_type ;
     [self.privateBtn setImage: [self.MCModel.bank_card_type isEqualToString:@"2"] ?IMG_Name(@"购物车-选中打钩.png"): IMG_Name(@"购物车-未选中.png")forState:(UIControlStateNormal)];
    [self.contraryBtn setImage: [self.MCModel.bank_card_type isEqualToString:@"1"] ?IMG_Name(@"购物车-选中打钩.png"): IMG_Name(@"购物车-未选中.png")forState:(UIControlStateNormal)];
    
    self.bank_account_number.text = self.MCModel.bank_account_number;
    self.subbranch.text = self.MCModel.subbranch;
    
    if (self.MCModel.bank_card_photo.length !=0){
        [DWHelper SD_WebImage:self.bank_card_photo imageUrlStr:self.MCModel.bank_card_photo placeholderImage:nil];
        _isBank_card_photo = YES;
        
    }
    
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //UI
    [self SET_UI];
    //数据
    [self  SET_DATA];
    
}
#pragma mark - 关于UI
-(void)SET_UI{
    [self showBackBtn];
    self.title = @"收款信息";
    self.privateBtn.selected = YES;
    self.contraryBtn.selected = NO;
    
}
#pragma mark - 关于数据
-(void)SET_DATA{
    //创建观察者
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(Bank_Region_Bank_BranchAction:) name:@"Bank_Region_Bank_Branch" object:nil];
    
}
#pragma mark - 创建观察者返回数据
-(void)Bank_Region_Bank_BranchAction:(NSNotification*)sender{
    NSDictionary * dic = [sender.userInfo objectForKey:@"Bank_Region_Bank_Branch"];
    Bank_Region_Bank_BranchModel * model = [Bank_Region_Bank_BranchModel yy_modelWithJSON:dic];
    [self.bank_name setTitle:model.bank_name forState:(UIControlStateNormal)];
    self.subbranch.text =model .bank_branch;
    self.MCModel.bank_name = model.bank_name;
    self.MCModel.subbranch = model.bank_branch;
     self.MCModel.bank_branch_no = model.bank_branch_no;
}
#pragma mark - 对私
- (IBAction)privateBtnAction:(UIButton *)sender {
    sender.selected =!sender.selected;
    self.contraryBtn.selected =!sender.selected;
    self.MCModel.bank_card_type = @"2";
    if (sender.selected) {
        [sender setImage:IMG_Name(@"购物车-选中打钩.png") forState:(UIControlStateNormal)];
        [self.contraryBtn setImage:IMG_Name(@"购物车-未选中.png") forState:(UIControlStateNormal)];
         }else{
             [sender setImage:IMG_Name(@"购物车-未选中.png") forState:(UIControlStateNormal)];
             [self.contraryBtn setImage:IMG_Name(@"购物车-选中打钩.png") forState:(UIControlStateNormal)];
         }
    
}
#pragma mark - 对公
- (IBAction)ContraryBtnAction:(UIButton *)sender {
    sender.selected =!sender.selected;
    self.privateBtn.selected =!sender.selected;
    self.MCModel.bank_card_type = @"1";
    if (sender.selected) {
        [sender setImage:IMG_Name(@"购物车-选中打钩.png") forState:(UIControlStateNormal)];
        [self.privateBtn setImage:IMG_Name(@"购物车-未选中.png") forState:(UIControlStateNormal)];
    }else{
        [sender setImage:IMG_Name(@"购物车-未选中.png") forState:(UIControlStateNormal)];
        [self.privateBtn setImage:IMG_Name(@"购物车-选中打钩.png") forState:(UIControlStateNormal)];
    }
}

#pragma mark - 获取银行名称
- (IBAction)BankNameAction:(UIButton *)sender {
    [self.view endEditing:YES];
    //Push 跳转
    DWBankViewController * VC = [[DWBankViewController alloc]initWithNibName:@"DWBankViewController" bundle:nil];
    [self.navigationController  pushViewController:VC animated:YES];
}



#pragma mark - 提交申请开店/修改店铺资料
- (IBAction)submitAction:(UIButton *)sender {
    if ([self IF]) {
        
       // 提交申请开店/修改店铺资料
        [self requestApplyShop];
        
        
        
        
    }
    
    
}
#pragma mark - 提交申请开店
-(void)requestApplyShop{
    NSString *Token =[AuthenticationModel getLoginToken];
    __weak typeof(self) weakSelf = self;
    self.view.userInteractionEnabled = NO;
    
    if (Token.length!= 0) {
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.token = [AuthenticationModel getLoginToken];
        baseReq.encryptionType = AES;
        baseReq.data = [AESCrypt encrypt:[self.MCModel yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/Merchant/requestApplyShop" sign:[baseReq.data MD5Hash] requestMethod:GET PushVC:self  success:^(id response) {
            BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
            if (baseRes.resultCode == 1) {
                
                for (BaseViewController *tempVC in weakSelf.navigationController.viewControllers) {
                    if ([tempVC isKindOfClass:[MyPageController class]]) {
                        
                        [weakSelf.navigationController popToViewController:tempVC animated:YES];
                        return ;
                        
                    }
                                    }
                
                
                
                
            }else{
                [weakSelf showToast:baseRes.msg];
                weakSelf.view.userInteractionEnabled = YES;
            }
            
            
        } faild:^(id error) {
            NSLog(@"%@", error);
            weakSelf.view.userInteractionEnabled = YES;
        }];
        
    }
    
    
    

    
    
}


#pragma mark - 判断条件
-(BOOL)IF{
    BOOL  Y = YES;
    self.MCModel.bank_account_number=  self.bank_account_number.text;
   if (self.MCModel.bank_account_number .length==0) {
    [self showToast:@"请输入正确的银行卡号"];
    return NO;
    }
    if (self.MCModel.bank_branch_no.length==0) {
    [self showToast:@"请选择银行"];
            return NO;
        }
    if (self.MCModel.bank_card_photo			.length==0) {
        [self showToast:@"请上传银行卡正面照"];
        return NO;
    }
        
    return Y;
}


#pragma mark - 选择银行卡
- (IBAction)bank_card_photoBtnAction:(UIButton *)sender {
    [self.view endEditing:YES];
    ImageChooseVC* VC = [[ImageChooseVC alloc]initWithNibName:@"ImageChooseVC" bundle:nil];
    VC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    VC.imageType= OriginalImage;
    __weak typeof(self) weakSelf = self;
    
    VC.ImageChooseVCBlock =^(UIImage *image){
        NSLog(@"%@",image);
        _isBank_card_photo  = YES;
        weakSelf.bank_card_photo.image = image;
    };
    [self presentViewController:VC animated:NO completion:^{
    }];
    
}
#pragma mark - 上传选择银行卡
- (IBAction)Upbank_card_photoBtnAction:(UIButton *)sender {
    
    
    [self.view endEditing:YES];
    if (self.isBank_card_photo ==YES) {
        __weak typeof(self) weakSelf = self;
        [self.bank_card_photoBtn setImage:[UIImage  sd_animatedGIFNamed:[NSString stringWithFormat: @"兑富宝加载等待图" ]] forState:(UIControlStateNormal)];
        self.bank_card_photoBtn.userInteractionEnabled = NO;
        sender.userInteractionEnabled = NO;
        [[DWHelper shareHelper] UPImageToServer:@[self. bank_card_photo.image] toKb:70 success:^(NSArray* urlArr) {
            NSDictionary * dic = urlArr[0];
            weakSelf.MCModel.bank_card_photo = dic[@"url"];
            [weakSelf.bank_card_photoBtn setImage:IMG_Name(@"")forState:(UIControlStateNormal)];
            weakSelf.bank_card_photoBtn.userInteractionEnabled = YES;
            sender.userInteractionEnabled = YES;
        } faild:^(id error) {
            [weakSelf.bank_card_photoBtn setImage:IMG_Name(@"")forState:(UIControlStateNormal)];
            weakSelf.bank_card_photoBtn.userInteractionEnabled = YES;
            sender.userInteractionEnabled = YES;
            [weakSelf showToast:@"图片上传失败"];
        }];
    }else{
        [self showToast:@"请选择银行卡正面照"];
    }
    
    
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
