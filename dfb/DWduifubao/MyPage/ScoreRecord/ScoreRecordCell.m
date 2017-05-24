//
//  ScoreRecordCell.m
//  DWduifubao
//
//  Created by 月美 刘 on 16/10/26.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "ScoreRecordCell.h"
#import "ScoreRecordModel.h"
@implementation ScoreRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)cellGetData:(ScoreRecordModel*)model{
    if (model.type ==1 ) {
        self.amount.text = [NSString stringWithFormat:@"+%.2f",model.amount];
    }else{
        self.amount.text = [NSString stringWithFormat:@"-%.2f",model.amount];
    }
    
    self.remark.text = [NSString stringWithFormat:@"%@",model.remark];
    self.create_time.text = [NSString stringWithFormat:@"%@",model.create_time];
}
@end
