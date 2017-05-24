//
//  RegisterController.m
//  DWduifubao
//
//  Created by 月美 刘 on 16/9/12.
//  Copyright © 2016年 月美 刘. All rights reserved.
//

#import "RegisterController.h"
#import "UIColor+DWColor.h"
#import "RequestVerifyCode.h"
#import "RequestRegister.h"
#import "CityModel.h"
#import "MyPageController.h"
#import "LoginController.h"
#import "RegistrationAgreementViewController.h"
#import "GestureSettingViewController.h"
#import "ArticleVC.h"
@interface RegisterController ()<UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) NSMutableArray *firstDataSource;
@property (nonatomic, strong) NSMutableArray *secondDataSource;
@property (nonatomic, strong) NSMutableArray *secondCity;
@property (nonatomic, strong) NSMutableArray *thirdDataSource;
@property (nonatomic, strong) NSMutableArray *thirdCity;
@property (nonatomic, assign) NSInteger firstRegionID;
@property (nonatomic, assign) NSInteger secondRegionID;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *pickerBgView;
@property (nonatomic, assign) NSInteger firstIndex;
@property (nonatomic, assign) NSInteger secondIndex;
@property (nonatomic, assign) NSInteger thirdIndex;
@property (nonatomic, strong) CityModel *cityModel;
@property (nonatomic, strong) CityModel *provinceModel;
@property (nonatomic, strong) CityModel *secondModel;
@property (nonatomic, strong) UIButton *imageBtn;


@end

@implementation RegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showBackBtn];
    self.title = @"手机快速注册";

    self.view.backgroundColor = [UIColor colorWithHexString:kViewBackgroundColor];
    
    self.firstIndex = 0;
    self.secondIndex = 0;
    self.thirdIndex = 0;
    for (NSDictionary *dic in [DWHelper getCityData]) {
        CityModel *model = [CityModel yy_modelWithDictionary:dic];
        if (model.regionType == 1) {
            [self.firstDataSource addObject:model];
        }else if (model.regionType == 2) {
            [self.secondDataSource addObject:model];
        }else if (model.regionType == 3||model.regionType == 4) {
            [self.thirdDataSource addObject:model];
        }
    }
    CityModel *beijingModel = [self.firstDataSource objectAtIndex:0];
    for (CityModel *model in self.secondDataSource) {
        if (beijingModel.regionId == model.superId) {
            [self.secondCity addObject:model];
        }
    }
    CityModel *secondModel = self.secondCity[0];
    for (CityModel *model in self.thirdDataSource) {
        if (secondModel.regionId == model.superId) {
            [self.thirdCity addObject:model];
        }
    }
}

#pragma mark -//设置View的边框
- (void)setViewStyle:(UIView *)view {
    view.layer.borderWidth = 1;
    view.layer.borderColor = [UIColor colorWithHexString:@"#eeeeee"].CGColor;
}

#pragma mark -//"获取验证码"的事件
- (IBAction)getVerificationCodeBtnAction:(id)sender {
    __weak typeof(self) weakSelf = self;

    if ([self.phoneNumber.text isPhoneNumber]) {
        UIButton *btn = sender;
        btn.backgroundColor = [UIColor whiteColor];
        btn.userInteractionEnabled = NO;
        //    self.authCode.userInteractionEnabled = YES;
        //    self.promptLabel.text = @"接受短信大约需要60秒";
        __block int timeout=60; //倒计时时间
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
        dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
        dispatch_source_set_event_handler(_timer, ^{
            if(timeout<=0){ //倒计时结束，关闭
                //倒计时结束 改变颜色
                dispatch_source_cancel(_timer);
                dispatch_async(dispatch_get_main_queue(), ^{
                    //设置界面的按钮显示 根据自己需求设置
                    [btn setTitle:@"发送验证码" forState:UIControlStateNormal];
                    btn.userInteractionEnabled = YES;
                });
            }else{
                int seconds = timeout % 120;
                NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
                dispatch_async(dispatch_get_main_queue(), ^{
                    //设置界面的按钮显示 根据自己需求设置
                    //NSLog(@"____%@",strTime);
                    [UIView beginAnimations:nil context:nil];
                    [UIView setAnimationDuration:1];
                    [btn setTitle:[NSString stringWithFormat:@"%@秒",strTime] forState:UIControlStateNormal];
                    [UIView commitAnimations];
                    btn.userInteractionEnabled = NO;
                });
                timeout--;
            }
        });
        dispatch_resume(_timer);
        
        RequestVerifyCode *verifyCode = [[RequestVerifyCode alloc] init];
        verifyCode.mobile = self.phoneNumber.text;
        verifyCode.type = 1;
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.data = [verifyCode yy_modelToJSONObject];
        baseReq.encryptionType = RequestMD5;
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:Request_Code sign:[[baseReq.data yy_modelToJSONString] MD5Hash] requestMethod:GET PushVC:self success:^(id response) {
           
            BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
            if (baseRes.resultCode == 1) {
                [weakSelf showToast:@"获取验证码成功"];

            }else {
                [self showToast:response[@"msg"]];
            }

 
        } faild:^(id error) {
           
        }];
        
    }
}

#pragma mark -//"眼睛"的事件
- (IBAction)eyeBtnAction:(id)sender {
    UIButton *btn = sender;
    if (btn.selected) {
        self.passwordText.secureTextEntry = YES;
        btn.selected = NO;
    }else {
        self.passwordText.secureTextEntry = NO;
        btn.selected = YES;
    }
}

#pragma mark -//"地区选择"的事件
- (IBAction)selectAreaBtnAction:(id)sender {
    [self.view endEditing:YES];
    
    [self createPickerView];
}

#pragma mark - "注册协议"的事件
- (IBAction)registrationProtocolBtnAction:(id)sender {
    //Push 跳转
//    RegistrationAgreementViewController * VC = [[RegistrationAgreementViewController alloc]init];
//    [self.navigationController  pushViewController:VC animated:YES];
    //4-注册协议 5-权益说明 7-O2O收款说明

    ArticleVC * VC = [[ArticleVC alloc]initWithNibName:@"ArticleVC" bundle:nil];
    VC.type = @"4";
    [self.navigationController  pushViewController:VC animated:YES];

}

#pragma mark -//"注册"的事件
- (IBAction)registerBtnAction:(id)sender {
    if ([self.phoneNumber.text isPhoneNumber] ==NO) {
        [self showToast:@"手机号码格式不正确"];
        return;
    }
    if (self.verificationCode.text.length == 0) {
        
        [self showToast:@"验证码格式不正确"];
        return;
    }
//    if (![YanZhengOBject IsPassword:self.passwordText.text]) {
//      [self showToast:@"密码为6-16(字母,数字)"];
//        return;
//    }
    if (self.passwordText.text.length <6||self.passwordText.text.length >16) {
        [self showToast:@"密码为6-16(字母,数字,下划线)"];
        return;
    }
    if (self.recommendCode.text.length == 0) {
        [self showToast:@"邀请码不能为空"];
        return;
    } if ([self.adressBtn.titleLabel.text isEqualToString:@"请地区选择"]) {
        [self showToast:@"请选择地区"];
        return;
    }
//    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
//    [SVProgressHUD showWithStatus:@"加载中..."];
        RequestRegister *regist = [[RequestRegister alloc] init];
        regist.mobile = self.phoneNumber.text;
        regist.verify_code = self.verificationCode.text;
        regist.inviter_code = self.recommendCode.text;
        regist.password = self.passwordText.text;
        regist.region_id = self.cityModel.regionId;
        regist.province_id = self.provinceModel.regionId;
        regist.city_id = self.secondModel.regionId;
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.encryptionType = RequestMD5;
        baseReq.data = regist;
         __weak typeof(self) weakself = self;
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:Request_Register sign:[[baseReq.data yy_modelToJSONString] MD5Hash] requestMethod:GET PushVC:self success:^(id response) {
            NSLog(@"response:%@",response);
            BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
            if (baseRes.resultCode == 1) {
                NSDictionary *dic = baseRes.data;
                NSUserDefaults *userDefau = [NSUserDefaults standardUserDefaults];
                [userDefau setObject:dic[@"key"] forKey:@"loginKey"];
                [userDefau setObject:dic[@"token"] forKey:@"loginToken"];
                [userDefau setObject:regist.mobile forKey:@"user_moblie"];
                [userDefau setObject:regist.password forKey:@"user_password"];
                NSLog(@"%@",[AuthenticationModel getPhoneNumber]);
                [BackgroundService requestPushVC:nil MyselfAction:^{
                    NSString * is_handle_password = [NSString stringWithFormat:@"%@",[AuthenticationModel getis_handle_password]];
                    NSLog(@"手势---%@",is_handle_password);
                    if ([is_handle_password  isEqualToString:@"0"]) {
                        //Push 跳转
                        GestureSettingViewController * VC = [[GestureSettingViewController alloc]initWithNibName:@"GestureSettingViewController" bundle:nil];
                        [weakself.navigationController  pushViewController:VC animated:YES];
                        
                    }else{
                        DWTabBarController* tabbar = [[DWTabBarController alloc]init];
                        [tabbar setSelectedIndex:3];
                        [weakself presentViewController:tabbar animated:NO completion:NULL];
                    }

                }];
                //请求配置信息网络请求
               // [weakself PeizhiRequestAction];
                [BackgroundService PeizhiPushVC:nil RequestAction:^{
                    


                }];
                
            }else {
                [self showToast:response[@"msg"]];
            }
        } faild:^(id error) {
             NSLog(@"error:%@", error);
        }];
    }

#pragma mark -//"联系客服"的事件
- (IBAction)contactCustomerServiceBtnAction:(id)sender {
    [[DWHelper shareHelper]CallPhoneNumber:@"400-0781-836" inView:self.view];
    
}

#pragma mark - 地区选择
- (void)createPickerView {
    self.bgView = [[UIView alloc] initWithFrame:Bounds];
    self.bgView.backgroundColor = [UIColor blackColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(canaelTapAction:)];
    [self.bgView addGestureRecognizer:tap];
    
    self.bgView.alpha = 0.2;
    [self.view addSubview:self.bgView];
    self.pickerBgView = [[UIView alloc] initWithFrame:CGRectMake(0, Height, Width, 300)];
    self.pickerBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.pickerBgView];
    self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 30, [UIScreen mainScreen].bounds.size.width, 170)];
    self.pickerView.userInteractionEnabled = YES;
    self.pickerView.backgroundColor = [UIColor whiteColor];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    [self.pickerView selectRow:self.firstIndex inComponent:0 animated:NO];
    [self.pickerView selectRow:self.secondIndex inComponent:1 animated:NO];
    [self.pickerView selectRow:self.thirdIndex inComponent:2 animated:NO];
    [self.pickerBgView addSubview:self.pickerView];
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor whiteColor];
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(sureAction:) forControlEvents:UIControlEventTouchUpInside];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [btn setTitleColor:[UIColor colorWithHexString:kRedColor] forState:UIControlStateNormal];
    [self.pickerBgView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pickerBgView);
        make.right.equalTo(self.pickerBgView).with.offset(-10);
        make.size.mas_equalTo(CGSizeMake(Width/2, 30));
        
    }];
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.backgroundColor = [UIColor whiteColor];
    cancelBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setTitleColor:[UIColor colorWithHexString:kRedColor] forState:UIControlStateNormal];
    [self.pickerBgView addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pickerBgView);
        make.left.equalTo(self.pickerBgView).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(Width/2, 30));
    }];
    [UIView animateWithDuration:0.5 animations:^{
        self.pickerBgView.frame = CGRectMake(0, Height - 300, Width, 300);
    } completion:^(BOOL finished) {
        
    }];
}



- (void)sureAction:(UIButton *)sender {
    if (self.thirdCity.count == 0 || self.secondCity.count == 0) {
        
    }else {
        self.cityModel = self.thirdCity[self.thirdIndex];
        self.secondModel = self.secondCity[self.secondIndex];
        self.provinceModel = self.firstDataSource[self.firstIndex];
        
        CityModel *firstModel = self.firstDataSource[self.firstIndex];
        CityModel *secondModel = self.secondCity[self.secondIndex];
        
        if ([secondModel.regionName isEqualToString:@"北京市"]) {
            [self.adressBtn setTitleColor:[UIColor colorWithHexString:kTitleColor] forState:UIControlStateNormal];
            [self.adressBtn setTitle:[NSString stringWithFormat:@"%@ %@", firstModel.regionName, self.cityModel.regionName] forState:UIControlStateNormal];
        }else {
            [self.adressBtn setTitleColor:[UIColor colorWithHexString:kTitleColor] forState:UIControlStateNormal];
            [self.adressBtn setTitle:[NSString stringWithFormat:@"%@ %@ %@", firstModel.regionName, secondModel.regionName, self.cityModel.regionName] forState:UIControlStateNormal];
        }
    }
    [UIView animateWithDuration:0.5 animations:^{
        self.pickerBgView.frame = CGRectMake(0, Height, Width, 200);
    } completion:^(BOOL finished) {
        [self.bgView removeFromSuperview];
        [self.pickerBgView removeFromSuperview];
    }];
}

- (void)cancelAction:(UIButton *)sender {
    [UIView animateWithDuration:0.5 animations:^{
        self.pickerBgView.frame = CGRectMake(0, Height, Width, 200);
    } completion:^(BOOL finished) {
        [self.bgView removeFromSuperview];
        [self.pickerBgView removeFromSuperview];
    }];
}
- (void)canaelTapAction:(UITapGestureRecognizer *)sender {
    [UIView animateWithDuration:0.5 animations:^{
        self.pickerBgView.frame = CGRectMake(0, Height, Width, 200);
    } completion:^(BOOL finished) {
        [self.bgView removeFromSuperview];
        [self.pickerBgView removeFromSuperview];
    }];
}
#pragma mark - UIPickerViewDelegate
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component __TVOS_PROHIBITED {
    if (component == 0) {
        CityModel *model = self.firstDataSource[row];
        return model.regionName;
    }else if (component == 1) {
        CityModel *model = self.secondCity[row];
        return model.regionName;
    }else {
        CityModel *model = self.thirdCity[row];
        return model.regionName;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view __TVOS_PROHIBITED {
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        // Setup label properties - frame, font, colors etc
        //adjustsFontSizeToFitWidth property to YES
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        pickerLabel.textAlignment = NSTextAlignmentCenter;
        pickerLabel.textColor = [UIColor colorWithHexString:kTitleColor];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:14]];
    }
    // Fill the label text here
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    //    if (self.thirdCity.count == 0 && self.secondCity.count != 0) {
    //        return 2;
    //    }
    //    if (self.secondCity.count == 0) {
    //        return 1;
    //    }
    return 3;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        NSLog(@"%ld", self.firstDataSource.count);
        return self.firstDataSource.count;
    }else if (component == 1) {
        return self.secondCity.count;
    }else {
        return self.thirdCity.count;
    }
    return 10;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component __TVOS_PROHIBITED {
    return 44;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component __TVOS_PROHIBITED {
    if (component == 0) {
        self.firstIndex = row;
        CityModel *model = self.firstDataSource[row];
        [self.secondCity removeAllObjects];
        [self.thirdCity removeAllObjects];
        
        if (row == 0) {
            CityModel *beijingModel = [self.firstDataSource objectAtIndex:0];
            for (CityModel *model in self.secondDataSource) {
                if (beijingModel.regionId == model.superId) {
                    [self.secondCity addObject:model];
                }
            }
            CityModel *secondModel = self.secondCity[0];
            for (CityModel *model in self.thirdDataSource) {
                if (secondModel.regionId == model.superId) {
                    [self.thirdCity addObject:model];
                }
            }
        }else {
            self.firstRegionID = model.regionId;
            for (CityModel *addressModel in self.secondDataSource) {
                if (addressModel.superId == model.regionId) {
                    [self.secondCity addObject:addressModel];
                }
            }
            CityModel *secondModel = self.secondCity[0];
            for (CityModel *thirdModel in self.thirdDataSource) {
                if (secondModel.regionId == thirdModel.superId) {
                    [self.thirdCity addObject:thirdModel];
                }
            }
            [self.pickerView selectRow:0 inComponent:1 animated:YES];
            
        }
        [self.pickerView reloadAllComponents];
    }else if (component == 1) {
        [self.thirdCity removeAllObjects];
        self.secondIndex = row;
        CityModel *model = self.secondCity[row];
        self.secondRegionID = model.regionId;
        for (CityModel *addressModel in self.thirdDataSource) {
            if (addressModel.superId == model.regionId) {
                [self.thirdCity addObject:addressModel];
            }
        }
        [self.pickerView selectRow:0 inComponent:2 animated:YES];
        [self.pickerView reloadAllComponents];
    }else {
        self.thirdIndex = row;
    }
}

- (NSMutableArray *)firstDataSource {
    if (!_firstDataSource) {
        self.firstDataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _firstDataSource;
}
- (NSMutableArray *)secondDataSource {
    if (!_secondDataSource) {
        self.secondDataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _secondDataSource;
}
- (NSMutableArray *)thirdDataSource {
    if (!_thirdDataSource) {
        self.thirdDataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _thirdDataSource;
}
- (NSMutableArray *)secondCity {
    if (!_secondCity) {
        self.secondCity = [NSMutableArray arrayWithCapacity:0];
    }
    return _secondCity;
}
- (NSMutableArray *)thirdCity {
    if (!_thirdCity) {
        self.thirdCity = [NSMutableArray arrayWithCapacity:0];
    }
    return _thirdCity;
}


@end
