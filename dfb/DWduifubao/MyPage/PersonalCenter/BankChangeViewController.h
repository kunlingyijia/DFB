//
//  BankChangeViewController.h
//  DWduifubao
//
//  Created by 席亚坤 on 16/11/3.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "BaseViewController.h"
@class PersonRenZhengModel;
@interface BankChangeViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIView *DiBuView;
@property (weak, nonatomic) IBOutlet UIImageView *bankCardFacade; //银行卡正面
//开户行
@property (weak, nonatomic) IBOutlet UIButton *bank_nameBtn;
//支行
@property (weak, nonatomic) IBOutlet UITextField *subbranchTF;
///银行卡号
@property (weak, nonatomic) IBOutlet UITextField *bank_account_numbertextf;
//属性传值

///认证拒绝传的Model
@property (nonatomic, strong) PersonRenZhengModel *perModel ;

@end
