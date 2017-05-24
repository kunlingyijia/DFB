//
//  ChuangyeCell.m
//  DWduifubao
//
//  Created by 席亚坤 on 16/11/2.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "ChuangyeCell.h"

@implementation ChuangyeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.views.layer.borderWidth = 1;
    self.views.layer.borderColor = [UIColor grayColor].CGColor;
    // 第一列
    self.oneBtn.layer.borderWidth = 0.5;
    self.oneBtn.layer.borderColor = [UIColor grayColor].CGColor;
    self.twoBtn.layer.borderWidth = 0.5;
    self.twoBtn.layer.borderColor = [UIColor grayColor].CGColor;
    self.threeBtn.layer.borderWidth = 0.5;
    self.threeBtn.layer.borderColor = [UIColor grayColor].CGColor;
    self.fourBtn.layer.borderWidth = 0.5;
    self.fourBtn.layer.borderColor = [UIColor grayColor].CGColor;
//第二列
    self.fiveBtn.layer.borderWidth = 0.5;
    self.fiveBtn.layer.borderColor = [UIColor grayColor].CGColor;
    self.sixbtn.layer.borderWidth = 0.5;
    self.sixbtn.layer.borderColor = [UIColor grayColor].CGColor;
    self.sevenBtn.layer.borderWidth = 0.5;
    self.sevenBtn.layer.borderColor = [UIColor grayColor].CGColor;
    self.eightBtn.layer.borderWidth = 0.5;
    self.eightBtn.layer.borderColor = [UIColor grayColor].CGColor;
//第三列
    self.nineBtn.layer.borderWidth = 0.5;
    self.nineBtn.layer.borderColor = [UIColor grayColor].CGColor;
    self.tenBtn.layer.borderWidth = 0.5;
    self.tenBtn.layer.borderColor = [UIColor grayColor].CGColor;
    self.tenOnebtn.layer.borderWidth = 0.5;
    self.tenOnebtn.layer.borderColor = [UIColor grayColor].CGColor;
    self.tenTwoBtn.layer.borderWidth = 0.5;
    self.tenTwoBtn.layer.borderColor = [UIColor grayColor].CGColor;
//第四列
    self.tenThreeBtn.layer.borderWidth = 0.5;
    self.tenThreeBtn.layer.borderColor = [UIColor grayColor].CGColor;
    self.tenFourBtn.layer.borderWidth = 0.5;
    self.tenFourBtn.layer.borderColor = [UIColor grayColor].CGColor;
    self.tenFiveBtn.layer.borderWidth = 0.5;
    self.tenFiveBtn.layer.borderColor = [UIColor grayColor].CGColor;
    self.tenSixBtn.layer.borderWidth = 0.5;
    self.tenSixBtn.layer.borderColor = [UIColor grayColor].CGColor;
    

}

@end
