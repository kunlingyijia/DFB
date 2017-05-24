//
//  MyLoanOrCardTwoCell.m
//  DWduifubao
//
//  Created by 席亚坤 on 17/3/20.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "MyLoanOrCardTwoCell.h"
#import "MyLoanOrCardModel.h"
@implementation MyLoanOrCardTwoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.type.layer.masksToBounds = YES;
    self.type.layer.cornerRadius =5.0;
//    self.type.hidden = YES;
//    self.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)CellGetData:(MyLoanOrCardModel*)model{
    self.title.text = model.title;
    [DWHelper SD_WebImage:self.image_url imageUrlStr:model.image_url placeholderImage:nil];
}
@end
