//
//  MyShopThreeCell.m
//  DWduifubao
//
//  Created by 席亚坤 on 17/3/6.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "MyShopThreeCell.h"
#import "MyShopModel.h"
@implementation MyShopThreeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = [UIColor colorWithHexString:kViewBackgroundColor];
}
-(void)CellGetData:(MyShopModel*)model{
    NSLog(@"%@",[model yy_modelToJSONObject]);
    
    self.address.text =[NSString stringWithFormat:@"%@ %@",model.zone, model.address];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
