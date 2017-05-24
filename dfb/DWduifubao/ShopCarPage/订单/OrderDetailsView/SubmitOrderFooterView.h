//
//  SubmitOrderFooterView.h
//  DWduifubao
//
//  Created by 席亚坤 on 17/1/6.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HeaderModel;

@interface SubmitOrderFooterView : UITableViewHeaderFooterView
///总价格
@property (weak, nonatomic) IBOutlet UILabel *Allprice;
///实际总价格
@property (weak, nonatomic) IBOutlet UILabel *actualPrice;
///邮费状态
@property (weak, nonatomic) IBOutlet UILabel *freightStatusLabel;
///邮费
@property (weak, nonatomic) IBOutlet UILabel *freightLabel;

@property (weak, nonatomic) IBOutlet PublicTF *remark;
-(void)cellGetData:(HeaderModel*)model;

@end
