//
//  ChangeMerchantsBank.h
//  DWduifubao
//
//  Created by 席亚坤 on 17/3/23.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "BaseViewController.h"
@class MerchantCertificationModel;
@interface ChangeMerchantsBank : BaseViewController
///MerchantDataThreeVCBlock
@property (nonatomic, copy) void(^ChangeMerchantsBankVCBlock)() ;
///对私
@property (weak, nonatomic) IBOutlet UIButton *privateBtn;
///对公
@property (weak, nonatomic) IBOutlet UIButton *contraryBtn;

@property (weak, nonatomic) IBOutlet UITextField *bank_account_number;
@property (weak, nonatomic) IBOutlet UIButton *bank_name;
@property (weak, nonatomic) IBOutlet UILabel *subbranch;

@property (weak, nonatomic) IBOutlet UIImageView *bank_card_photo;
@property (weak, nonatomic) IBOutlet UIButton *bank_card_photoBtn;



@property (nonatomic,strong)MerchantCertificationModel *MCModel;
@end
