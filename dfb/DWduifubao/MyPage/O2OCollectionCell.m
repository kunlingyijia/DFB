//
//  O2OCollectionCell.m
//  DWduifubao
//
//  Created by 席亚坤 on 16/11/15.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "O2OCollectionCell.h"
#import "O2OModel.h"
@implementation O2OCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)cellGetData:(O2OModel*)model{
    [DWHelper SD_WebImage:self.pay_icon imageUrlStr:model.pay_icon placeholderImage:nil];
    //self.limit.text = model.limit;
    if (model.withdraw_time.length!=0&&model.limit.length!=0) {
        self.withdraw_time.text =[NSString stringWithFormat:@"%@ %@",model.withdraw_time,model.limit]  ;
    }
   
    self.pay_name.text = model.pay_name;
    

}
@end
