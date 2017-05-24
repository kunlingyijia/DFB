//
//  BankChangeVC.h
//  DWduifubao
//
//  Created by 席亚坤 on 17/5/22.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "BaseViewController.h"

@class PersonRenZhengModel;
@interface BankChangeVC : BaseViewController
@property (weak, nonatomic) IBOutlet UIImageView *bankCardFacade; //银行卡正面
///银行卡反面
@property (weak, nonatomic) IBOutlet UIImageView *bank_card_back_photo;
//开户行
@property (weak, nonatomic) IBOutlet UIButton *bank_nameBtn;
//支行
@property (weak, nonatomic) IBOutlet UITextField *subbranchTF;
///银行卡号
@property (weak, nonatomic) IBOutlet UITextField *bank_account_numbertextf;
///银行卡预留电话
@property (weak, nonatomic) IBOutlet UITextField *reserved_mobile;
//属性传值

///认证拒绝传的Model
@property (nonatomic, strong) PersonRenZhengModel *perModel ;
@end
