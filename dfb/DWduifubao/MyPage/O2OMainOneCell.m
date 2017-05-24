//
//  O2OMainOneCell.m
//  DWduifubao
//
//  Created by 席亚坤 on 16/11/14.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "O2OMainOneCell.h"
#import "O2OModel.h"
@implementation O2OMainOneCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.ShouKuanBtn.layer.cornerRadius = 3;
    self.ShouKuanBtn.layer.masksToBounds = YES;
    self.TiXianBtn .layer.cornerRadius = 3;
    self.TiXianBtn.layer.masksToBounds = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)cellGetdata:(O2OModel*)model{
    self.last_o2o_money.text = [NSString stringWithFormat:@"￥%@",model.last_o2o_money ];
    self.current_o2o_money.text = [NSString stringWithFormat:@"￥%@",model.current_o2o_money ];
    self.draw_money.text = [NSString stringWithFormat:@"￥%.2f",model.draw_money ];
}

@end
