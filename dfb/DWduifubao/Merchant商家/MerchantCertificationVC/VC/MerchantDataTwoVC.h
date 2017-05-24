//
//  MerchantDataTwoVC.h
//  DWduifubao
//
//  Created by 席亚坤 on 17/3/19.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "BaseViewController.h"
@class MerchantCertificationModel;

@interface MerchantDataTwoVC : BaseViewController


@property (nonatomic,strong)MerchantCertificationModel *MCModel;
@property (weak, nonatomic) IBOutlet UIImageView *id_card_photo;
@property (weak, nonatomic) IBOutlet UIButton *id_card_photoBtn;

@property (weak, nonatomic) IBOutlet UIImageView *id_card_back_photo;

@property (weak, nonatomic) IBOutlet UIButton *id_card_back_photoBtn;
@property (weak, nonatomic) IBOutlet UITextField *account_name;
@property (weak, nonatomic) IBOutlet UITextField *id_card;

@property (weak, nonatomic) IBOutlet UIImageView *license_url;
@property (weak, nonatomic) IBOutlet UIButton *license_urlBtn;

@property (weak, nonatomic) IBOutlet UITextField *license_no;



//1-添加 2-修改 (在拒绝时候选择修改)
@property(nonatomic,strong)NSString *edit_type;
@end
