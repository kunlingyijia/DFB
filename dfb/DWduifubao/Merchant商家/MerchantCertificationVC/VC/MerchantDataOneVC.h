//
//  MerchantDataOneVC.h
//  DWduifubao
//
//  Created by 席亚坤 on 17/3/19.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "BaseViewController.h"
@class MerchantCertificationModel;

@interface MerchantDataOneVC : BaseViewController
@property (weak, nonatomic) IBOutlet UIButton *zone;
@property (weak, nonatomic) IBOutlet EZTextView *address;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UIImageView *merchant_logo;
@property (weak, nonatomic) IBOutlet UIButton *merchant_logoBtn;

@property (weak, nonatomic) IBOutlet UIImageView *main_image;
@property (weak, nonatomic) IBOutlet UIButton *main_imageBtn;

@property (nonatomic,strong)MerchantCertificationModel *MCModel;
//1-添加 2-修改 (在拒绝时候选择修改)
@property(nonatomic,strong)NSString *edit_type;
@end
