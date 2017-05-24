//
//  MerchantIntroduceVC.h
//  DWduifubao
//
//  Created by 席亚坤 on 17/3/16.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "BaseViewController.h"
@class MerchantCertificationModel;
@interface MerchantIntroduceVC : BaseViewController
@property (weak, nonatomic) IBOutlet UIButton *industry_name;


@property (weak, nonatomic) IBOutlet UITextField *merchant_name;


@property (nonatomic,strong)MerchantCertificationModel *MCModel;
//1-添加 2-修改 (在拒绝时候选择修改)
@property(nonatomic,strong)NSString *edit_type;
@end
