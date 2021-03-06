//
//  ClassRoomSubjectInfoViewController.m
//  XingXingEdu
//
//  Created by codeDing on 16/2/28.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "ClassRoomSubjectInfoViewController.h"
#import "SubjectBuyViewController.h"
#import "CoreUMeng.h"
#import "SJAvatarBrowser.h"
#import "WMConversationViewController.h"
#import "RedFlowerViewController.h"


#define Kmarg 15.0f
#define KLabelX 20.0f
#define KLabelW 65.0f
#define KLabelH 30.0f
#define kUnderButtonH 64.0f
@interface ClassRoomSubjectInfoViewController ()<UITextViewDelegate>{
    NSInteger  imgCount;
    UIScrollView *bgScrollView;
    UIScrollView *scrollView;//课程详情图片滚动
    NSMutableArray *detailedLabelArr;//课程列表数据
    NSString * details;//课程详情
    NSMutableArray *picGroup;//详情图片
    NSString * course_name;//科目名称
    NSMutableArray *_picImageArr;
    BOOL isCollect;
    UIButton *_buyBtn;
    NSMutableArray * infoArray;
    
    NSInteger picRow;
}

@property (nonatomic, strong) UIView *bottomView;


@end

@implementation ClassRoomSubjectInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets=YES;
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.view.backgroundColor=[UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    
    [self getSubjectInfo:self.courseId];
 
    
}

#pragma mark 网络 获取课程详情
//获取课程列表
- (void)getSubjectInfo:(NSString *)courseId
{
    
    detailedLabelArr = [NSMutableArray array];
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/xkt_course_detail";
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *dict = @{@"appkey":APPKEY,
                           @"backtype":BACKTYPE,
                           @"xid":XID,
                           @"user_id":USER_ID,
                           @"user_type":USER_TYPE,
                           @"course_id":courseId,
                           };
    
    // 服务器返回的数据格式
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer]; // 二进制数据
    [mgr POST:urlStr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
//         NSLog(@"====getSubjectInfo===%@",dict);
         if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] ){
             
             //1代表收藏过, 2代表未收藏
             if([[NSString stringWithFormat:@"%@",dict[@"data"][@"cheeck_collect"]] isEqualToString:@"1"]){
                 UIButton*rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,22,22)];
                 [rightButton setImage:[UIImage imageNamed:@"commentInfo10.png"]forState:UIControlStateNormal];
                 [rightButton addTarget:self action:@selector(collectbtn:)forControlEvents:UIControlEventTouchUpInside];
                 UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
                 self.navigationItem.rightBarButtonItem= rightItem;
                 isCollect=YES;
                 
                 
             }else if([[NSString stringWithFormat:@"%@",dict[@"data"][@"cheeck_collect"]] isEqualToString:@"2"]){
                 UIButton*rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,22,22)];
                 [rightButton setImage:[UIImage imageNamed:@"commentInfo9.png"]forState:UIControlStateNormal];
                 [rightButton addTarget:self action:@selector(collectbtn:)forControlEvents:UIControlEventTouchUpInside];
                 UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
                 self.navigationItem.rightBarButtonItem= rightItem;
                 isCollect=NO;
                 
             }
             //课程名称
            course_name = dict[@"data"][@"course_name"];
             self.title = course_name;
             //老师名字
             NSString * tname = [NSString stringWithFormat:@"%@",[dict[@"data"][@"teacher_tname"][0] objectForKey:@"tname"]];
             //机构
             NSString * school_name = [NSString stringWithFormat:@"%@",dict[@"data"][@"school_name"]];
             //浏览
             NSString * read_num = [NSString stringWithFormat:@"%@次",dict[@"data"][@"read_num"]];
             //收藏
             NSString * collect_num = [NSString stringWithFormat:@"%@次",dict[@"data"][@"collect_num"]];
             //招生人数
             NSString * need_num =[NSString stringWithFormat:@"%@",dict[@"data"][@"need_num"]];
             //适用人群
             NSString * age =[NSString stringWithFormat:@"%@岁到%@岁",dict[@"data"][@"age_up"],dict[@"data"][@"age_down"]];
             //教学目标
             NSString * teach_goal = [NSString stringWithFormat:@"%@",dict[@"data"][@"teach_goal"]];
             //上课时间
             NSString * course_time_str = [NSString stringWithFormat:@"%@",dict[@"data"][@"course_time_str"]];
             //上课地址
             NSString *  address = [NSString stringWithFormat:@"%@",dict[@"data"][@"address"]];
             //插班规则
             NSString * middle_in_rule =[NSString stringWithFormat:@"%@",dict[@"data"][@"middle_in_rule"]];
             //退班规则
             NSString * quit_rule = [NSString stringWithFormat:@"%@",dict[@"data"][@"quit_rule"]];
             //原价
             NSString * original_price = [NSString stringWithFormat:@"%@元",dict[@"data"][@"original_price"]];
             //现价
             NSString * now_price = [NSString stringWithFormat:@"%@元",dict[@"data"][@"now_price"]];
             //课程详情
             details = [NSString stringWithFormat:@"%@",dict[@"data"][@"details"]];
             //课程ID
    
             //课程详情图片
             picGroup = dict[@"data"][@"course_pic_group"];
             detailedLabelArr = [[NSMutableArray alloc] initWithObjects:tname,school_name,read_num,collect_num,need_num,age,teach_goal,course_time_str,address,middle_in_rule,quit_rule,original_price,now_price,nil];
             
             [self scrollViewUI];
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"请求失败:%@",error);
         [SVProgressHUD showErrorWithStatus:@"网络不通，请检查网络！"];
         
     }];
}



-(void)scrollViewUI{
    NSMutableArray *nameLabelArr = [[NSMutableArray alloc] initWithObjects:@"授课老师:",@"机构名称:",@"浏览次数:",@"收藏次数:",@"招生人数:",@"适用人群:",@"教学目标:",@"上课时间:",@"上课地址:",@"插班规则:",@"退班规则:",@"原       价:",@"现       价:",nil];
    
    //背景
    bgScrollView = [[UIScrollView alloc] init];
    bgScrollView.frame = CGRectMake(0, 0, kWidth,kHeight + 64 + 49);
    bgScrollView.backgroundColor = [UIColor whiteColor];
    bgScrollView.pagingEnabled = NO;
    bgScrollView.showsHorizontalScrollIndicator = YES;
    bgScrollView.showsVerticalScrollIndicator  = YES;
    bgScrollView.alwaysBounceVertical = YES;
    [self.view addSubview:bgScrollView];
    
    for (int i = 0; i < nameLabelArr.count; i ++) {
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(KLabelX, KLabelH * i + Kmarg , KLabelW, KLabelH)];
        nameLabel.font = [UIFont systemFontOfSize:14];
        nameLabel.textAlignment = NSTextAlignmentRight;
        nameLabel.text = nameLabelArr[i];
        [bgScrollView addSubview:nameLabel];
        if (i == 7) {
            UITextView *detailedText = [[UITextView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(nameLabel.frame) + Kmarg, KLabelH * 7 + Kmarg , kWidth - CGRectGetMaxX(nameLabel.frame) - KLabelH , 25)];
            detailedText.text = detailedLabelArr[7];
            detailedText.font = [UIFont systemFontOfSize:12];
            detailedText.userInteractionEnabled = YES;
            detailedText.editable = NO;
            detailedText.textColor = [UIColor grayColor];
            [bgScrollView addSubview:detailedText];
        }else{
            UITextField *detailedText = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(nameLabel.frame) + Kmarg, KLabelH * i + Kmarg, kWidth - CGRectGetMaxX(nameLabel.frame) - KLabelH , KLabelH)];
            detailedText.text = detailedLabelArr[i];
            detailedText.borderStyle = UITextBorderStyleNone;
            detailedText.font = [UIFont systemFontOfSize:12];
            detailedText.userInteractionEnabled = NO;
            detailedText.textColor = [UIColor grayColor];
            [bgScrollView addSubview:detailedText];
            
            //判断是否允许插班 退班
            if (i == 9) {
                if ([detailedLabelArr[9] isEqualToString:@"1"]) {
                    detailedText.text = @"是";
                }else{
                    detailedText.text = @"否";
                }
            }
            if (i == 10) {
                if ([detailedLabelArr[10] isEqualToString:@"1"]) {
                    detailedText.text = @"是";
                }else{
                    detailedText.text = @"否";
                }
            }
        }
        UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(KLabelX, KLabelH * (i+1) + 12, kWidth - KLabelX * 2, 1)];
        line.backgroundColor = UIColorFromRGB(204, 204, 204);
        [bgScrollView addSubview:line];
    }
    
    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, KLabelH * 13 + 12, kWidth , 5)];
    lineView.backgroundColor = UIColorFromRGB(204, 204, 204);
    [bgScrollView addSubview:lineView];
    
    //课程说明
    
    UILabel *subjectSay = [HHControl createLabelWithFrame:CGRectMake(KLabelX, CGRectGetMaxY(lineView.frame) + KLabelX, KLabelW, KLabelH) Font:14 Text:@"课程说明:"];
    [bgScrollView addSubview:subjectSay];
    
    UILabel *xingMoneyLabel = [HHControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(subjectSay.frame) + Kmarg, CGRectGetMaxY(lineView.frame) + KLabelX, 150, KLabelH) Font:12 Text:@"(此课程可抵扣猩币上限1%)"];
    xingMoneyLabel.textColor = [UIColor grayColor];
    //    xingMoneyLabel.backgroundColor = [UIColor redColor];
    [bgScrollView addSubview:xingMoneyLabel];
    
    
    UITextView *subjectSayView = [[UITextView alloc] initWithFrame:CGRectMake(KLabelX, CGRectGetMaxY(subjectSay.frame) + Kmarg, kWidth - KLabelX *2, 120)];
    subjectSayView.text = details;
    subjectSayView.font = [UIFont systemFontOfSize:12];
    subjectSayView.userInteractionEnabled = NO;
    [subjectSayView flashScrollIndicators];   // 闪动滚动条
    //自动适应行高
    static CGFloat maxHeight = 130.0f;
    CGRect frame = subjectSayView.frame;
    CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
    CGSize size = [subjectSayView sizeThatFits:constraintSize];
    if (size.height >= maxHeight){
        size.height = maxHeight;
        subjectSayView.scrollEnabled = YES;   // 允许滚动
    }
    else{
        subjectSayView.scrollEnabled = NO;    // 不允许滚动，当textview的大小足以容纳它的text的时候，需要设置scrollEnabed为NO，否则会出现光标乱滚动的情况
    }
    subjectSayView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, size.height);
    [bgScrollView addSubview:subjectSayView];
    
    
//    NSLog(@"picGroup --  %@", picGroup);
    if (picGroup.count % 4 == 0) {
        picRow = picGroup.count / 4;
    }else{
        
        picRow = picGroup.count / 4 + 1;
    }
    //创建 十二宫格  三行、四列
    //              int totalLine = 4;
    //              int buttonCount = 12;
    int margin = 5;
    
    
    CGFloat picWidth = (kWidth - 5 * margin) / 4;
    CGFloat picHeight = picWidth;
    
    for (int i = 0; i < picGroup.count; i++) {
        
        //行
        int buttonRow = i / 4;
        
        //列
        int buttonLine = i % 4;
        
        CGFloat buttonX =  KLabelX + (picWidth + margin) * buttonLine;
        CGFloat buttonY = CGRectGetMaxY(subjectSayView.frame) + Kmarg + (picHeight + margin) * buttonRow;
        
        UIImageView *pictureImageView = [[UIImageView alloc] initWithFrame:CGRectMake(buttonX, buttonY, picWidth, picHeight)];
        
        [pictureImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", picURL, picGroup[i]]]];
        pictureImageView.tag = 20 + i;
        pictureImageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickPicture:)];
        [pictureImageView addGestureRecognizer:tap];
        
        [bgScrollView addSubview:pictureImageView];
        
    }
    
    
    CGFloat maxH =  CGRectGetMaxY(scrollView.frame) + 1000;
    bgScrollView.contentSize = CGSizeMake(0, maxH);
    
    //创建底部button
    [self butttomBtn];
    
}


- (void)onClickPicture:(UITapGestureRecognizer *)tap{
    
    RedFlowerViewController *redFlowerVC =[[RedFlowerViewController alloc]init];
    NSMutableArray *imageArr = picGroup;
    redFlowerVC.index = tap.view.tag - 20;
    redFlowerVC.imageArr = imageArr;
    //举报 来源 3:猩课堂发布的课程图片
    redFlowerVC.origin_pageStr = @"3";
    redFlowerVC.hidesBottomBarWhenPushed = YES;
    
    
    [self.navigationController pushViewController:redFlowerVC animated:YES];
    
}

-(void)butttomBtn {
    UIView *underButton = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 50, kWidth, 50)];
    [self.view addSubview:underButton];
    [self.view bringSubviewToFront:underButton];
    
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 1)];
    line.backgroundColor = UIColorFromRGB(239, 232, 233);
    [underButton addSubview:line];
    //咨询按钮
    UIButton *talkBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 1, kWidth/3, kUnderButtonH)];
    [talkBtn setImage:[UIImage imageNamed:@"咨询48x48@2x.png"] forState:UIControlStateNormal];
    [talkBtn setImage:[UIImage imageNamed:@"咨询(H)48x48@2x.png"] forState:UIControlStateHighlighted];
    talkBtn.imageEdgeInsets = UIEdgeInsetsMake(5,(kWidth/3 - 24)/2,30,(kWidth/3 - 24)/2);
    talkBtn.imageView.frame = CGRectMake(0, 0, 24, 24);
    [talkBtn setTitle:@"咨询" forState:UIControlStateNormal];
    [talkBtn setTitleColor:UIColorFromRGB(159,159,159) forState:UIControlStateNormal];
    [talkBtn setTitleColor:UIColorFromRGB(0,172,54) forState:UIControlStateHighlighted];
    talkBtn.titleEdgeInsets = UIEdgeInsetsMake(20, - talkBtn.titleLabel.bounds.size.width - 25, 0, 0);
    talkBtn.backgroundColor =[UIColor whiteColor];
    talkBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    [talkBtn addTarget:self action:@selector(clickchatBtn:) forControlEvents:UIControlEventTouchUpInside];
    [underButton addSubview:talkBtn];
    
    //分享按钮
    UIButton *shareBtn= [[UIButton alloc]initWithFrame:CGRectMake(kWidth/3, 1, kWidth/3, kUnderButtonH)];
    [shareBtn setImage:[UIImage imageNamed:@"分享icon48x48@2x.png"] forState:UIControlStateNormal];
    [shareBtn setImage:[UIImage imageNamed:@"分享(H)icon48x48@2x.png"] forState:UIControlStateHighlighted];
    shareBtn.imageEdgeInsets = UIEdgeInsetsMake(5,(kWidth/3 - 24)/2,30,(kWidth/3 - 24)/2);
    shareBtn.imageView.frame = CGRectMake(0, 0, 24, 24);
    [shareBtn setTitle:@"分享" forState:UIControlStateNormal];
    [shareBtn setTitleColor:UIColorFromRGB(159,159,159) forState:UIControlStateNormal];
    [shareBtn setTitleColor:UIColorFromRGB(0,172,54) forState:UIControlStateHighlighted];
    shareBtn.titleEdgeInsets = UIEdgeInsetsMake(20, -shareBtn.titleLabel.bounds.size.width - 25, 0, 0);
    shareBtn.backgroundColor = [UIColor whiteColor];
    shareBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    [shareBtn addTarget:self action:@selector(clickShareBtn:) forControlEvents:UIControlEventTouchUpInside];
    [underButton addSubview:shareBtn];
    
    //购买按钮
    _buyBtn = [[UIButton alloc]initWithFrame:CGRectMake(kWidth/3 * 2,1,kWidth/3, kUnderButtonH)];
    [_buyBtn  setImage:[UIImage imageNamed:@"购买48x48@2x.png"] forState:UIControlStateNormal];
    [_buyBtn setImage:[UIImage imageNamed:@"购买(H)48x48@2x.png"] forState:UIControlStateHighlighted];
    _buyBtn.imageEdgeInsets = UIEdgeInsetsMake(5,(kWidth/3 - 24)/2,30,(kWidth/3 - 24)/2);
    _buyBtn.imageView.frame = CGRectMake(0, 0, 24, 24);
    [_buyBtn setTitle:@"购买" forState:UIControlStateNormal];
    [_buyBtn  setTitleColor:UIColorFromRGB(159,159,159) forState:UIControlStateNormal];
    [_buyBtn setTitleColor:UIColorFromRGB(0,172,54) forState:UIControlStateHighlighted];
    _buyBtn.titleEdgeInsets = UIEdgeInsetsMake(20, -_buyBtn.titleLabel.bounds.size.width - 20, 0, 0);
    _buyBtn.backgroundColor =[UIColor whiteColor];
    _buyBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    [_buyBtn  addTarget:self action:@selector(clickBuyBtn:) forControlEvents:UIControlEventTouchUpInside];
    [underButton addSubview:_buyBtn ];
    
    //间隔线
    for (NSUInteger i = 1; i < 3; i++) {
        UIImageView *line=[HHControl createImageViewFrame:CGRectMake(i* kWidth/3 + 2,10, 1, 30) imageName:nil color:[UIColor colorWithRed:180/255.0f green:180/255.0f blue:180/255.0f alpha:.3]];
        [underButton addSubview:line];
        
    }
}

//发起聊天
- (void)clickchatBtn:(UIButton*)btn{
//    NSLog(@"聊聊");
    
    NSString * userId = [XXEUserInfo user].user_id;
    
    NSString * userNickName = [XXEUserInfo user].nickname;
    
    NSString * userPortraitUri = [XXEUserInfo user].user_head_img;
    
    RCUserInfo *_currentUserInfo =
    [[RCUserInfo alloc] initWithUserId:userId
                                  name:userNickName
                              portrait:userPortraitUri];
    [RCIM sharedRCIM].currentUserInfo = _currentUserInfo;
    
    
    
    WMConversationViewController *chatPrivateVC = [[WMConversationViewController alloc]init];

    chatPrivateVC.conversationType = ConversationType_PRIVATE;
    chatPrivateVC.targetId = @"18886064";
    chatPrivateVC.title = @"想要显示的会话标题";
    
    
    [self.navigationController pushViewController:chatPrivateVC animated:YES];
}

// 购买
- (void)clickBuyBtn:(UIButton*)btn{
    
    
    [self getSubjectBuyInfo];
   
}


-(void)getSubjectBuyInfo{
    
    infoArray = [NSMutableArray array];
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/xkt_confirm_course_order";
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *dict = @{@"appkey":APPKEY,
                           @"backtype":BACKTYPE,
                           @"xid":XID,
                           @"user_id":USER_ID,
                           @"user_type":USER_TYPE,
                           @"course_id":_courseId,
                           };
    
    // 服务器返回的数据格式
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer]; // 二进制数据
    [mgr POST:urlStr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
//         NSLog(@"===========dic==========%@",dict);
         if([[NSString stringWithFormat:@"%@",dict[@"code"]] isEqualToString:@"1"] ){
             
             //单个课程现价
             NSString * now_price = [NSString stringWithFormat:@"%@", dict[@"data"][@"now_price"]];
             //0:不允许猩币抵扣  1:允许猩币抵扣
             NSString * coin = [NSString stringWithFormat:@"%@", dict[@"data"][@"coin"]];
             //猩币抵扣率,  抵扣金额=猩币数*抵扣率
             NSString * coin_deduct_per = [NSString stringWithFormat:@"%@", dict[@"data"][@"coin_deduct_per"]];
             //猩币抵金额上限率, 金额上限=合计金额*金额上限率
             NSString * coin_deduct_per_limit = [NSString stringWithFormat:@"%@", dict[@"data"][@"coin_deduct_per_limit"]];
             //用户可用猩币(用户输入的猩币不能超过可用猩币)
             NSString * coin_able = [NSString stringWithFormat:@"%@", dict[@"data"][@"coin_able"]];
             
             infoArray = [NSMutableArray arrayWithObjects:now_price,coin,coin_deduct_per,coin_deduct_per_limit,coin_able, nil];
             
             SubjectBuyViewController *subjectBuyVC = [[SubjectBuyViewController alloc] init];
             subjectBuyVC.course_name = course_name;
             subjectBuyVC.dataArr = detailedLabelArr;
             subjectBuyVC.course_Id = self.courseId;
             subjectBuyVC.infoData = infoArray;
             [self.navigationController pushViewController:subjectBuyVC animated:YES];
             
             
         }else{
             
             [SVProgressHUD showErrorWithStatus:@"人数已满,无法报名"];
             _buyBtn.userInteractionEnabled = NO;
             
         }
         
        
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"请求失败:%@",error);
         [SVProgressHUD showErrorWithStatus:@"网络不通，请检查网络！"];
         
     }];
}
//分享功能
- (void)clickShareBtn:(UIButton*)btn{
    [CoreUmengShare show:self text:@"为了孩子的未来,这里有你想要的一切,快点点击下载吧！https://itunes.apple.com/cn/app/jie-dian-qian-zhuan-ye-ban/id1112373854?mt=8&v0=WWW-GCCN-ITSTOP100-FREEAPPS&l=&ign-mpt=uo%3D4" image:[UIImage imageNamed:@"猩猩教室.png"] ];
    
}
//收藏点击事件
-(void)collectbtn:(UIButton *)btn{
    
    if (isCollect== NO) {
        [self collectArticle];
    }
    else  if (isCollect== YES) {
        [self deleteCollectArticle];
    }
}


//收藏课程
- (void)collectArticle
{
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/collect";
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *dict = @{@"appkey":APPKEY,
                           @"backtype":BACKTYPE,
                           @"xid":XID,
                           @"user_id":USER_ID,
                           @"user_type":USER_TYPE,
                           @"collect_id":self.courseId,
                           @"collect_type":@"4",
                           
                           };
    //        NSLog(@"======================>%@",dict);
    
    // 服务器返回的数据格式
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer]; // 二进制数据
    [mgr POST:urlStr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
//                   NSLog(@"======================>%@",responseObject);
         
         if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] )
         {
             
             [SVProgressHUD showSuccessWithStatus:@"收藏课程成功"];
             UIButton*rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,22,22)];
             [rightButton setBackgroundImage:[UIImage imageNamed:@"commentInfo10.png"] forState:UIControlStateNormal];
             UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
             self.navigationItem.rightBarButtonItem= rightItem;
             [rightButton addTarget:self action:@selector(collectbtn:)forControlEvents:UIControlEventTouchUpInside];
             isCollect=!isCollect;
             
         }
         
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"请求失败:%@",error);
         [SVProgressHUD showErrorWithStatus:@"网络不通，请检查网络！"];
         
     }];
}

//取消收藏课程
- (void)deleteCollectArticle
{
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/deleteCollect";
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *dict = @{@"appkey":APPKEY,
                           @"backtype":BACKTYPE,
                           @"xid":XID,
                           @"user_id":USER_ID,
                           @"user_type":USER_TYPE,
                           @"collect_id":self.courseId,
                           @"collect_type":@"4",
                           
                           };
    //    NSLog(@"%@",dict);
    
    // 服务器返回的数据格式
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer]; // 二进制数据
    [mgr POST:urlStr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         
         if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] ){
             [SVProgressHUD showSuccessWithStatus:@"取消收藏成功"];
             UIButton*rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,22,22)];
             [rightButton setBackgroundImage:[UIImage imageNamed:@"commentInfo9.png"] forState:UIControlStateNormal];
             UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
             self.navigationItem.rightBarButtonItem= rightItem;
             [rightButton addTarget:self action:@selector(collectbtn:)forControlEvents:UIControlEventTouchUpInside];
             isCollect=!isCollect;
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         //         NSLog(@"请求失败:%@",error);
         [SVProgressHUD showErrorWithStatus:@"网络不通，请检查网络！"];
         
     }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Umeng delegate
- (void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response {
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        [SVProgressHUD showInfoWithStatus:@"分享成功"];
    } else {
        [SVProgressHUD showInfoWithStatus:@"分享失败"];
    }
}


@end
