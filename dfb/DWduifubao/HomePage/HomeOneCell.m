//
//  HomeOneCell.m
//  DWduifubao
//
//  Created by 席亚坤 on 16/12/29.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "HomeOneCell.h"
#import "UIView+Toast.h"
@implementation HomeOneCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self createView];
    
}

//创建视图
- (void)createView {
//    //重构导航框的View
//    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width, 44)];
//    headView.backgroundColor = [UIColor clearColor];
//    //[self addSubview:headView];
//    //设置"扫一扫"二维码的按钮样式
//    UIButton *QRcodeBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 5, 34, 34)];
//    [QRcodeBtn setImage:[UIImage imageNamed:@"首页-扫一扫图标"] forState:UIControlStateNormal];
//    [headView addSubview:QRcodeBtn];
//    //设置"信息"的按钮样式
//    UIButton *messageBtn = [[UIButton alloc] init];
//    [messageBtn setImage:[UIImage imageNamed:@"首页-信息图标"] forState:UIControlStateNormal];
//    [headView addSubview:messageBtn];
//    //自动布局
//    [messageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(headView).with.offset(-10);
//        make.top.mas_equalTo(@(5));
//        make.width.mas_equalTo(@(34));
//        make.height.mas_equalTo(@(34));
//    }];
//    //设置"搜索框"的输入框的样式
//    UITextField *searchTextField = [[UITextField alloc] init];
//    [searchTextField setBackground:[UIImage imageNamed:@"首页-搜索框"]];
//    searchTextField.placeholder = @"请输入关键字";
//    searchTextField.font = [UIFont systemFontOfSize:kthirdTitleFont];
//    searchTextField.textColor = [UIColor colorWithHexString:kTitleColor];
//    [headView addSubview:searchTextField];
//    //自动布局
//    [searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(QRcodeBtn.mas_right).with.offset(10);
//        make.right.equalTo(messageBtn.mas_left).with.offset(-10);
//        make.top.mas_equalTo(@(5));
//        make.height.mas_equalTo(@(34));
//    }];
//    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 34)];
//    searchTextField.leftView = leftView;
//    //设置显示模式为永远显示(默认不显示)
//    searchTextField.leftViewMode = UITextFieldViewModeAlways;
//    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 34, 34)];
//    searchTextField.rightView = rightView;
//    UIButton *searchBtn = [[UIButton alloc] init];
//    [searchBtn setImage:[UIImage imageNamed:@"首页-搜索框-搜索按钮"] forState:UIControlStateNormal];
//    [searchTextField.rightView addSubview:searchBtn];
//    searchTextField.rightViewMode = UITextFieldViewModeAlways;
//    //自动布局
//    [searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(rightView.mas_left);
//        make.top.mas_equalTo(rightView.mas_top);
//        make.width.mas_equalTo(@(34));
//        make.height.mas_equalTo(@(34));
//    }];
//    //设置searchTextField不可编辑
//    searchTextField.enabled = NO;
    
    
    [self.myPropertyBtn setImagePosition:LXMImagePositionTop spacing:0];
    [self.dfSnatchGemBtn setImagePosition:LXMImagePositionTop spacing:0];
    [self.dfFinanceBtn setImagePosition:LXMImagePositionTop spacing:0];
    [self.O2OCollectMoneyBtn setImagePosition:LXMImagePositionTop spacing:0];
    [self.FiveBtn setImagePosition:LXMImagePositionTop spacing:0];
    [self.SixBtn setImagePosition:LXMImagePositionTop spacing:0];
    [self.SevenBtn setImagePosition:LXMImagePositionTop spacing:0];
    [self.EightBtn setImagePosition:LXMImagePositionTop spacing:0];

}
- (IBAction)Action:(UIButton *)sender {
    self.HomeOneCellBlock(sender.tag-300);
}


@end
