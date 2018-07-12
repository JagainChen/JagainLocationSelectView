//
//  ViewController.m
//  Location
//
//  Created by Jagain on 2018/7/4.
//  Copyright © 2018年 Jagain. All rights reserved.
//

#import "ViewController.h"

#import "CGHSelectView.h"

@interface ViewController ()<CGHSelectViewDelegete>
{
    CGHSelectView *_selectView;
    
    NSArray *_dataArray;
}


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self getData];
}

- (CGHSelectView *)selectView{
    
    if (!_selectView) {
        _selectView = [[CGHSelectView alloc] initWithNumbers:3 withDelegate:self];
    }
    
    return _selectView;
}

- (void)getData{
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"省市区" ofType:@"json"]];
    NSError *error;

    id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    _dataArray = (NSArray *)json;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.selectView showSelect];
}

#pragma mark - CGHSelectViewDelegete
- (NSInteger)numberOfRowsAtPage:(NSInteger)page{
    switch (page) {
        case 0:return _dataArray.count;
        case 1:return [_dataArray[[self.selectView.selectIndexArray[0] integerValue]][@"childs"] count];
        case 2:{
            NSDictionary *dic = _dataArray[[self.selectView.selectIndexArray[0] integerValue]];
            dic = dic[@"childs"][[self.selectView.selectIndexArray[1] integerValue]];
            if (dic[@"childs"]) {
                return [dic[@"childs"] count];
            }else{
                return 0;
            }
        }break;
        default:return 0;
    }
}

- (NSString *)titleAtIndex:(NSInteger)index atPage:(NSInteger)page{
    switch (page) {
        case 0:return _dataArray[index][@"value"];
        case 1:return _dataArray[[self.selectView.selectIndexArray[0] integerValue]][@"childs"][index][@"value"];
        case 2:{
            NSDictionary *dic = _dataArray[[self.selectView.selectIndexArray[0] integerValue]];
            dic = dic[@"childs"][[self.selectView.selectIndexArray[1] integerValue]];
            dic = dic[@"childs"][index];
            
            if (dic[@"value"]) {
                return dic[@"value"];
            }else{
                return @"";
            }
        }break;
            
        default:return @"";
    }
}


@end
