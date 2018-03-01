 一 、介绍
 NormalHeaderAngPageView
 
 简单的头部视图和分段视图控制器的联动效果
 
 ![image](https://github.com/AnnaMa1992/NormalHeaderAngPageView/blob/master/HeaderViewAndPageView/UntitledNormal.gif)   

 二、实现方法
代码极其简单操作流畅，主视图用tableView搭建，只需要继承MainTouchTableTableView即可。
分页的tableview等需要继承父类ParentClassScrollViewController
三、主要说明
本次更新采用代理传值改变控制主控制器的滚动状态

作者这里使用一款github较多人使用的 WMPageController 地址https://github.com/wangmchn/WMPageController

本项目这里用到了代理所以更改了WMPageController原作者的#import "WMPageController.m"中的初始化方法

原作者
- (UIViewController *)initializeViewControllerAtIndex:(NSInteger)index {
    if ([self.dataSource respondsToSelector:@selector(pageController:viewControllerAtIndex:)]) {
        return [self.dataSource pageController:self viewControllerAtIndex:index];
    }
    return [[self.viewControllerClasses[index] alloc] init];
}

这里修改为
/*  素素修改 */
- (UIViewController *)initializeViewControllerAtIndex:(NSInteger)index {
    if ([self.dataSource respondsToSelector:@selector(pageController:viewControllerAtIndex:)]) {
        return [self.dataSource pageController:self viewControllerAtIndex:index];
    }
    return (UIViewController *)self.viewControllerClasses[index];
}

言语苍白 具体实现请看代码。 
