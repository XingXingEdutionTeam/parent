//
//  FlowerBasketViewController.m
//  XingXingEdu
//
//  Created by keenteam on 16/3/24.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//
#define KT @"yyyy年MM月dd日 HH:MM:ss"
#define kPData  @"FlowerBascketCell"
#import "FlowerBasketViewController.h"
#import "FlowersPresentViewController.h"
#import "FlowersBuyViewController.h"
#import "FlowerBascketCell.h"
#import "SendFlowerBaskerDetailController.h"
@interface FlowerBasketViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSInteger x;
//    NSMutableArray *conMArr;
    NSMutableArray *_dateMArr;
//    NSMutableArray *head_imgMArr;
//    NSMutableArray *idMArr;
//    NSMutableArray *numMArr;
//    NSMutableArray *tnameMArr;
    NSString *confromTimespStr;
    NSInteger j;
    NSString *fbasketStr;
    NSString *basketStr;
    UILabel *leftLb;
    UILabel *overLb;
    NSString *flowersNum;
    
}
@end

@implementation FlowerBasketViewController
- (void)viewWillAppear:(BOOL)animated{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self initUI];
    
    [self createHeadView];
    
    [_tableView reloadData];
    [_tableView.header beginRefreshing];
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    

    
    self.title =@"花篮";
    self.view.backgroundColor = UIColorFromRGB(196, 213, 255);
    
    [self initData];
    
     [self createTableView];
    // Do any additional setup after loading the view.
    
}
- (void)createHeadView{
    //headView
    UIView *headView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 55)];
    
    UIButton *sentBtn =[HHControl createButtonWithFrame:CGRectMake(0, 0, kWidth / 2, 30) backGruondImageName:nil Target:self Action:@selector(sent:) Title:@"赠送"];
    sentBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [sentBtn setTitleColor:UIColorFromRGB(0, 170, 42) forState:UIControlStateNormal];
    [headView addSubview:sentBtn];
    
    UIButton *buyBtn =[HHControl createButtonWithFrame:CGRectMake(kWidth/2, 0, kWidth / 2, 30) backGruondImageName:nil Target:self Action:@selector(buy:) Title:@"购买"];
    buyBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [buyBtn setTitleColor:UIColorFromRGB(0, 170, 42) forState:UIControlStateNormal];
    [headView addSubview:buyBtn];
    
    leftLb =[HHControl createLabelWithFrame:CGRectMake(0, 30, kWidth / 2, 15) Font:10 Text:[NSString stringWithFormat:@"剩余花篮数: %ld", (long)[fbasketStr integerValue]]];
    [leftLb setTextColor:[UIColor lightGrayColor]];
    leftLb.textAlignment = NSTextAlignmentCenter;
    [headView addSubview:leftLb];
    
    overLb =[HHControl createLabelWithFrame:CGRectMake(kWidth / 2, 30, kWidth / 2, 15) Font:10 Text:[NSString stringWithFormat:@"已赠花篮数: %d",[basketStr integerValue]-[fbasketStr integerValue]]];
    [overLb setTextColor:[UIColor lightGrayColor]];
    //    overLb.backgroundColor = [UIColor blueColor];
    overLb.textAlignment = NSTextAlignmentCenter;
    [headView addSubview:overLb];
    
    //投影750x4
    UIImageView *lineOne = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth / 2 - 1, 0, 1, 45)];
    lineOne.image = [UIImage imageNamed:@"投影750x4"];
    UIImageView *lineTwo = [[UIImageView alloc] initWithFrame:CGRectMake(0, 45, kWidth, 1)];
    lineTwo.image = [UIImage imageNamed:@"投影750x4"];
    [headView addSubview:lineOne];
    
    _tableView.tableHeaderView =headView;
    
    
}

- (void)initUI{
    
    
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/getUserGlobalInfo";
    NSDictionary *dict = @{@"appkey":APPKEY,
                           @"backtype":BACKTYPE,
                           @"xid":XID,
                           @"user_id":USER_ID,
                           @"user_type":USER_TYPE,
                           @"field":@"fbasket_able,fbasket_total",
                           };
    
    [WZYHttpTool post:urlStr params:dict success:^(id responseObj) {
        
        
        
        NSDictionary *dict =responseObj;
        
        if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] )
        {
            leftLb.text=[NSString stringWithFormat:@"剩余花篮数: %d", [[dict[@"data"] objectForKey:@"fbasket_able"] integerValue]];
            flowersNum =[NSString stringWithFormat:@"%d", [[dict[@"data"] objectForKey:@"fbasket_able"] integerValue]];
            overLb.text =[NSString stringWithFormat:@"已赠花篮数: %d",[[dict[@"data"] objectForKey:@"fbasket_total"] integerValue] -[[dict[@"data"] objectForKey:@"fbasket_able"] integerValue]];
            
            [_tableView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
    
    
}
- (void)initData{

    _dateMArr = [NSMutableArray array];
    //teacher
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/fbasket_record";
    NSDictionary *dict = @{@"appkey":APPKEY,
                           @"backtype":BACKTYPE,
                           @"xid":XID,
                           @"user_id":USER_ID,
                           @"user_type":USER_TYPE,
                           };
    
    [WZYHttpTool post:urlStr params:dict success:^(id responseObj) {
        
        NSDictionary *dict =responseObj;
        
        if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] )
        {
            
            x =[dict[@"data"] count];
            for (int i=0; i<[dict[@"data"] count]; i++) {
                
                
                NSString *con = [dict[@"data"][i] objectForKey:@"con"];
                NSString *date_tm = [dict[@"data"][i] objectForKey:@"date_tm"];
                NSString *head_img_type = [dict[@"data"][i] objectForKey:@"head_img_type"];
                NSString *head_img = [dict[@"data"][i] objectForKey:@"head_img"];
                NSString *sendId = [dict[@"data"][i] objectForKey:@"id"];
                NSString *num = [dict[@"data"][i] objectForKey:@"num"];
                NSString *tname = [dict[@"data"][i] objectForKey:@"tname"];
                
                NSMutableArray *arr=[NSMutableArray arrayWithObjects:con,date_tm,head_img_type,head_img,sendId, num,tname,nil];
                [_dateMArr addObject:arr];
        
            }
            
            [_tableView reloadData];
            [_tableView.header endRefreshing];
        }
        
    } failure:^(NSError *error) {
        
    }];
    
}
- (void)createTableView{
    
    _tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight) style:UITableViewStyleGrouped];
    _tableView.delegate =self;
    _tableView.dataSource =self;
    [self.view addSubview:_tableView];
    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
}
-(void)loadNewData{
    
    
    [self initData];
    
}

- (void)sent:(UIButton*)btn{
    FlowersPresentViewController *flowersPresentVC =[[FlowersPresentViewController alloc]init];
    flowersPresentVC.flowersRemain =flowersNum;
    [self.navigationController pushViewController:flowersPresentVC animated:NO];
    
}
- (void)buy:(UIButton*)bt{
    
    FlowersBuyViewController *flowerBuyVC =[[FlowersBuyViewController alloc]init];
    flowerBuyVC.flowersRemain =flowersNum;
    [self.navigationController pushViewController:flowerBuyVC animated:NO];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return x;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.000001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FlowerBascketCell *cell =(FlowerBascketCell*)[tableView dequeueReusableCellWithIdentifier:kPData];
    
    if (!cell) {
        NSArray *nib =[[NSBundle mainBundle]loadNibNamed:kPData owner:[FlowerBascketCell class] options:nil];
        cell =(FlowerBascketCell*)[nib objectAtIndex:0];
        
    }
    
    NSArray *tmp = _dateMArr[indexPath.row];
    
    cell.imageV.layer.cornerRadius =30;
    cell.imageV.layer.masksToBounds =YES;
    
    if ([tmp[2] isEqualToString:@"0"]) {
        [cell.imageV sd_setImageWithURL: [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",picURL,tmp[3]]] placeholderImage:[UIImage imageNamed:@"LOGO172x172@2x"]];

    }else{
         [cell.imageV sd_setImageWithURL: [NSURL URLWithString:[NSString stringWithFormat:@"%@",tmp[3]]] placeholderImage:[UIImage imageNamed:@"LOGO172x172@2x"]];
    }
    
    
    cell.teacherLabel.text =tmp[6];
    cell.numLabel.text =[NSString stringWithFormat:@"花篮: %@",tmp[5]];
    cell.textLabe.text =[NSString stringWithFormat:@"赠言: %@",tmp[0]];

    cell.timeLbl.text =[NSString stringWithFormat:@"%@",[WZYTool dateStringFromNumberTimer:tmp[1]]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SendFlowerBaskerDetailController *SendFlowerBaskerDetailVC = [[SendFlowerBaskerDetailController alloc] init];
    SendFlowerBaskerDetailVC.teacherLabel = _dateMArr[indexPath.row][6];
    SendFlowerBaskerDetailVC.numLabel = _dateMArr[indexPath.row][5];
    SendFlowerBaskerDetailVC.timeLbl = _dateMArr[indexPath.row][1];
    SendFlowerBaskerDetailVC.textLabe = _dateMArr[indexPath.row][0];
    [self.navigationController pushViewController:SendFlowerBaskerDetailVC animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
