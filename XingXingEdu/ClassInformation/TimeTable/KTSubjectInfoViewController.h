//
//  KTSubjectInfoViewController.h
//  XingXingEdu
//    ___  _____   ______  __ _   _________
//   / _ \/ __/ | / / __ \/ /| | / / __/ _ \
//  / , _/ _/ | |/ / /_/ / /_| |/ / _// , _/
// /_/|_/___/ |___/\____/____/___/___/_/|_|
//
//  Created by keenteam on 16/6/17.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KTSubjectInfoViewController : UIViewController
@property(nonatomic ,strong)NSMutableArray *dataArr;
@property(nonatomic, copy)NSString *weekDataStr;

@property(nonatomic,assign)BOOL hidden;

@end
