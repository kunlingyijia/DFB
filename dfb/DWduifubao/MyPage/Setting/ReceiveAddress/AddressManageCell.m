//
//  AddressManageCell.m
//  DWduifubao
//
//  Created by 月美 刘 on 16/9/21.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "AddressManageCell.h"
#import "AddressModel.h"
@implementation AddressManageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    //设置“编辑”按钮的图片
    UIImageView *editImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"我的-地址管理-编辑"]];
    [self.editBtn addSubview:editImage];
    //自动布局
    [editImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.editBtn.mas_left);
        make.top.mas_equalTo(@(10));
        make.width.mas_equalTo(@(20));
        make.height.mas_equalTo(@(20));
    }];
    
    //设置“删除”按钮的图片
    UIImageView *deleteImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"我的-地址管理-删除"]];
    [self.deleteBtn addSubview:deleteImage];
    //自动布局
    [deleteImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.deleteBtn.mas_left);
        make.top.mas_equalTo(@(10));
        make.width.mas_equalTo(@(20));
        make.height.mas_equalTo(@(20));
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (IBAction)defaultAddressBtnAction:(PublicBtn*)sender{
}

- (IBAction)editBtnAction:(PublicBtn*)sender {
    NSLog(@"编辑%ld",sender.indexPath.row);
}

- (IBAction)deleteBtnAction:(PublicBtn*)sender {
}
///赋值
-(void)cellGetData:(AddressModel*)model{
    self.name.text = model.name;
    NSString *tel = [model.mobile stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    self.phone.text = tel;
    self.address.text = [NSString stringWithFormat:@"%@%@",model.zone,model.address];
    if ([model.is_default isEqualToString:@"1"]) {
        [self.defaultAddressBtn setImage:[UIImage imageNamed:@"我的-地址管理-选中"] forState:(UIControlStateNormal)];
        
    }else{
        [self.defaultAddressBtn setImage:[UIImage imageNamed:@"我的-地址管理-未选中"] forState:(UIControlStateNormal)];
        
    }

}
@end
