//
//  PayViewController.h
//  DWduifubao
//
//  Created by 席亚坤 on 16/11/1.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "BaseViewController.h"

@interface PayViewController : BaseViewController

///输入金额
@property (weak, nonatomic) IBOutlet UITextField *MoneyTextfield;
///支付宝选择按钮
@property (weak, nonatomic) IBOutlet UIButton *ZhiFuBaoBtn;
///微信选择按钮
@property (weak, nonatomic) IBOutlet UIButton *WXBtn;

///确认支付按钮
@property (weak, nonatomic) IBOutlet UIButton *BuyBtn;

@end
