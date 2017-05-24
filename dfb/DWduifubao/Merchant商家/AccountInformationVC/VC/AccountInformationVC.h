//
//  AccountInformationVC.h
//  DWduifubao
//
//  Created by 席亚坤 on 17/3/17.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "BaseViewController.h"

@interface AccountInformationVC : BaseViewController
@property (weak, nonatomic) IBOutlet UIView *BottomView;

@property (weak, nonatomic) IBOutlet UILabel *bank_card_type;
@property (weak, nonatomic) IBOutlet UILabel *bank_name;
@property (weak, nonatomic) IBOutlet UILabel *bank_account_number;
@property (weak, nonatomic) IBOutlet UILabel *subbranch;
@property (weak, nonatomic) IBOutlet UIImageView *statusimage;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@property (weak, nonatomic) IBOutlet UILabel *content;

///merchant_id
@property (nonatomic, strong) NSString  *merchant_id ;



@end
