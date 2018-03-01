//
//  MainViewController.m
//  HeaderViewAndPageView
//
//  Created by su on 16/8/8.
//  Copyright © 2016年 susu. All rights reserved.
//

#import "MainViewController.h"
#import "OneViewTableTableViewController.h"
#import "SecondViewTableViewController.h"
#import "ThirdViewCollectionViewController.h"
#import "MainTouchTableTableView.h"
#import "ParentClassScrollViewController.h"
#import "WMPageController.h"

#define Main_Screen_Height      [[UIScreen mainScreen] bounds].size.height
#define Main_Screen_Width       [[UIScreen mainScreen] bounds].size.width

static CGFloat const headViewHeight = 256;

@interface MainViewController ()<UITableViewDelegate,UITableViewDataSource,scrollDelegate,WMPageControllerDelegate>

@property(nonatomic ,strong)MainTouchTableTableView * mainTableView;
@property(nonatomic,strong) UIScrollView * parentScrollView;

@property(nonatomic,strong)UIImageView *headImageView;//头部图片
@property(nonatomic,strong)UIImageView * avatarImage;
@property(nonatomic,strong)UILabel *countentLabel;
/*
 * canScroll= yes : mainTableView 视图可以滚动，parentScrollView 禁止滚动
 */
@property (nonatomic, assign) BOOL canScroll;

@property (nonatomic, assign) BOOL isTopIsCanNotMoveMainTableView;
@property (nonatomic, assign) BOOL isTopIsCanNotMoveParentScrollView;

@end

@implementation MainViewController
@synthesize mainTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"HeaderAndPageView";
    
    [self.view addSubview:self.mainTableView];
    
    [self.mainTableView addSubview:self.headImageView];
    //支持下刷新。关闭弹簧效果
    self.mainTableView.bounces =  NO;
//
    if (@available(iOS 11.0, *)) {
        self.mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.canScroll = YES;
}

#pragma scrollDelegate
-(void)scrollViewLeaveAtTheTop:(UIScrollView *)scrollView
{
    self.parentScrollView = scrollView;
    
    //离开顶部 主View 可以滑动
    self.canScroll = YES;
}

-(void)scrollViewChangeTab:(UIScrollView *)scrollView
{
    self.parentScrollView = scrollView;
    /*
     * 如果已经离开顶端 切换tab parentScrollView的contentOffset 应该初始化位置
     * 这一规则 仿简书
     */
    if (self.canScroll) {
        self.parentScrollView.contentOffset = CGPointMake(0, 0);
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    /*
     *  处理联动事件
     */
    
    //获取滚动视图y值的偏移量
    CGFloat tabOffsetY = 0;
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (offsetY >=headViewHeight) {
        
        scrollView.contentOffset = CGPointMake(0, tabOffsetY);
        offsetY = tabOffsetY;
    }
    
    self.isTopIsCanNotMoveParentScrollView = self.isTopIsCanNotMoveMainTableView;
    
    if (offsetY>=tabOffsetY) {
        scrollView.contentOffset = CGPointMake(0, tabOffsetY);
        self.isTopIsCanNotMoveMainTableView = YES;
    }else{
        self.isTopIsCanNotMoveMainTableView = NO;
    }
    
    if (self.isTopIsCanNotMoveMainTableView != self.isTopIsCanNotMoveParentScrollView) {
        if (!self.isTopIsCanNotMoveParentScrollView && self.isTopIsCanNotMoveMainTableView) {
            //滑动到顶端
            self.canScroll = NO;
        }
        
        if(self.isTopIsCanNotMoveParentScrollView && !self.isTopIsCanNotMoveMainTableView){
            //离开顶端
            if (!self.canScroll) {
                scrollView.contentOffset = CGPointMake(0, tabOffsetY);
            }else{
                self.parentScrollView.contentOffset = CGPointMake(0, tabOffsetY);
            }
        }
    }else
    {
        if (!self.canScroll){
             //支持下刷新,下拉时maintableView 没有滚动到位置 parentScrollView 不进行刷新
            CGFloat parentScrollViewOffsetY = self.parentScrollView.contentOffset.y;
            if(parentScrollViewOffsetY >0)
                self.parentScrollView.contentOffset = CGPointMake(0, 0);
        }else
        {
            self.parentScrollView.contentOffset = CGPointMake(0, 0);
        }
    }
    
    
    /**
     * 处理头部视图
     */
//    CGFloat yOffset  = scrollView.contentOffset.y;
//    if(yOffset < -headViewHeight) {
//
//        CGRect f = self.headImageView.frame;
//        f.origin.y= yOffset ;
//        f.size.height=  -yOffset;
//        f.origin.y= yOffset;
//
//        //改变头部视图的fram
//        self.headImageView.frame= f;
//        CGRect avatarF = CGRectMake(f.size.width/2-40, (f.size.height-headViewHeight)+56, 80, 80);
//        _avatarImage.frame = avatarF;
//        _countentLabel.frame = CGRectMake((f.size.width-Main_Screen_Width)/2+40, (f.size.height-headViewHeight)+172, Main_Screen_Width-80, 36);
//    }
}

#pragma mark --tableDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return Main_Screen_Height-64;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    /* 添加pageView
     * 这里可以任意替换你喜欢的pageView
     *作者这里使用一款github较多人使用的 WMPageController 地址https://github.com/wangmchn/WMPageController
     */
    [cell.contentView addSubview:self.setPageViewControllers];
    
    return cell;
}


#pragma mark -- setter/getter

-(UIView *)setPageViewControllers
{
    WMPageController *pageController = [self p_defaultController];
    pageController.title = @"Line";
    pageController.menuViewStyle = WMMenuViewStyleLine;
    pageController.titleSizeSelected = 15;
    
    [self addChildViewController:pageController];
    [pageController didMoveToParentViewController:self];
    return pageController.view;
}

- (WMPageController *)p_defaultController {
    OneViewTableTableViewController * oneVc  = [OneViewTableTableViewController new];
    oneVc.delegate = self;
    SecondViewTableViewController * twoVc  = [SecondViewTableViewController new];
    twoVc.delegate = self;
    ThirdViewCollectionViewController * thirdVc  = [ThirdViewCollectionViewController new];
    thirdVc.delegate = self;
    
    NSArray *viewControllers = @[oneVc,twoVc,thirdVc];
    
    NSArray *titles = @[@"first",@"second",@"third"];
    WMPageController *pageVC = [[WMPageController alloc] initWithViewControllerClasses:viewControllers andTheirTitles:titles];
    [pageVC setViewFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height)];
    pageVC.delegate = self;
    pageVC.menuItemWidth = 85;
    pageVC.menuHeight = 44;
    pageVC.postNotification = YES;
    pageVC.bounces = YES;
    return pageVC;
}

- (void)pageController:(WMPageController *)pageController willEnterViewController:(__kindof UIViewController *)viewController withInfo:(NSDictionary *)info {
    NSLog(@"%@",viewController);
}

-(UIImageView *)headImageView
{
    if (_headImageView == nil)
    {
        _headImageView= [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg.jpg"]];
        _headImageView.frame=CGRectMake(0, -headViewHeight ,Main_Screen_Width,headViewHeight);
        _headImageView.userInteractionEnabled = YES;
        
        _avatarImage = [[UIImageView alloc] initWithFrame:CGRectMake(Main_Screen_Width/2-40, 56, 80, 80)];
        [_headImageView addSubview:_avatarImage];
        _avatarImage.userInteractionEnabled = YES;
        _avatarImage.layer.masksToBounds = YES;
        _avatarImage.layer.borderWidth = 1;
        _avatarImage.layer.borderColor =[[UIColor colorWithRed:255/255. green:253/255. blue:253/255. alpha:1.] CGColor];
        _avatarImage.layer.cornerRadius = 40;
        _avatarImage.image = [UIImage imageNamed:@"avatar.jpg"];
        
        
        _countentLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 150, Main_Screen_Width-80, 30)];
        _countentLabel.font = [UIFont systemFontOfSize:12.];
        _countentLabel.textColor = [UIColor colorWithRed:255/255. green:255/255. blue:255/255. alpha:1.];
        _countentLabel.textAlignment = NSTextAlignmentCenter;
        _countentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _countentLabel.numberOfLines = 0;
        _countentLabel.text = @"我的名字叫Anna";
        [_headImageView addSubview:_countentLabel];
    }
    return _headImageView;
}


-(MainTouchTableTableView *)mainTableView
{
    if (mainTableView == nil)
    {
        mainTableView= [[MainTouchTableTableView alloc]initWithFrame:CGRectMake(0,64,Main_Screen_Width,Main_Screen_Height-64)];
        mainTableView.delegate=self;
        mainTableView.dataSource=self;
        mainTableView.showsVerticalScrollIndicator = NO;
        mainTableView.contentInset = UIEdgeInsetsMake(headViewHeight,0, 0, 0);
        mainTableView.backgroundColor = [UIColor clearColor];
    }
    return mainTableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
