//
//  MerchantsHomePageOneCell.h
//  DWduifubao
//
//  Created by 席亚坤 on 17/3/16.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MerchantCertificationModel;
@interface MerchantsHomePageOneCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *tdy_order_count;
@property (weak, nonatomic) IBOutlet UILabel *tdy_order_money;
@property (weak, nonatomic) IBOutlet UILabel *balance;
-(void)CellGetData:(MerchantCertificationModel*)model;
@end
