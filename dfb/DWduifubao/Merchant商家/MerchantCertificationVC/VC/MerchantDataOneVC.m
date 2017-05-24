//
//  MerchantDataOneVC.m
//  DWduifubao
//
//  Created by 席亚坤 on 17/3/19.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "MerchantDataOneVC.h"

#import "MerchantDataTwoVC.h"

#import "RegionViewController.h"
#import "MerchantCertificationModel.h"
@interface MerchantDataOneVC ()
@property(nonatomic,assign)BOOL isMerchant_logo;
@property(nonatomic,assign)BOOL isMain_image;
@end

@implementation MerchantDataOneVC
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    self.MCModel.address=  self.address.text;
    self.MCModel.email=  self.email.text;

    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self kongjianfuzhi];
}

-(void)kongjianfuzhi{
    _isMerchant_logo = NO;
    _isMain_image = NO;
    [self.zone setTitle:self.MCModel.zone.length==0 ?@"省市县区":self.MCModel.zone forState:(UIControlStateNormal)];
    self.address.text = self.MCModel.address;
    self.email.text = self.MCModel.email;
    if (self.MCModel.merchant_logo.length !=0){
        [DWHelper SD_WebImage:self.merchant_logo imageUrlStr:self.MCModel.merchant_logo placeholderImage:nil];
        _isMerchant_logo = YES;
        
    }
    if (self.MCModel.main_image.length !=0){
        [DWHelper SD_WebImage:self.main_image imageUrlStr:self.MCModel.main_image placeholderImage:nil];
        _isMain_image = YES;
        
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
    self.title = @"第1步 店铺信息";
    self.address.placeholder = @"请填写详细地址";
    
}
#pragma mark - 关于数据
-(void)SET_DATA{
//    if ([self.edit_type isEqualToString:@"1"]) {
//        _isMain_image = NO;
//        _isMerchant_logo = NO;
//        self.MCModel.merchant_logo.length==0 ? _isMerchant_logo = NO: !_isMerchant_logo ;
//    NSLog(@"%d",_isMerchant_logo);
//        self.MCModel.main_image.length==0 ? _isMain_image = NO: !_isMain_image;
    

//    }else{
//        _isMain_image = YES;
//        _isMerchant_logo = YES;
//
//    }
    
    
}
#pragma mark - 选择省市区
- (IBAction)ChooseZoneAction:(UIButton *)sender {
    [self.view endEditing:YES];
    RegionViewController * VC = [[RegionViewController alloc]initWithNibName:@"RegionViewController" bundle:nil];
    VC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
    [VC ReqionReturn:^(NSDictionary *reqionDic) {
        NSLog(@"---------------------%@",reqionDic);
        [self.zone setTitle:reqionDic[@"name"] forState:(UIControlStateNormal)];
        self.MCModel.zone =reqionDic[@"name"];
        self.MCModel. province_id = reqionDic[@"province_id"];
        self.MCModel.city_id = reqionDic[@"city_id"];
        self.MCModel.region_id = reqionDic[@"region_id"];
        
        
    }];
    [self presentViewController:VC animated:YES completion:^{
    }];

}
#pragma mark - 选择Logo照片
- (IBAction)merchant_logoBtnAction:(UIButton *)sender {
    [self.view endEditing:YES];
   
        ImageChooseVC* VC = [[ImageChooseVC alloc]initWithNibName:@"ImageChooseVC" bundle:nil];
        VC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        VC.imageType= OriginalImage;
        __weak typeof(self) weakSelf = self;
        
        VC.ImageChooseVCBlock =^(UIImage *image){
            NSLog(@"%@",image);
            _isMerchant_logo = YES;

            weakSelf. merchant_logo.image = image;
        };
        [self presentViewController:VC animated:NO completion:^{
        }];
    
   

}
#pragma mark - 上传Logo照片
- (IBAction)UPmerchant_logo:(UIButton *)sender {
    [self.view endEditing:YES];
     if (self.isMerchant_logo ==YES) {
    __weak typeof(self) weakSelf = self;
     [self.merchant_logoBtn setImage:[UIImage  sd_animatedGIFNamed:[NSString stringWithFormat: @"兑富宝加载等待图" ]] forState:(UIControlStateNormal)];
    self.merchant_logoBtn.userInteractionEnabled = NO;
    sender.userInteractionEnabled = NO;
    [[DWHelper shareHelper] UPImageToServer:@[self. merchant_logo.image] toKb:70 success:^(NSArray* urlArr) {
        NSDictionary * dic = urlArr[0];
        weakSelf.MCModel.merchant_logo = dic[@"url"];
        [weakSelf.merchant_logoBtn setImage:IMG_Name(@"")forState:(UIControlStateNormal)];
        weakSelf.merchant_logoBtn.userInteractionEnabled = YES;
        sender.userInteractionEnabled = YES;
    } faild:^(id error) {
         [weakSelf.merchant_logoBtn setImage:IMG_Name(@"")forState:(UIControlStateNormal)];
        weakSelf.merchant_logoBtn.userInteractionEnabled = YES;
        sender.userInteractionEnabled = YES;
        [weakSelf showToast:@"图片上传失败"];
    }];
     }else{
         [self showToast:@"请选择Logo照片"];
     }
}



#pragma mark -选择主图照片
- (IBAction)main_imageBtnAction:(UIButton *)sender {
    
    ImageChooseVC* VC = [[ImageChooseVC alloc]initWithNibName:@"ImageChooseVC" bundle:nil];
    VC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    VC.imageType= OriginalImage;
    __weak typeof(self) weakSelf = self;

    VC.ImageChooseVCBlock =^(UIImage *image){
        NSLog(@"%@",image);
        _isMain_image = YES;

        weakSelf. main_image.image = image;
    };
    [self presentViewController:VC animated:NO completion:^{
    }];
    
}
#pragma mark - 上传主图照片
- (IBAction)UPmain_image:(UIButton *)sender {
    
    [self.view endEditing:YES];
    if (self.isMain_image ==YES) {
    __weak typeof(self) weakSelf = self;
    [self.main_imageBtn setImage:[UIImage  sd_animatedGIFNamed:[NSString stringWithFormat: @"兑富宝加载等待图" ]] forState:(UIControlStateNormal)];
    self.main_imageBtn.userInteractionEnabled = NO;
    sender.userInteractionEnabled = NO;
    [[DWHelper shareHelper] UPImageToServer:@[self. main_image.image] toKb:70 success:^(NSArray* urlArr) {
        NSDictionary * dic = urlArr[0];
        weakSelf.MCModel.main_image = dic[@"url"];
        [weakSelf.main_imageBtn setImage:IMG_Name(@"")forState:(UIControlStateNormal)];
        weakSelf.main_imageBtn.userInteractionEnabled = YES;
        sender.userInteractionEnabled = YES;
    } faild:^(id error) {
        [weakSelf.main_imageBtn setImage:IMG_Name(@"")forState:(UIControlStateNormal)];
        weakSelf.main_imageBtn.userInteractionEnabled = YES;
        sender.userInteractionEnabled = YES;
        [weakSelf showToast:@"图片上传失败"];
    }];
}else{
    [self showToast:@"请选择主图图片"];
}
}



- (IBAction)NextAction:(UIButton *)sender {
    
    if ([self IF]) {
        //Push 跳转
        MerchantDataTwoVC * VC = [[MerchantDataTwoVC alloc]initWithNibName:@"MerchantDataTwoVC" bundle:nil];
        VC.MCModel = self.MCModel;
        VC.edit_type = self.edit_type;
        [self.navigationController  pushViewController:VC animated:YES];
    }
    
    

}
#pragma mark - 判断条件
-(BOOL)IF{
    BOOL  Y = YES;
    self.MCModel.address=  self.address.text;
    self.MCModel.email=  self.email.text;

    if (self.MCModel.province_id .length==0) {
        [self showToast:@"请选择省市区"];
        return NO;
    }
    
    if (self.MCModel.address.length==0) {
      [self showToast:@"请填写详细地址"];
            return NO;
    }
    ;
    if ( ![YanZhengOBject IsEmailAdress:self.MCModel.email]) {
        [self showToast:@"请输入有效邮编"];
        return NO;
    }
    if (self.MCModel.merchant_logo.length==0) {
        [self showToast:@"请上传店铺Logo图片"];
        return NO;
    }
    if (self.MCModel.main_image.length==0) {
        [self showToast:@"请上传店铺主图图片"];
        return NO;
    }
    
    return Y;
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
