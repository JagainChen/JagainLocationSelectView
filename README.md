# LocationSelectView
简单实现了一个地址选择器，主要为了自己尝试git
## 使用方式
```Objective-C
#pragma mark - CGHSelectViewDelegete
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
```
## 实现的效果
![](https://github.com/JagainChen/JagainLocationSelectView/blob/master/ScreenShot.jpeg)  
## 联系方式
Email ：jagain@icloud.com


