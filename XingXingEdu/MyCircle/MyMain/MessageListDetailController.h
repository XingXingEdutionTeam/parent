//
//  MessageListDetailController.h
//  XingXingEdu
//
//  Created by mac on 16/6/7.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MessageListDetailController : UIViewController
//id
@property (nonatomic,copy) NSString *talkId;
@property (nonatomic, strong) UITableView *tableView;
@end
