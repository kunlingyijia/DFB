//
//  BankNewChangeViewController.h
//  DWduifubao
//
//  Created by 席亚坤 on 16/11/30.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "BaseViewController.h"

@interface BankNewChangeViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIImageView *bankCardFacade;       //银行卡正面
//开户行
@property (weak, nonatomic) IBOutlet UIButton *bank_nameBtn;
///银行卡号
@property (weak, nonatomic) IBOutlet UITextField *bank_account_numbertextf;
///修改银行银行卡按钮
@property (weak, nonatomic) IBOutlet UIButton *ChangBankBtn;


@end
