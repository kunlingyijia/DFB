//
//  MerchantDataTwoVC.m
//  DWduifubao
//
//  Created by 席亚坤 on 17/3/19.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "MerchantDataTwoVC.h"
#import "MerchantDataThreeVC.h"
#import "MerchantCertificationModel.h"
@interface MerchantDataTwoVC ()
@property(nonatomic,assign)BOOL isId_card_photo;
@property(nonatomic,assign)BOOL isId_card_back_photo;
@property(nonatomic,assign)BOOL isLicense_url;
@end

@implementation MerchantDataTwoVC

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    self.MCModel.account_name=  self.account_name.text;
    self.MCModel.id_card=  self.id_card.text;
    self.MCModel.license_no=  self.license_no.text;
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self kongjianfuzhi];
}

-(void)kongjianfuzhi{
    _isId_card_photo = NO;
    _isId_card_back_photo = NO;
    _isLicense_url= NO;
//    [self.zone setTitle:self.MCModel.zone.length==0 ?@"省市县区":self.MCModel.zone forState:(UIControlStateNormal)];
    self.account_name.text = self.MCModel.account_name;
    self.id_card.text = self.MCModel.id_card;
    self.license_no.text = self.MCModel.license_no;
    if (self.MCModel.id_card_photo.length !=0){
        [DWHelper SD_WebImage:self.id_card_photo imageUrlStr:self.MCModel.id_card_photo placeholderImage:nil];
        _isId_card_photo = YES;
        
    }
    if (self.MCModel.id_card_back_photo.length !=0){
        [DWHelper SD_WebImage:self.id_card_back_photo imageUrlStr:self.MCModel.id_card_back_photo placeholderImage:nil];
        _isId_card_back_photo = YES;
        
    }
    if (self.MCModel.license_url.length !=0){
        [DWHelper SD_WebImage:self.license_url imageUrlStr:self.MCModel.license_url placeholderImage:nil];
        _isLicense_url = YES;
        
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
    self.title = @"第2步 资质信息";
    
    
}
#pragma mark - 关于数据
-(void)SET_DATA{
    
    
}
#pragma mark - 下一步
- (IBAction)NextAction:(UIButton *)sender {
    if ([self IF]) {
        //Push 跳转
        MerchantDataThreeVC * VC = [[MerchantDataThreeVC alloc]initWithNibName:@"MerchantDataThreeVC" bundle:nil];
        VC.MCModel = self.MCModel;
        VC.edit_type = self.edit_type;
        [self.navigationController  pushViewController:VC animated:YES];
    }
    

    
    
}
#pragma mark - 判断条件
-(BOOL)IF{
    BOOL  Y = YES;
    self.MCModel.account_name=  self.account_name.text;
    self.MCModel.id_card=  self.id_card.text;
    self.MCModel.license_no=  self.license_no.text;
   
    if (self.MCModel.id_card_photo .length==0) {
        [self showToast:@"请上传法人身份证正面照"];
        return NO;
    }
    
    if (self.MCModel.id_card_back_photo.length==0) {
        [self showToast:@"请上传法人身份证反面照"];
        return NO;
    }
    if (self.MCModel.account_name			.length==0) {
        [self showToast:@"请输入法人真实姓名"];
        return NO;
    }

    if (![YanZhengOBject isIDCorrect:self.MCModel.id_card]) {
        [self showToast:@"请输入正确的身份证号"];
        return NO;
    }
    if (self.MCModel.license_url.length==0) {
            [self showToast:@"请上传营业执照图片"];
            return NO;
        }
    if (self.MCModel.license_no.length==0) {
            [self showToast:@"请输入营业执照注册号"];
            return NO;
        }
    
    return Y;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 选择银行卡正面照
- (IBAction)id_card_photoBtnAction:(UIButton *)sender {
    [self.view endEditing:YES];
    ImageChooseVC* VC = [[ImageChooseVC alloc]initWithNibName:@"ImageChooseVC" bundle:nil];
    VC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    VC.imageType= OriginalImage;
    __weak typeof(self) weakSelf = self;
    
    VC.ImageChooseVCBlock =^(UIImage *image){
        NSLog(@"%@",image);
        _isId_card_photo  = YES;
        weakSelf. id_card_photo.image = image;
    };
    [self presentViewController:VC animated:NO completion:^{
    }];
    

}
#pragma mark - 上传银行卡正面照
- (IBAction)UPid_card_photoBtnAction:(UIButton *)sender {
    
    [self.view endEditing:YES];
    if (self.isId_card_photo ==YES) {
        __weak typeof(self) weakSelf = self;
        [self.id_card_photoBtn setImage:[UIImage  sd_animatedGIFNamed:[NSString stringWithFormat: @"兑富宝加载等待图" ]] forState:(UIControlStateNormal)];
        self.id_card_photoBtn.userInteractionEnabled = NO;
        sender.userInteractionEnabled = NO;
        [[DWHelper shareHelper] UPImageToServer:@[self. id_card_photo.image] toKb:70 success:^(NSArray* urlArr) {
            NSDictionary * dic = urlArr[0];
            weakSelf.MCModel.id_card_photo = dic[@"url"];
            [weakSelf.id_card_photoBtn setImage:IMG_Name(@"")forState:(UIControlStateNormal)];
            weakSelf.id_card_photoBtn.userInteractionEnabled = YES;
            sender.userInteractionEnabled = YES;
        } faild:^(id error) {
            [weakSelf.id_card_photoBtn setImage:IMG_Name(@"")forState:(UIControlStateNormal)];
            weakSelf.id_card_photoBtn.userInteractionEnabled = YES;
            sender.userInteractionEnabled = YES;
            [weakSelf showToast:@"图片上传失败"];
        }];
    }else{
        [self showToast:@"请选择银行卡正面照"];
    }

    
    
}

#pragma mark - 选择银行卡反面照
- (IBAction)id_card_back_photoBtnAction:(UIButton *)sender {
    [self.view endEditing:YES];
    ImageChooseVC* VC = [[ImageChooseVC alloc]initWithNibName:@"ImageChooseVC" bundle:nil];
    VC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    VC.imageType= OriginalImage;
    __weak typeof(self) weakSelf = self;
    
    VC.ImageChooseVCBlock =^(UIImage *image){
        NSLog(@"%@",image);
        _isId_card_back_photo  = YES;
        weakSelf. id_card_back_photo.image = image;
    };
    [self presentViewController:VC animated:NO completion:^{
    }];

}
#pragma mark - 上传银行卡反面照
- (IBAction)UPid_card_back_photoBtnAction:(UIButton *)sender {
    
    [self.view endEditing:YES];
    if (self.isId_card_back_photo ==YES) {
        __weak typeof(self) weakSelf = self;
        [self.id_card_back_photoBtn setImage:[UIImage  sd_animatedGIFNamed:[NSString stringWithFormat: @"兑富宝加载等待图" ]] forState:(UIControlStateNormal)];
        self.id_card_back_photoBtn.userInteractionEnabled = NO;
        sender.userInteractionEnabled = NO;
        [[DWHelper shareHelper] UPImageToServer:@[self. id_card_back_photo.image] toKb:70 success:^(NSArray* urlArr) {
            NSDictionary * dic = urlArr[0];
            weakSelf.MCModel.id_card_back_photo = dic[@"url"];
            [weakSelf.id_card_back_photoBtn setImage:IMG_Name(@"")forState:(UIControlStateNormal)];
            weakSelf.id_card_back_photoBtn.userInteractionEnabled = YES;
            sender.userInteractionEnabled = YES;
        } faild:^(id error) {
            [weakSelf.id_card_back_photoBtn setImage:IMG_Name(@"")forState:(UIControlStateNormal)];
            weakSelf.id_card_back_photoBtn.userInteractionEnabled = YES;
            sender.userInteractionEnabled = YES;
            [weakSelf showToast:@"图片上传失败"];
        }];
    }else{
        [self showToast:@"请选择银行卡反面照"];
    }

    
    
    
}
#pragma mark - 选择营业执照
- (IBAction)license_urlBtnAction:(UIButton *)sender {
    [self.view endEditing:YES];
    ImageChooseVC* VC = [[ImageChooseVC alloc]initWithNibName:@"ImageChooseVC" bundle:nil];
    VC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    VC.imageType= OriginalImage;
    __weak typeof(self) weakSelf = self;
    
    VC.ImageChooseVCBlock =^(UIImage *image){
        NSLog(@"%@",image);
        _isLicense_url  = YES;
        weakSelf. license_url.image = image;
    };
    [self presentViewController:VC animated:NO completion:^{
    }];
    
}
#pragma mark - 上传营业执照
- (IBAction)Uplicense_urlBtnAction:(UIButton *)sender {
    
    
    [self.view endEditing:YES];
    if (self.isLicense_url ==YES) {
        __weak typeof(self) weakSelf = self;
        [self.license_urlBtn setImage:[UIImage  sd_animatedGIFNamed:[NSString stringWithFormat: @"兑富宝加载等待图" ]] forState:(UIControlStateNormal)];
        self.license_urlBtn.userInteractionEnabled = NO;
        sender.userInteractionEnabled = NO;
        [[DWHelper shareHelper] UPImageToServer:@[self. license_url.image] toKb:70 success:^(NSArray* urlArr) {
            NSDictionary * dic = urlArr[0];
            weakSelf.MCModel.license_url = dic[@"url"];
            [weakSelf.license_urlBtn setImage:IMG_Name(@"")forState:(UIControlStateNormal)];
            weakSelf.license_urlBtn.userInteractionEnabled = YES;
            sender.userInteractionEnabled = YES;
        } faild:^(id error) {
            [weakSelf.license_urlBtn setImage:IMG_Name(@"")forState:(UIControlStateNormal)];
            weakSelf.license_urlBtn.userInteractionEnabled = YES;
            sender.userInteractionEnabled = YES;
            [weakSelf showToast:@"图片上传失败"];
        }];
    }else{
        [self showToast:@"请选择营业执照"];
    }

    
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
