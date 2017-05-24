//
//  ExchangeGoldVC.h
//  DWduifubao
//
//  Created by 席亚坤 on 17/3/27.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "BaseViewController.h"

@interface ExchangeGoldVC : BaseViewController
@property (weak, nonatomic) IBOutlet UILabel *cash;              //总金额
@property (weak, nonatomic) IBOutlet UITextField *exchangeCash;  //兑换现金
@property (weak, nonatomic) IBOutlet UITextField *to_dfglod;      //获得兑富金币

///属性传值
@property (nonatomic, assign) CGFloat virtual_glodAndcash;
@property (weak, nonatomic) IBOutlet UITextView *XianshiLabel;
@end
