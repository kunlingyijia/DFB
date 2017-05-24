//
//  SearchHistoryView.m
//  搜索
//
//  Created by 席亚坤 on 16/12/23.
//  Copyright © 2016年 席亚坤. All rights reserved.
//

#import "SearchHistoryView.h"
@interface SearchHistoryView (){
    BOOL ISOpen;
}


@end
@implementation SearchHistoryView
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
       
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
         self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64) ;
        ISOpen = NO;
    
    }
    return self;
}
-(void)awakeFromNib{
    [super awakeFromNib];
    _bottomView.layer.masksToBounds = YES;
    _bottomView.layer.cornerRadius = 5;
    _ClearBtn.hidden = YES;
    self.searchHisToryTF.userInteractionEnabled = YES;
    self.searchHisToryTF.delegate = self;
    [self.searchHisToryTF addTarget:self action:@selector(searchHisToryTFEditingChanged:) forControlEvents:(UIControlEventEditingChanged)];
    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64) ;

}
-(void)layoutSubviews{
    CGRect  frame = self.frame;
    frame.size.width = [UIScreen mainScreen].bounds.size.width;
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    if (ISOpen == YES) {
        ISOpen = NO;
        frame.size.height = [UIScreen mainScreen].bounds.size.height;

    }else{
        frame.size.height = 64;
    }
    [self setFrame:frame];
    
}
#pragma mark - searchHisToryTFEditingChanged
- (void)searchHisToryTFEditingChanged:(UITextField *)sender {
    sender = self.searchHisToryTF;
    if ([sender.text isEqualToString:@""]) {
        _ClearBtn.hidden = YES;
    }else{
        _ClearBtn.hidden = NO;
        
    }
    

}

#pragma mark - 点击键盘return键
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    _ClearBtn.hidden = YES;
    [self sendSubviewToBack :  self.searchHisToryTF];
    _BackConstrainWidth.constant = 34;
    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64) ;
    [self.searchHisToryTF resignFirstResponder];
    self.searechTFValue(textField.text);
    return YES;
    
    
    
}


-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64) ;
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    _BackConstrainWidth.constant = 34;
    _ClearBtn.hidden = YES;
    [self sendSubviewToBack :  self.searchHisToryTF];
    [self.searchHisToryTF resignFirstResponder];
   
}

#pragma mark - 返回事件
- (IBAction)backBtnAction:(UIButton *)sender {
    self.searchBack();
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    _ClearBtn.hidden = YES;
    [self sendSubviewToBack :  self.searchHisToryTF];
    [self.searchHisToryTF resignFirstResponder];
    _BackConstrainWidth.constant = 34;
    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64) ;


}

#pragma mark - 搜索事件
- (IBAction)searchBtnAction:(UIButton *)sender {
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    ISOpen = YES;
   self.searchSearch(self.searchHisToryTF.text);
    if (self.searchHisToryTF.text.length==0) {
        _ClearBtn.hidden = YES;

    }else{
        _ClearBtn.hidden = NO;

    }
    [self bringSubviewToFront:  self.searchHisToryTF];
    [self.searchHisToryTF becomeFirstResponder];
    _BackConstrainWidth.constant = 0;
    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    

 }
#pragma mark - 清除TF
- (IBAction)ClearTFAction:(UIButton *)sender {
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    sender.hidden = YES;
    _searchHisToryTF.text = @"";
}

#pragma mark -  取消事件
- (IBAction)CancelBtnACtion:(UIButton *)sender {
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
 self.searchCancel(self.searchHisToryTF.text);
    _ClearBtn.hidden = YES;

    [self sendSubviewToBack :  self.searchHisToryTF];
    [self.searchHisToryTF resignFirstResponder];
    _BackConstrainWidth.constant = 34;
    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64) ;

    
}

///返回事件
-(void)backAction:(SearchBack)searchBack{
    self.searchBack = searchBack;
}
///搜索事件
-(void)searchAction:(SearchSearch)searchSearch;
{
   

        self.searchSearch = searchSearch;

   
}
///取消事件
-(void)CancelAction:(SearchCancel)searchCancel{
    self.searchCancel = searchCancel;
}

///键盘return

-(void)SearchTFReturn:(SearechTFValue)searechTFValue{
    self.searechTFValue =searechTFValue;
}

@end
