//
//  CGHSelectView.h
//  Location
//
//  Created by Jagain on 2018/7/6.
//  Copyright © 2018年 Jagain. All rights reserved.
//

#import <UIKit/UIKit.h>

#define jagainScreenWidth [UIScreen mainScreen].bounds.size.width
#define jagainScreenHeight [UIScreen mainScreen].bounds.size.height
#define CGHSelectViewSingleViewHeight 45.0f
//默认展示6行的数据
#define CGHSelectViewDataViewHeight CGHSelectViewSingleViewHeight * 6

@class CGHSelectView;
@protocol CGHSelectViewDelegete<NSObject>

@required
/**
 *@brief 得到对应page的index显示的内容
 *@param index 当前展示的数据位置下标
 *@param page 当前展示的页数下标
 */
- (NSString *)titleAtIndex:(NSInteger )index atPage:(NSInteger )page;

/**
 *@brief 得到对应page的index数
 *@param page 当前展示的页数下标
 */
- (NSInteger )numberOfRowsAtPage:(NSInteger )page;

@optional
/**
 *@brief 点击对应page的index显示的内容
 *@param index 当前展示的数据位置下标
 *@param page 当前展示的页数下标
 */
- (void)selectView:(CGHSelectView *)selectView didSelectTheContentAtIndex:(NSInteger )index atPage:(NSInteger )page;

/**
 *@brief 选择完成后
 *@param selection 最后的选择结果
 */
- (void)selectView:(CGHSelectView *)selectView finishTheLastSelectWithSelection:(NSArray *)selection;

@end

@interface CGHSelectView : UIView <UITableViewDataSource, UITableViewDelegate>

///可以选择的列数
@property (nonatomic, readonly, assign) NSInteger numbers;
///代理
@property (nonatomic, readwrite, weak) id<CGHSelectViewDelegete> delegate;
///展示数据的试图
@property (nonatomic, readonly, strong) UITableView *tableView;
///展示选择的试图
@property (nonatomic, readonly, strong) UIScrollView *titleSelectScrollView;
///当前展示的数据页下标
@property (nonatomic, readonly, assign) NSInteger nowSelectPage;
///记录当前的选择记录
@property (nonatomic, strong) NSMutableArray *selectIndexArray;

- (instancetype)initWithNumbers:(NSInteger )numbers withDelegate:(id<CGHSelectViewDelegete>)delegate;

- (void)showSelect;

@end
