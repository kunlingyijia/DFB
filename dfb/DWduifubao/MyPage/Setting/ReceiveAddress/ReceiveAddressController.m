//
//  ReceiveAddressController.m
//  RiXin
//
//  Created by 月美 刘 on 16/9/30.
//  Copyright © 2016年 月美 刘. All rights reserved.
//

#import "ReceiveAddressController.h"
#import "AddressManageController.h"
#import "CityModel.h"
#import "AddressModel.h"
#import "RegionViewController.h"
@interface ReceiveAddressController ()<UIPickerViewDataSource, UIPickerViewDelegate>
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
//默认0-否，1-是
@property(nonatomic,assign)int is_default;
@property(nonatomic,strong)NSString *act;
@property(nonatomic,strong)NSString *address_id;

@end

@implementation ReceiveAddressController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showBackBtn];
    self.is_default = 0;
    self.title = @"新建收货地址";
    self.view.backgroundColor = [UIColor colorWithHexString:kViewBackgroundColor];
    //self.MorenSwitch.on = YES ;
    //地区选择 数据配置
    [self DiQuPeiZhiAction];
    if ([self.Type isEqualToString:@"编辑"]) {
         self.name.text  =self.addressModel.name;
         self.phone.text = self.addressModel.mobile;
         self.plateNo.text =self.addressModel.postcode;
        [self.chooseAreaBtn setTitle: self.addressModel.zone forState:(UIControlStateNormal)];
         self.detail.text = self.addressModel.address;
        self.is_default = [self.addressModel.is_default intValue];
        if (self.is_default ==1) {
         self.MorenSwitch.on = YES ;
        }

        self.address_id = self.addressModel.address_id;
        
        
    }
    
}
//默认点击事件
- (IBAction)morenSwitchAction:(UISwitch *)sender {
    [self.view endEditing:YES];
#pragma mark -开关点击事件
        BOOL isButtonOn = [sender isOn];
        if (isButtonOn) {
            //NSLog(@"开");
            
            self.is_default = 1;
        }else {
            //NSLog(@"关");
            self.is_default = 0;

        }
        
   

    
}


//“保存”的按钮事件
- (IBAction)saveBtnAction:(UIButton *)sender {
    [self.view endEditing:YES];

    if (self.name.text.length == 0) {
        [self showToast:@"姓名不能为空"];
        return;
    }
    if ([YanZhengOBject IsPhoneNumber:self.phone.text]==NO) {
        [self showToast:@"手机号输入错误"];
        return;
        
    }
    if ([YanZhengOBject isValidZipcode:self.plateNo.text] == NO) {
        [self showToast:@"邮编输入错误"];
        return;
        
    }
    if ([self.chooseAreaBtn.titleLabel.text isEqualToString:@"请选择地区"]) {
        [self showToast:@"请选择地区"];
        return;
    }
    if (self.detail.text.length ==0) {
        [self showToast:@"请填写详情"];
        return;
        
    }
   
    if ([self.Type isEqualToString:@"增加"] ) {
        //增加网络请求
       // [self requestActionTwo];
        [self requestAction:Request_AddAddress];
    }
    
    if ([self.Type isEqualToString:@"编辑"]) {
        //修改网络请求
        [self requestAction:Request_UpdateAddress];
    }
    
}
//修改地址网络请求//增加地址网络请求
-(void)requestAction:(NSString*)act{
    
    AddressModel * model = [[AddressModel alloc]init];
    model.address_id = self.address_id;
    model.name = self.name.text;
    model.mobile = self.phone.text;
    model.postcode = self.plateNo.text;
    model.zone = self.chooseAreaBtn.titleLabel.text;
    model.address = self.detail.text;
    model.is_default =[NSString stringWithFormat:@"%d", self.is_default];
    NSString *Token =[AuthenticationModel getLoginToken];
       if (Token.length!= 0) {
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.token = [AuthenticationModel getLoginToken];
        baseReq.encryptionType = AES;
        baseReq.data = [AESCrypt encrypt:[[model yy_modelToJSONObject ] yy_modelToJSONString ]password:[AuthenticationModel getLoginKey]];
        __weak typeof(self) weakSelf = self;
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:act sign:[baseReq.data MD5Hash] requestMethod:GET PushVC:self success:^(id response) {
            BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
            if (baseRes.resultCode == 1) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }else {
                [weakSelf showToast:response[@"msg"]];
            }
            
        } faild:^(id error) {
            NSLog(@"%@", error);
        }];
        
    }else {
        
    }
    
    
    
}


#pragma mark - 地区选择
//“选择省、市、区”的按钮事件
- (IBAction)chooseAreaBtnAction:(UIButton *)sender {
    [self.view endEditing:YES];
    //调用
    [self createPickerView];
    
}

-(void)DiQuPeiZhiAction{
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
            [self.chooseAreaBtn setTitleColor:[UIColor colorWithHexString:kTitleColor] forState:UIControlStateNormal];
            [self.chooseAreaBtn setTitle:[NSString stringWithFormat:@"%@ %@", firstModel.regionName, self.cityModel.regionName] forState:UIControlStateNormal];
        }else {
            [self.chooseAreaBtn setTitleColor:[UIColor colorWithHexString:kTitleColor] forState:UIControlStateNormal];
            [self.chooseAreaBtn setTitle:[NSString stringWithFormat:@"%@ %@ %@", firstModel.regionName, secondModel.regionName, self.cityModel.regionName] forState:UIControlStateNormal];
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
