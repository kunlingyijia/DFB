//
//  MyBankCell.m
//  DWduifubao
//
//  Created by 席亚坤 on 16/12/9.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "MyBankCell.h"
#import "PersonRenZhengModel.h"
@implementation MyBankCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.bottomView.layer.masksToBounds = YES;
    self.bottomView.layer.cornerRadius = 10.0;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)cellGetData:(PersonRenZhengModel*)model{
    self.bank_name.text = model.bank_name;
    self.bankImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",model.bank_name]];
    if ([model.status isEqualToString:@"1"]) {
        self.status.text = @"已绑定";
    }else if ([model.status isEqualToString:@"2"]||[model.status isEqualToString:@"3"]){
         self.status.text = @"审核中...";
    }else if ([model.status isEqualToString:@"4"]){
         self.status.text = @"修改失败";
    }
    self.content.text = model.content;
    NSString *bank_account_number = [NSString stringWithFormat:@"%@",[model.bank_account_number substringFromIndex:model.bank_account_number.length- 4 ]];
    self.bank_account_number.text = bank_account_number;
}
@end
