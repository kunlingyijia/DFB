//
//  O2OFailureVC.h
//  DWduifubao
//
//  Created by 席亚坤 on 16/11/16.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "BaseViewController.h"

@interface O2OFailureVC : BaseViewController
@property (weak, nonatomic) IBOutlet UILabel *label;
///审核状态（3,4）的理由
@property (nonatomic, strong) NSString  *sh_msg ;
///实名认证收款?提现
@property (nonatomic, strong) NSString  *pushTypeOfO2O ;

@end
