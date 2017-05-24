//
//  PerfectDataController.h
//  DWduifubao
//
//  Created by 月美 刘 on 16/11/1.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "BaseViewController.h"
@class PerfectDataMOdel;

@interface PerfectDataController : BaseViewController
    
///可滑动的高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentSizeHeight;

///"法人身份证正面"的按钮图片
@property (weak, nonatomic) IBOutlet UIImageView *id_card_photo;
///"法人身份证反面"的按钮图片
@property (weak, nonatomic) IBOutlet UIImageView *id_card_back_photo;
///"对公银行卡正面"的按钮图片
@property (weak, nonatomic) IBOutlet UIImageView *bank_card_photo;
///"营业执照"的按钮图片
@property (weak, nonatomic) IBOutlet UIImageView *license_url;

///上传"法人身份证正面"的按钮事件
- (IBAction)id_card_photoBtnAction:(id)sender;
///上传"法人身份证反面"的按钮事件
- (IBAction)id_card_back_photoBtnAction:(id)sender;
///上传"对公银行卡正面"的按钮事件
- (IBAction)bank_card_photoBtnAction:(id)sender;
///上传"营业执照"的按钮事件
- (IBAction)license_urlBtnAction:(id)sender;

///店名
@property (weak, nonatomic) IBOutlet UITextField *merchant_name;
///简介
@property (weak, nonatomic) IBOutlet UITextField *content;
///手机号
@property (weak, nonatomic) IBOutlet UITextField *merchant_mobile;

///开户行
@property (weak, nonatomic) IBOutlet UIButton *bank_name;
///支行
@property (weak, nonatomic) IBOutlet UITextField *subbranch;
///选择"所属行业"的按钮事件
- (IBAction)chooseTradeBtnAction:(id)sender;
///选择"地区"的按钮事件
- (IBAction)chooseAreaBtnAction:(id)sender;
///代理行业
@property (weak, nonatomic) IBOutlet UIButton *industry_id;

///请选择地区
@property (weak, nonatomic) IBOutlet UIButton *zone;

///地址
@property (weak, nonatomic) IBOutlet UITextField *detailAddress;
///收款银行卡
@property (weak, nonatomic) IBOutlet UITextField *bank_account_number;
///身份证号
@property (weak, nonatomic) IBOutlet UITextField *id_card;
///营业执照号码
@property (weak, nonatomic) IBOutlet UITextField *license_no;
///"logo图片"的按钮图片
@property (weak, nonatomic) IBOutlet UIImageView *merchant_logo;
///上传"logo图片"的按钮事件
- (IBAction)logoImageBtnAction:(id)sender;

///"提交"的按钮事件
- (IBAction)submitBtnAction:(id)sender;

///修改/添加
@property (nonatomic, strong) NSString *type ;

@property (weak, nonatomic) IBOutlet UIButton *TiJiaoBtn;

@property(nonatomic,strong) PerfectDataMOdel *perDataModel;





@end
