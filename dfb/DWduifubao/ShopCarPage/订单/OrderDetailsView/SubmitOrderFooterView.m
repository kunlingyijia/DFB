//
//  SubmitOrderFooterView.m
//  DWduifubao
//
//  Created by 席亚坤 on 17/1/6.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "SubmitOrderFooterView.h"
#import "HeaderModel.h"
@implementation SubmitOrderFooterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)cellGetData:(HeaderModel*)model{
    CGFloat Allprice =[model.Allprice floatValue];
    CGFloat freight=   [ model.freight floatValue];
    _Allprice.text =[ NSString stringWithFormat:@"%.2f",Allprice];

    _actualPrice.text =[ NSString stringWithFormat:@"%.2f",Allprice+freight];
;
    _remark.text = model.remark;
    if ([(NSString*) model.freight floatValue]>0.0) {
        _freightStatusLabel.text = @"";
    }else{
        _freightStatusLabel.text = @"包邮";
    }
    _freightLabel.text =[NSString stringWithFormat:@"+%@", model.freight];
}
@end
