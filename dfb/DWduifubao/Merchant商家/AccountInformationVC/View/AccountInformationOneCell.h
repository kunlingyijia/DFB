//
//  AccountInformationOneCell.h
//  DWduifubao
//
//  Created by 席亚坤 on 17/3/23.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MerchantCertificationModel;
@interface AccountInformationOneCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *remark;

@property (weak, nonatomic) IBOutlet UILabel *create_time;

@property (weak, nonatomic) IBOutlet UILabel *amount;
-(void)CellGetData:(MerchantCertificationModel*)model;
@end
