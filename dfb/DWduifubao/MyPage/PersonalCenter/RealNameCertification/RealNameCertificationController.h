//
//  RealNameCertificationController.h
//  DWduifubao
//
//  Created by 月美 刘 on 16/10/11.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "BaseViewController.h"
@class PersonRenZhengModel;
@interface RealNameCertificationController : BaseViewController
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentSizeHeight;
@property (weak, nonatomic) IBOutlet UIImageView *identityCardFacade;   //身份证正面
@property (weak, nonatomic) IBOutlet UIButton *identityCardFacadeBtn;

@property (weak, nonatomic) IBOutlet UIImageView *identityCardBack;     //身份证反面
@property (weak, nonatomic) IBOutlet UIButton *identityCardBackBtn;

@property (weak, nonatomic) IBOutlet UIImageView *bankCardFacade;       //银行卡正面
@property (weak, nonatomic) IBOutlet UIButton *bankCardFacadeBtn;
///银行卡反面
@property (weak, nonatomic) IBOutlet UIImageView *bank_card_back_photo;
@property (weak, nonatomic) IBOutlet UIButton *bank_card_back_photoBtn;

@property (weak, nonatomic) IBOutlet UIImageView *identityAndBankCard;  //手持身份证＋银行卡
@property (weak, nonatomic) IBOutlet UIButton *identityAndBankCardBtn;

//姓名
@property (weak, nonatomic) IBOutlet UITextField *nameTextfield;
//开户行
@property (weak, nonatomic) IBOutlet UIButton *bank_nameBtn;
///支行
@property (weak, nonatomic) IBOutlet UITextField *subbranchTF;

///身份证
@property (weak, nonatomic) IBOutlet UITextField *IDbankTextfield;
///银行卡号
@property (weak, nonatomic) IBOutlet UITextField *bank_account_numbertextf;
///银行卡预留电话
@property (weak, nonatomic) IBOutlet UITextField *reserved_mobile;

///详细地址
@property (weak, nonatomic) IBOutlet EZTextView *address;

///提交
@property (weak, nonatomic) IBOutlet UIButton *SubmitBtn;
///认证拒绝传的Model
 @property (nonatomic, strong) PersonRenZhengModel *perModel ;
@end
