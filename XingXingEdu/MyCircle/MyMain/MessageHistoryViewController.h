//
//  MessageHistoryViewController.h
//  XingXingEdu
//
//  Created by mac on 16/8/5.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageHistoryViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@end
