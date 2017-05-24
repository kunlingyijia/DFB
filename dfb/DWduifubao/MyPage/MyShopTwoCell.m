//
//  MyShopTwoCell.m
//  DWduifubao
//
//  Created by 席亚坤 on 17/3/6.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "MyShopTwoCell.h"
#import "MyShopModel.h"
@implementation MyShopTwoCell

- (void)awakeFromNib {
    [super awakeFromNib];
 self.selectionStyle = UITableViewCellSelectionStyleNone;
self.contentView.backgroundColor = [UIColor colorWithHexString:kViewBackgroundColor];
}
-(void)CellGetData:(MyShopModel*)model{
    NSLog(@"%@",[model yy_modelToJSONObject]);
    [self.merchant_mobile setTitle:model.merchant_mobile forState:(UIControlStateNormal)];
    self.content.text = model.content;
    self.create_time.text = model.create_time;
   
}
- (IBAction)CallAction:(UIButton *)sender {
    self.cell(sender.titleLabel.text);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
