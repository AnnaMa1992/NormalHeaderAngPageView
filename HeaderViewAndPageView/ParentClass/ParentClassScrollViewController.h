//
//  ParentClassScrollViewController.h
//  Kitchen
//
//  Created by su on 16/7/8.
//  Copyright © 2016年 susu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol scrollDelegate <NSObject>
-(void)scrollViewLeaveAtTheTop:(UIScrollView *)scrollView;
-(void)scrollViewChangeTab:(UIScrollView *)scrollView;
@end

@interface ParentClassScrollViewController : UIViewController

@property(nonatomic,weak)id<scrollDelegate>delegate;
@end

