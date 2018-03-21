 一 、介绍
 NormalHeaderAngPageView
 
 简单的头部视图和分段视图控制器的联动效果
 
 ![image](https://github.com/AnnaMa1992/NormalHeaderAngPageView/blob/master/HeaderViewAndPageView/Untitled2.gif)   

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

/*********************/
最新更新-支持列表下拉刷新

如果您的项目需要头部视图实现一些动效,不需要下拉刷新效果

 1.您需要修改demo中MainViewController ,viewDidLoad 中  设置self.mainTableView.bounces = YES;
 2.需要修改MainViewController,- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
  
//        if (!self.canScroll){
             //支持下刷新,下拉时maintableView 没有滚动到位置 parentScrollView 不进行刷新
//            CGFloat parentScrollViewOffsetY = self.parentScrollView.contentOffset.y;
//            if(parentScrollViewOffsetY >0)
//                self.parentScrollView.contentOffset = CGPointMake(0, 0);
//        }else
//        {
            self.parentScrollView.contentOffset = CGPointMake(0, 0);
//        }
    }
    
  删除这段代码中注释部分,也就是else中只保留 self.parentScrollView.contentOffset = CGPointMake(0, 0);
