//
//  SubmitOrdersVC.h
//  DWduifubao
//
//  Created by 席亚坤 on 16/12/28.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "BaseViewController.h"

@interface SubmitOrdersVC : BaseViewController
@property (weak, nonatomic) IBOutlet UIButton *SubmitBtn;

///提交总价格
@property (weak, nonatomic) IBOutlet UILabel *actualAllPrice;
///属性传值
@property (nonatomic, strong) NSMutableArray  *choseArr ;


@end
