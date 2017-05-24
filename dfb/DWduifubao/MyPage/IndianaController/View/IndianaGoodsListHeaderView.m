//
//  IndianaGoodsListHeaderView.m
//  DWduifubao
//
//  Created by kkk on 16/9/13.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "IndianaGoodsListHeaderView.h"

@interface IndianaGoodsListHeaderView ()
@property (nonatomic, strong) UIView *btnBgView;
@property (nonatomic, strong) UIView *bgView;


@property (nonatomic, strong) UILabel *goodsNumber;
@property (nonatomic, strong) NSMutableArray *btnArr;

@end


@implementation IndianaGoodsListHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
    }
    return self;
}

- (void)createView {
    UIView *bgView = [UIView new];
    bgView.backgroundColor = [UIColor colorWithHexString:kViewBackgroundColor];
    [self addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(@(0));
    }];
    
    self.goodsNumber = [UILabel new];
    self.goodsNumber.text = @"共31件商品";
    self.goodsNumber.textAlignment = NSTextAlignmentLeft;
    self.goodsNumber.textColor = [UIColor colorWithHexString:ksubTitleColor];
    self.goodsNumber.font = [UIFont systemFontOfSize:kthirdTitleFont];
    [self addSubview:self.goodsNumber];
    [self.goodsNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bgView);
        make.left.equalTo(self).with.offset(20);
        make.size.mas_equalTo(CGSizeMake(100, 0));
    }];
    [self.goodsNumber layoutIfNeeded];
    NSArray *btnN = @[@"分类",@"人气",@"最新",@"进度",@"总需人次"];
    CGFloat btnW = Width/5-4;
    for (int i = 0; i < 5; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:btnN[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:kthirdTitleFont];
        [btn setTitleColor:[UIColor colorWithHexString:ksubTitleColor] forState:UIControlStateNormal];
        [self addSubview:btn];
        btn.frame = CGRectMake(i*btnW, 0, btnW, 40);
        if (i == 4) {
            [btn setImage:[UIImage imageNamed:@"夺宝-总需人次"] forState:UIControlStateNormal];
            [btn setImagePosition:LXMImagePositionRight spacing:0];
        }
        if (i == 0) {
            [btn setImage:[UIImage imageNamed:@"夺宝－分类－手机平板－下拉箭头"] forState:UIControlStateNormal];
            [btn setImagePosition:LXMImagePositionRight spacing:0];
            btn.frame = CGRectMake(i*btnW, 0, btnW+10, 40);
            [btn setTitleColor:[UIColor colorWithHexString:kRedColor] forState:UIControlStateNormal];
        }
        [btn addTarget:self action:@selector(selectedBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 100+i;
        [self.btnArr addObject:btn];
    }
    UIView *lineV = [UIView new];
    lineV.backgroundColor = [UIColor colorWithHexString:kLineColor];
    [self addSubview:lineV];
    [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self);
        make.height.mas_equalTo(@(1));
    }];
}

- (void)selectedBtnAction:(UIButton *)sender {
    NSInteger count = sender.tag-100;
    if (count == 0) {
        [self showView:sender];
    }else {
        [self hiddenView];
    }
    for (int i = 0; i < self.btnArr.count; i++) {
        UIButton *btn = self.btnArr[i];
        if (i == count) {
            [btn setTitleColor:[UIColor colorWithHexString:kRedColor] forState:UIControlStateNormal];
        }else {
            [btn setTitleColor:[UIColor colorWithHexString:ksubTitleColor] forState:UIControlStateNormal];
        }
    }
}

- (void)showView:(UIButton *)sender {
    if (self.btnBgView == nil) {
        UIWindow *window = [[UIApplication sharedApplication].delegate window];
        self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 45+64, Width, Height)];
        self.bgView.backgroundColor = [UIColor blackColor];
        self.bgView.alpha = 0.5;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenView)];
        [self.bgView addGestureRecognizer:tap];
        [window addSubview:self.bgView];
        self.btnBgView = [UIView new];
        self.btnBgView.backgroundColor = [UIColor colorWithHexString:kViewBackgroundColor];
        [window addSubview:self.btnBgView];
        self.btnBgView.frame = CGRectMake(0, 45+64, Width, 1);
       
        [UIView animateWithDuration:0.3 animations:^{
             self.btnBgView.frame = CGRectMake(0, 45+64, Width, 150);
        } completion:^(BOOL finished) {
            CGFloat btnW = (Width - 40)/4;
            for (int i = 0; i < 3; i++) {
                for (int j = 0; j < 4; j++) {
                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    btn.frame = CGRectMake(20+j*btnW, i*50, btnW, 50);
                    [self.btnBgView addSubview:btn];
                    [btn addTarget:self action:@selector(selectedKindAction:) forControlEvents:UIControlEventTouchUpInside];
                    [btn setTitle:@"全部商品" forState:UIControlStateNormal];
                    btn.titleLabel.font = [UIFont systemFontOfSize:ksecondTitleFont];
                    [btn setTitleColor:[UIColor colorWithHexString:ksubTitleColor] forState:UIControlStateNormal];
                }
            }
        }];
    }else {
        [self hiddenView];
    }
}

- (void)selectedKindAction:(UIButton *)sender {
    [self hiddenView];
}


- (void)hiddenView {
    [UIView animateWithDuration:0.3 animations:^{
        self.btnBgView.frame = CGRectMake(0, 45+64, Width, 0);
    } completion:^(BOOL finished) {
        [self.btnBgView removeFromSuperview];
        [self.bgView removeFromSuperview];
        self.bgView = nil;
        self.btnBgView = nil;
    }];
}


- (void)newHiddenView {
    [self.btnBgView removeFromSuperview];
    [self.bgView removeFromSuperview];
    self.bgView = nil;
    self.btnBgView = nil;
}



- (NSMutableArray *)btnArr {
    if (!_btnArr) {
        self.btnArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _btnArr;
}



@end
