//
//  IndianaKindListCell.m
//  DWduifubao
//
//  Created by kkk on 16/9/13.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "IndianaKindListCell.h"
#import "WTProgressView.h"
@interface IndianaKindListCell()
@property (nonatomic, strong) UIImageView *imageV;
@property (nonatomic, strong) UILabel *goodsName;
@property (nonatomic, strong) WTProgressView *progressV;
@property (nonatomic, strong) UILabel *allNumber;
@property (nonatomic, strong) UILabel *surplusL;
@property (nonatomic, strong) UIButton *sureBtn;

@end

@implementation IndianaKindListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createView];
    }
    return self;
}

- (void)createView {
    UIView *lineV = [UIView new];
    lineV.backgroundColor = [UIColor colorWithHexString:kLineColor];
    [self.contentView addSubview:lineV];
    [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(@(1));
    }];
    
    self.imageV = [[UIImageView alloc] init];
    self.imageV.layer.masksToBounds = YES;
    self.imageV.layer.cornerRadius = 5;
    self.imageV.layer.borderColor = [UIColor colorWithHexString:kLineColor].CGColor;
    self.imageV.layer.borderWidth = 1;
    [self.contentView addSubview:self.imageV];
    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).with.offset(20);
        make.left.equalTo(self.contentView.mas_left).with.offset(20);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
    self.goodsName = [UILabel new];
    self.goodsName.text = @"Apple iphone6s 64g 颜色随机";
    self.goodsName.textColor = [UIColor colorWithHexString:kTitleColor];
    self.goodsName.font = [UIFont systemFontOfSize:kthirdTitleFont];
    [self.contentView addSubview:self.goodsName];
    [self.goodsName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageV);
        make.left.equalTo(self.imageV.mas_right).with.offset(5);
        make.right.equalTo(self.contentView);
        make.height.mas_equalTo(@(30));
    }];
    self.sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.sureBtn setTitle:@"立即参与" forState:UIControlStateNormal];
    [self.sureBtn setTitleColor:[UIColor colorWithHexString:kRedColor] forState:UIControlStateNormal];
    [self.sureBtn addTarget:self action:@selector(selectedAction:) forControlEvents:UIControlEventTouchUpInside];
    self.sureBtn.titleLabel.font = [UIFont systemFontOfSize:kthirdTitleFont];
    self.sureBtn.layer.masksToBounds = YES;
    self.sureBtn.layer.cornerRadius = 5;
    self.sureBtn.layer.borderWidth = 1;
    self.sureBtn.layer.borderColor = [UIColor colorWithHexString:kRedColor].CGColor;
    [self.contentView addSubview:self.sureBtn];
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).with.offset(-10);
        make.size.mas_equalTo(CGSizeMake(60, 25));
    }];
    
    
    self.progressV = [WTProgressView new];
    [self.contentView addSubview:self.progressV];
    [self.progressV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goodsName.mas_bottom);
        make.left.equalTo(self.imageV.mas_right).with.offset(5);
        make.right.equalTo(self.sureBtn.mas_left).with.offset(-5);
        make.height.mas_equalTo(@(8));
    }];
    self.progressV.userInteractionEnabled = NO;
    self.progressV.progress = 0.8;
    self.progressV.gradientColors = @[[UIColor colorWithHexString:@"#ffad45"],[UIColor colorWithHexString:kRedColor]];
    self.progressV.edgeColor = [UIColor colorWithHexString:kViewBackgroundColor];
    self.progressV.bgColor = [UIColor colorWithHexString:kViewBackgroundColor];
    
    self.allNumber = [UILabel new];
    self.allNumber.text = @"总需6080";
    self.allNumber.textColor = [UIColor colorWithHexString:ksubTitleColor];
    self.allNumber.font = [UIFont systemFontOfSize:kthirdTitleFont];
    [self.contentView addSubview:self.allNumber];
    [self.allNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.progressV.mas_bottom);
        make.left.equalTo(self.imageV.mas_right).with.offset(5);
        make.size.mas_equalTo(CGSizeMake(80, 30));
    }];
    NSString *str = @"15555";
    CGFloat W = [str getSingleLineTextWidthWithFont:[UIFont systemFontOfSize:kthirdTitleFont] withMaxWith:Width];
    self.surplusL = [UILabel new];
    self.surplusL.text = @"15555";
    self.surplusL.textAlignment = NSTextAlignmentLeft;
    self.surplusL.textColor = [UIColor colorWithHexString:@"#1c62b9"];
    self.surplusL.font = [UIFont systemFontOfSize:kthirdTitleFont];
    [self.contentView addSubview:self.surplusL];
    [self.surplusL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.progressV.mas_bottom);
        make.right.equalTo(self.sureBtn.mas_left).with.offset(-5);
        make.size.mas_equalTo(CGSizeMake(W, 30));
    }];
    
    UILabel *showL = [UILabel new];
    showL.text = @"剩余";
    showL.textAlignment = NSTextAlignmentRight;
    showL.textColor = [UIColor colorWithHexString:ksubTitleColor];
    showL.font = [UIFont systemFontOfSize:kthirdTitleFont];
    [self.contentView addSubview:showL];
    [showL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.progressV.mas_bottom);
        make.right.equalTo(self.surplusL.mas_left).with.offset(-5);
        make.size.mas_equalTo(CGSizeMake(50, 30));
    }];
}

- (void)selectedAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(selectedJoin:)]) {
        [self.delegate selectedJoin:@"6666"];
    }
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
    
}

@end
