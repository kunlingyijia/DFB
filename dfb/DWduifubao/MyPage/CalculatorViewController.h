//
//  CalculatorViewController.h
//  DWduifubao
//
//  Created by 席亚坤 on 16/11/14.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "BaseViewController.h"
@class CalulatorBtn;
@class O2OModel;
@interface CalculatorViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITextField *Textfield;
@property (weak, nonatomic) IBOutlet CalulatorBtn *OkBtn;
//属性传值
///收款model
@property (nonatomic, strong) O2OModel *calculatorModel ;


@end
