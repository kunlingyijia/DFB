//
//  MyBankCell.h
//  DWduifubao
//
//  Created by 席亚坤 on 16/12/9.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PersonRenZhengModel;
@interface MyBankCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIImageView *bankImageView;
@property (weak, nonatomic) IBOutlet UILabel *bank_name;
//状态
@property (weak, nonatomic) IBOutlet UILabel *status;
///错误信息
@property (weak, nonatomic) IBOutlet UILabel *content;

///银行卡号 后四位
@property (weak, nonatomic) IBOutlet UILabel *bank_account_number;
-(void)cellGetData:(PersonRenZhengModel*)model;
@end
