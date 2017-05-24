//
//  O2OWithdrawalViewController.h
//  DWduifubao
//
//  Created by 席亚坤 on 16/11/14.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "BaseViewController.h"
@class  O2OModel;
@interface O2OWithdrawalViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UILabel *draw_moneylabel;
@property (weak, nonatomic) IBOutlet UILabel *bank_account_numberLabel;
@property (weak, nonatomic) IBOutlet UITextField *amountTF;
///属性传值
@property (nonatomic, strong) O2OModel  *TiXianModel ;


@end
