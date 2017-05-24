//
//  BuyNemberViewController.h
//  DWduifubao
//
//  Created by 席亚坤 on 16/11/1.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "BaseViewController.h"

@interface BuyNemberViewController : BaseViewController
//会员价格
@property (weak, nonatomic) IBOutlet UILabel *price;
///现金
@property (weak, nonatomic) IBOutlet UILabel *cashlabel;
///兑富金币
@property (weak, nonatomic) IBOutlet UILabel *glodLabel;
///会员升级说明
@property (weak, nonatomic) IBOutlet UILabel *upgrade_intro;

///提交
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@end
