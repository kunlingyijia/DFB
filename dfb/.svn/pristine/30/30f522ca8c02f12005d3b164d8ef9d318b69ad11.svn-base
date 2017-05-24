//
//  IndianaHeaderView.m
//  DWduifubao
//
//  Created by kkk on 16/9/9.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "IndianaHeaderView.h"
#import "UNScrollLabel.h"
@interface IndianaHeaderView()<SDCycleScrollViewDelegate>

@property (nonatomic, strong) UIView *redLine;
@property (nonatomic, strong) NSMutableArray *searchBtnArr;

@end

@implementation IndianaHeaderView



- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self createView];
    }
    return self;
}

- (void)createView {
    NSArray *imagesURLStrings = @[@"https://ss2.baidu.com/-vo3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a4b3d7085dee3d6d2293d48b252b5910/0e2442a7d933c89524cd5cd4d51373f0830200ea.jpg",@"https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",@"http://c.hiphotos.baidu.com/image/w%3D400/sign=c2318ff84334970a4773112fa5c8d1c0/b7fd5266d0160924c1fae5ccd60735fae7cd340d.jpg"];
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, Width, 2*Width/5)shouldInfiniteLoop:YES imageNamesGroup:imagesURLStrings];
    
    cycleScrollView.delegate = self;
    cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
    [self addSubview:cycleScrollView];
    cycleScrollView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    UIView *firstLine = [UIView new];
    firstLine.backgroundColor = [UIColor colorWithHexString:kLineColor];
    [self addSubview:firstLine];
    [firstLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(cycleScrollView.mas_bottom);
        make.height.mas_equalTo(@(1));
    }];
    NSArray *classN = @[@"分类",@"我的",@"晒单",@"帮助"];
    NSArray *classImg = @[@"对富夺宝-分类",@"图层-50",@"夺宝-晒单",@"对富夺宝-帮助"];
    CGFloat btnW = Width / 4;
    for (int i = 0; i < 4; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i*btnW, CGRectGetMaxY(cycleScrollView.frame)+1, btnW, btnW);
        [btn addTarget:self action:@selector(selectedAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 200+i;
        [btn setTitle:classN[i] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:classImg[i]] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:ksubTitleColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [btn setImagePosition:LXMImagePositionTop spacing:5];
        [self addSubview:btn];
    }
    
    UIView *secondLine = [UIView new];
    secondLine.backgroundColor = [UIColor colorWithHexString:kLineColor];
    [self addSubview:secondLine];
    secondLine.frame = CGRectMake(0, CGRectGetMaxY(cycleScrollView.frame)+1+btnW, Width, 1);
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"兑富夺宝-消息图标"]];
    img.contentMode =  UIViewContentModeScaleAspectFit;
    [self addSubview:img];
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(20);
        make.top.equalTo(secondLine).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    //更新img的frame
    [img layoutIfNeeded];

    
    for (int i=0; i<1; i++)
    {
        UNScrollLabel *label = [[UNScrollLabel alloc] initWithFrame:CGRectMake(40, CGRectGetMinY(img.frame), Width-40, 20) Font:[UIFont systemFontOfSize:15]];
        [self addSubview:label];
        
        [label setTextColor:[UIColor blackColor]];
        
        if (0 == i % 2) [label setTitle:@"跑马灯跑马灯跑马灯跑马灯跑马灯跑马灯跑马灯跑马灯跑马灯跑马灯跑马灯跑马灯跑马灯跑马灯跑马灯跑马灯跑马灯跑马灯跑马灯跑马灯" Animate:YES];
        else [label setTitle:@"1234567890" Animate:YES];
    }
    
    
//
//    UIView *labelBgV = [[UIView alloc] init];
//    labelBgV.backgroundColor = [UIColor redColor];
//    [self addSubview:labelBgV];
//    [labelBgV mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(img);
//        make.left.equalTo(img.mas_right);
//        make.right.equalTo(self.mas_right);
//        make.height.mas_equalTo(@(20));
//    }];
    
//    UIView *labelV = [[UIView alloc] initWithFrame:CGRectMake(Width-40, 0, Width-41, 20)];
//    labelV.backgroundColor = [UIColor purpleColor];
//    [labelBgV addSubview:labelV];
//    
//    
//    UILabel *firstL = [UILabel new];
//    firstL.font = [UIFont systemFontOfSize:14];
//    firstL.textColor = [UIColor colorWithHexString:ksubTitleColor];
//    firstL.text = @"恭喜";
//    [labelV addSubview:firstL];
//    [firstL mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(labelV).with.offset(0);
//        make.top.equalTo(labelV);
//        make.size.mas_equalTo(CGSizeMake(30, 20));
//    }];
//    
//    
//    NSString *name = @"中国的中中中中";
//    CGFloat nameW = [name getSingleLineTextWidthWithFont:[UIFont systemFontOfSize:14] withMaxWith:Width];
//    UILabel *nameL = [UILabel new];
//    nameL.font = [UIFont systemFontOfSize:14];
//    nameL.textColor = [UIColor colorWithHexString:@"#1c62b9"];
//    nameL.text = name;
//    [labelV addSubview:nameL];
//    [nameL mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(labelV);
//        make.left.equalTo(firstL.mas_right);
//        make.size.mas_equalTo(CGSizeMake(nameW, 20));
//    }];
//    
//    UILabel *secondL = [UILabel new];
//    secondL.font = [UIFont systemFontOfSize:14];
//    secondL.textColor = [UIColor colorWithHexString:ksubTitleColor];
//    secondL.text = @"8分钟前获得一部iphone7";
//    [labelV addSubview:secondL];
//    [secondL mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(labelV);
//        make.left.equalTo(nameL.mas_right);
//        make.right.equalTo(self);
//        make.height.equalTo(@(20));
//    }];
//    
//    [UIView animateWithDuration:10 animations:^{
//        labelV.frame = CGRectMake(-Width + 41, 0, Width-41, 20);
//    } completion:^(BOOL finished) {
//        
//    }];
//    
    UIView *thirdLine = [UIView new];
    thirdLine.backgroundColor = [UIColor colorWithHexString:kViewBackgroundColor];
    [self addSubview:thirdLine];
    [thirdLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(img.mas_bottom).with.offset(5);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(@(10));
    }];
    [thirdLine layoutIfNeeded];
    NSArray *searchArr = @[@"人气",@"最新",@"进度",@"总需人次"];
    CGFloat searchBtnW = Width/4 - 10;
    for (int i = 0; i < 4; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:searchArr[i] forState:UIControlStateNormal];
        if (i==0) {
            [btn setTitleColor:[UIColor colorWithHexString:kRedColor] forState:UIControlStateNormal];
        }else {
            [btn setTitleColor:[UIColor colorWithHexString:ksubTitleColor] forState:UIControlStateNormal];
        }
        btn.titleLabel.font = [UIFont systemFontOfSize:kFirstTitleFont];
        btn.tag = 100+i;
        btn.frame = CGRectMake(i*searchBtnW, CGRectGetMaxY(thirdLine.frame), searchBtnW, 40);
        [btn addTarget:self action:@selector(searchBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        [self.searchBtnArr addObject:btn];
        if (i== 3) {
            [btn setImage:[UIImage imageNamed:@"夺宝-总需人次"] forState:UIControlStateNormal];
            [btn setImagePosition:LXMImagePositionRight spacing:2];
            btn.frame = CGRectMake(i*searchBtnW, CGRectGetMaxY(thirdLine.frame), searchBtnW+40, 40);
        }
    }
    
    UIView *fourLine = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(thirdLine.frame)+40, Width, 2)];
    fourLine.backgroundColor = [UIColor colorWithHexString:kLineColor];
    [self addSubview:fourLine];
    
    self.redLine = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(thirdLine.frame)+40, Width/4-10, 2)];
    self.redLine.backgroundColor = [UIColor colorWithHexString:kRedColor];
    [self addSubview:self.redLine];
    
}

- (void)selectedAction:(UIButton *)sender {
    NSInteger index = sender.tag - 200;
    if ([self.delegate respondsToSelector:@selector(selectedClassKindWithIndex:)]) {
        [self.delegate selectedClassKindWithIndex:index];
    }
}


- (void)searchBtnAction:(UIButton *)sender {
    NSInteger count = sender.tag - 100;
    for (int i = 0; i < self.searchBtnArr.count; i++) {
        UIButton *btn = self.searchBtnArr[i];
        if (i== count) {
            [btn setTitleColor:[UIColor colorWithHexString:kRedColor] forState:UIControlStateNormal];
        }else {
            [btn setTitleColor:[UIColor colorWithHexString:ksubTitleColor] forState:UIControlStateNormal];
        }
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.redLine.frame = CGRectMake(count * (Width/4-10), self.redLine.frame.origin.y, sender.frame.size.width, 2);
    }];
}


- (NSMutableArray *)searchBtnArr {
    if (!_searchBtnArr) {
        self.searchBtnArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _searchBtnArr;
}


@end
