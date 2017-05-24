//
//  O2ORealNameVC.h
//  DWduifubao
//
//  Created by 席亚坤 on 16/11/16.
//  Copyright © 2016年 bianming. All rights reserved.
//


#import "BaseViewController.h"
@class PersonRenZhengModel;
@interface O2ORealNameVC : BaseViewController
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentSizeHeight;

@property (weak, nonatomic) IBOutlet UIImageView *identityCardFacade;   //身份证正面
@property (weak, nonatomic) IBOutlet UIImageView *identityCardBack;     //身份证反面
@property (weak, nonatomic) IBOutlet UIImageView *bankCardFacade;       //银行卡正面
@property (weak, nonatomic) IBOutlet UIImageView *identityAndBankCard;  //手持身份证＋银行卡
//姓名
@property (weak, nonatomic) IBOutlet UITextField *nameTextfield;
//开户行
@property (weak, nonatomic) IBOutlet UIButton *bank_nameBtn;


///支行
@property (weak, nonatomic) IBOutlet UITextField *subbranchTextfield;

///身份证
@property (weak, nonatomic) IBOutlet UITextField *IDbankTextfield;
///银行卡号
@property (weak, nonatomic) IBOutlet UITextField *bank_account_numbertextf;
///地区选择
@property (weak, nonatomic) IBOutlet UIButton *zoneBtn;
///提交
@property (weak, nonatomic) IBOutlet UIButton *SubmitBtn;
///认证拒绝传的Model
@property (nonatomic, strong) PersonRenZhengModel *perModel ;
///实名认证收款?提现
@property (nonatomic, strong) NSString  *pushTypeOfO2O ;


@end
