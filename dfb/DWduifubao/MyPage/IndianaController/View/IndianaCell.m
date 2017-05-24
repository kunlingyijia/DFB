//
//  IndianaCell.m
//  DWduifubao
//
//  Created by kkk on 16/9/12.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "IndianaCell.h"
#import "WTProgressView.h"
@implementation IndianaCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
    }
    return self;
}

- (void)createView {
    self.contentView.backgroundColor = [UIColor whiteColor];
    UIImageView *img = [UIImageView new];
    img.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:img];
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(10);
        make.centerX.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(Width/2-1 - 50, Width/2-1 - 50));
    }];
    
    UILabel *nameL = [UILabel new];
    nameL.text = @"Apple iPhone6s Plus 64g 颜色随机";
    nameL.font = [UIFont systemFontOfSize:kthirdTitleFont];
    nameL.textColor = [UIColor colorWithHexString:kTitleColor];
    nameL.numberOfLines = 0;
    
    [self.contentView addSubview:nameL];
    [nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(img.mas_bottom);
        make.left.equalTo(self.contentView).with.offset(10);
        make.right.equalTo(self.contentView).with.offset(-10);
        make.height.mas_equalTo(@(40));
    }];
    UILabel *showL = [UILabel new];
    showL.text = @"揭晓进度";
    showL.font = [UIFont systemFontOfSize:12];
    showL.textColor = [UIColor colorWithHexString:ksubTitleColor];
    [self.contentView addSubview:showL];
    [showL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameL.mas_bottom);
        make.left.equalTo(self.contentView).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(55, 20));
    }];
    
    UILabel *showNumL = [UILabel new];
    showNumL.text = @"90%";
    showNumL.font = [UIFont systemFontOfSize:12];
    showNumL.textColor = [UIColor colorWithHexString:@"#1c62b9"];
    showNumL.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:showNumL];
    [showNumL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameL.mas_bottom);
        make.left.equalTo(showL.mas_right).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(30, 20));
    }];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"立即参与" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:kRedColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:kthirdTitleFont];
    btn.layer.borderColor = [UIColor colorWithHexString:kRedColor].CGColor;
    btn.layer.borderWidth = 1;
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 4;
    [self addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(showL).with.offset(5);
        make.right.equalTo(self.contentView).with.offset(-10);
        make.size.mas_equalTo(CGSizeMake(60, 25));
        
    }];
    
    WTProgressView *progressV = [WTProgressView new];
    [self.contentView addSubview:progressV];
    [progressV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(showL.mas_bottom);
        make.left.equalTo(self.contentView).with.offset(10);
        make.right.equalTo(btn.mas_left).with.offset(-5);
        make.height.mas_equalTo(@(8));
    }];
  
    progressV.progress = 0.5;
    progressV.gradientColors = @[[UIColor colorWithHexString:@"#ffad45"],[UIColor colorWithHexString:kRedColor]];
    progressV.edgeColor = [UIColor colorWithHexString:kViewBackgroundColor];
    progressV.bgColor = [UIColor colorWithHexString:kViewBackgroundColor];
    
}




@end
