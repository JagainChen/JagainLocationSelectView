//
//  CGHSelectView.m
//  Location
//
//  Created by Jagain on 2018/7/6.
//  Copyright © 2018年 Jagain. All rights reserved.
//

#import "CGHSelectView.h"
#import "JagainBaseTableViewCell.h"

#import <Masonry/Masonry.h>

@interface CGHSelectView ()
{
    UIView *_selectSignView;
}


@end

@implementation CGHSelectView

- (instancetype)initWithNumbers:(NSInteger )numbers withDelegate:(id<CGHSelectViewDelegete>)delegate
{
    if (self = [super init]) {
        _numbers = numbers;
        _delegate = delegate;
        _nowSelectPage = 0;
        _selectIndexArray = [NSMutableArray arrayWithCapacity:_numbers];

        self.backgroundColor = [UIColor colorWithRed:91/255.0 green:91/255.0 blue:91/255.0 alpha:0.6];
        self.frame = [UIScreen mainScreen].bounds;
        [self setUpView];
    }
    
    return self;
}

///初始化页面
- (void)setUpView{
    _titleSelectScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, jagainScreenHeight, self.frame.size.width, CGHSelectViewSingleViewHeight)];
    _titleSelectScrollView.backgroundColor = [UIColor whiteColor];
    _titleSelectScrollView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _titleSelectScrollView.layer.borderWidth = 0.5;
    _titleSelectScrollView.showsHorizontalScrollIndicator = NO;
    
    UIControl *control = [self getControlWithTag:900 withTitle:@"请选择"];
    control.frame = CGRectMake(0, 0, control.frame.size.width, control.frame.size.height);
    [self changeTheSelectSignWithControl:control];

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleSelectScrollView.frame), self.frame.size.width, CGHSelectViewDataViewHeight) style:UITableViewStylePlain];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [_tableView registerClass:[JagainBaseTableViewCell class] forCellReuseIdentifier:@"CGHSelectTableViewCellIdentifier"];
    
    [self addSubview:_titleSelectScrollView];
    [self addSubview:_tableView];
}

#pragma mark - 懒加载
- (UIView *)selectSignView{
    if (!_selectSignView) {
        _selectSignView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.titleSelectScrollView.frame) - 2, 0, 2)];
        _selectSignView.backgroundColor = [UIColor orangeColor];
        
        [self.titleSelectScrollView addSubview:_selectSignView];
    }
    
    return _selectSignView;
}

#pragma mark - 试图展示和关闭
- (void)showSelect{
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    
    [window addSubview:self];
    [UIView animateWithDuration:0.5 animations:^{
        self.titleSelectScrollView.transform = CGAffineTransformTranslate(self.titleSelectScrollView.transform, 0, - CGRectGetMaxY(self.tableView.frame) + jagainScreenHeight);
        self.tableView.transform = CGAffineTransformTranslate(self.tableView.transform, 0, - CGRectGetMaxY(self.tableView.frame) + jagainScreenHeight);
    }];
}

- (void)closeSelect{
    [UIView animateWithDuration:0.5 animations:^{
        self.titleSelectScrollView.transform = CGAffineTransformIdentity;
        self.tableView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - 对选择按钮的操作
- (void)changeTheSelectControl:(UIControl *)control{
    _nowSelectPage = control.tag - 900;
    [self changeTheSelectSignWithControl:[self.titleSelectScrollView viewWithTag:900 + _nowSelectPage]];
    [self.tableView reloadData];
    
    UILabel *label = [control viewWithTag:1000 + control.tag];
    if ([label.text isEqualToString:@"请选择"]) {
        return;
    }
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[[self.selectIndexArray objectAtIndex:_nowSelectPage] integerValue] inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
}

///将多余的control隐藏
- (void)changeTheControlState{
    NSInteger index = _nowSelectPage;
    index++;
    UIControl *control = [self.titleSelectScrollView viewWithTag:900 + index];
    while (control) {
        control.hidden = YES;
        index++;
        control = [self.titleSelectScrollView viewWithTag:900 + index];
    }
    
    //如果control超过父视图，让父视图可滑动
    CGFloat maxX = CGRectGetMaxX([self.titleSelectScrollView viewWithTag:900 + _nowSelectPage].frame);
    maxX = MAX(maxX, jagainScreenWidth);
    self.titleSelectScrollView.contentSize = CGSizeMake(maxX, self.titleSelectScrollView.contentSize.height);

    //改变选择的效果
    [self changeTheSelectSignWithControl:[self.titleSelectScrollView viewWithTag:900 + _nowSelectPage]];
    
}

- (void)changeTheSelectSignWithControl:(UIControl *)control{
    CGFloat maxX = self.titleSelectScrollView.contentSize.width;
    
    //滑动
    if (maxX > jagainScreenWidth) {
        CGFloat offestX = [self.titleSelectScrollView viewWithTag:900 + _nowSelectPage].center.x - jagainScreenWidth / 2;
        offestX = offestX + jagainScreenWidth / 2 > maxX - jagainScreenWidth ? maxX - jagainScreenWidth : offestX;
        offestX = offestX < 0 ? 0 : offestX;
        
        [self.titleSelectScrollView setContentOffset:CGPointMake(offestX, 0) animated:YES];
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        self.selectSignView.bounds = CGRectMake(self.selectSignView.bounds.origin.x, self.selectSignView.bounds.origin.y, 0, self.selectSignView.bounds.size.height);
    } completion:^(BOOL finished) {
        [self.titleSelectScrollView insertSubview:self.selectSignView aboveSubview:control];
        self.selectSignView.center = CGPointMake(control.center.x, self.selectSignView.center.y);
        [UIView animateWithDuration:0.2 animations:^{
            self.selectSignView.bounds = CGRectMake(self.selectSignView.bounds.origin.x, self.selectSignView.bounds.origin.y, control.frame.size.width, self.selectSignView.bounds.size.height);
        } completion:^(BOOL finished) {
            
        }];
    }];

}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.delegate) {
        return [self.delegate numberOfRowsAtPage:_nowSelectPage];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CGHSelectTableViewCellIdentifier" forIndexPath:indexPath];
    
    if ([self.delegate respondsToSelector:@selector(titleAtIndex:atPage:)]) {
        cell.textLabel.text = [self.delegate titleAtIndex:indexPath.row atPage:_nowSelectPage];
        cell.textLabel.textColor = [UIColor colorWithRed:91/255.0 green:91/255.0 blue:91/255.0 alpha:1];

        if (self.selectIndexArray.count > _nowSelectPage) {
            cell.imageView.image = [UIImage imageNamed:@"select_icon"];
            cell.imageView.hidden = [self.selectIndexArray[_nowSelectPage] integerValue] != indexPath.row;
            cell.textLabel.textColor = [self.selectIndexArray[_nowSelectPage] integerValue] != indexPath.row ? [UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:1] : [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
            cell.textLabel.font = [self.selectIndexArray[_nowSelectPage] integerValue] != indexPath.row ? [UIFont systemFontOfSize:16] : [UIFont systemFontOfSize:16 weight:UIFontWeightBold];
        }else{
            cell.imageView.hidden = YES;
        }
    }else{
        cell.textLabel.text = @"";
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CGHSelectViewSingleViewHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self getControlWithTag:900 + _nowSelectPage withTitle:[self.delegate titleAtIndex:indexPath.row atPage:_nowSelectPage]];
    
    if ([self.delegate respondsToSelector:@selector(selectView:didSelectTheContentAtIndex:atPage:)]) {
        [self.delegate selectView:self didSelectTheContentAtIndex:indexPath.row atPage:_nowSelectPage];
    }
    
    if (_selectIndexArray.count > _nowSelectPage) {
        [_selectIndexArray replaceObjectAtIndex:_nowSelectPage withObject:[NSNumber numberWithInteger:indexPath.row]];
        _selectIndexArray = [NSMutableArray arrayWithArray:[_selectIndexArray subarrayWithRange:NSMakeRange(0, _nowSelectPage + 1)]];
    }else{
        [_selectIndexArray addObject:[NSNumber numberWithInteger:indexPath.row]];
    }
    
    if (_nowSelectPage + 1 > self.numbers || [self.delegate numberOfRowsAtPage:_nowSelectPage + 1 ] == 0) {
        [self closeSelect];
        
        [self changeTheControlState];
        [tableView reloadData];
        if ([self.delegate respondsToSelector:@selector(selectView:finishTheLastSelectWithSelection:)]) {
            [self.delegate selectView:self finishTheLastSelectWithSelection:self.selectIndexArray];
        }
        return;
    }
    
    _nowSelectPage ++;
    [self getControlWithTag:900 + _nowSelectPage withTitle:@"请选择"];
    [self changeTheControlState];
    [tableView reloadData];
    [self.tableView setContentOffset:CGPointZero];
}

///点击消失
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];

    if (location.y < self.titleSelectScrollView.frame.origin.y) {
        [self closeSelect];
    }
}


#pragma mark - 创建点击按钮
- (UIControl *)getControlWithTag:(NSInteger )tag withTitle:(NSString *)title{
    UIControl *control = [_titleSelectScrollView viewWithTag:tag];
    if (!control) {
        control = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 100, CGHSelectViewSingleViewHeight)];
        [control addTarget:self action:@selector(changeTheSelectControl:) forControlEvents:UIControlEventTouchUpInside];
        
        control.tag = tag;
        UILabel *label = [[UILabel alloc] init];
        label.tag = 1000 + tag;
        label.font = [UIFont systemFontOfSize:17];

        label.textAlignment = NSTextAlignmentCenter;
        
        [control addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(control.mas_centerY);
            make.centerX.equalTo(control.mas_centerX);
            make.left.equalTo(control.mas_left).offset(15);
        }];
        
        [_titleSelectScrollView addSubview:control];
    }
    
    UILabel *label = [control viewWithTag:1000 + tag];
    
    label.text = title;
    label.textColor = [title isEqualToString:@"请选择"] ? [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1] : [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
    label.font = [title isEqualToString:@"请选择"] ? [UIFont systemFontOfSize:17] : [UIFont systemFontOfSize:19 weight:UIFontWeightBold];
    [label updateConstraints];
    [label sizeToFit];
    control.frame = CGRectMake(0, 0, label.frame.size.width + 30, control.frame.size.height);
    UIView *frontView = [_titleSelectScrollView viewWithTag:tag - 1];
    if (frontView) {
        control.frame = CGRectMake(CGRectGetMaxX(frontView.frame), 0, label.frame.size.width + 30, control.frame.size.height);
    }
    
    control.hidden = tag > 900 + _nowSelectPage;
    
    return control;
}



@end
