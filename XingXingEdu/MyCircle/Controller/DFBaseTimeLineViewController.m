//
//  DFBaseTimeLineViewController.m
//  DFTimelineView
//
//  Created by keenteam on 16/2/1.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "DFBaseTimeLineViewController.h"
#import "MyHeadViewController.h"
#import "MessageListViewController.h"
#define TableHeaderHeight 290*([UIScreen mainScreen].bounds.size.width / 375.0)
#define CoverHeight 240*([UIScreen mainScreen].bounds.size.width / 375.0)
#define AvatarSize 70*([UIScreen mainScreen].bounds.size.width / 375.0)
#define AvatarRightMargin 15
#define AvatarPadding 2
#define NickFont [UIFont systemFontOfSize:20]
#define SignFont [UIFont systemFontOfSize:11]


@interface DFBaseTimeLineViewController(){
    UIButton *_messageBtn;
}

@property (nonatomic, strong) UIImageView *coverView;

@property (nonatomic, strong) UIImageView *userAvatarView;

@property (nonatomic, strong) MLLabel *userNickView;

@property (nonatomic, strong) MLLabel *userSignView;

@property (strong, nonatomic) UIRefreshControl *refreshControl;

@property (nonatomic, strong) UIView *footer;

@property (nonatomic, assign) BOOL isLoadingMore;

@end


@implementation DFBaseTimeLineViewController



- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _isLoadingMore = NO;
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor= [UIColor colorWithRed:229/255.0f green:232/255.0f blue:234/255.0f alpha:1];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.barTintColor =UIColorFromRGB(0, 170, 42);
  
    
    [self initTableView];
    
    [self initHeader];
    
    [self initFooter];
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    self.navigationController.navigationBar.barTintColor =UIColorFromRGB(0, 170, 42);
}
- (void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBar.barTintColor =UIColorFromRGB(0, 170, 42);
}

-(void) initTableView
{
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorInset = UIEdgeInsetsZero;
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        _tableView.layoutMargins = UIEdgeInsetsZero;
    }
    [self.view addSubview:_tableView];
}


-(void)createNewMessageView{

    //新消息
    _messageBtn =[HHControl createButtonWithFrame:CGRectMake(100, 140, 120, 30) backGruondImageName:nil Target:self Action:@selector(setBadgeValueNum) Title:@"你有新消息了"];
    _messageBtn.layer.cornerRadius = 8;
    _messageBtn.backgroundColor = UIColorFromRGB(229, 233, 232);
    _messageBtn.userInteractionEnabled = YES;
    _messageBtn.layer.masksToBounds = YES;
    _messageBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_coverView addSubview:_messageBtn];
    
}
- (void)setBadgeValueNum{
    
    MessageListViewController *messageListVC = [[MessageListViewController alloc] init];
     _messageBtn.hidden = YES;
    [self.navigationController pushViewController:messageListVC animated:YES];
    
    
}

-(void) initHeader
{
    CGFloat x,y,width, height;
    x=0;
    y=0;
    width = self.view.frame.size.width;
    height = TableHeaderHeight;
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    header.backgroundColor = [UIColor whiteColor];
    _tableView.tableHeaderView = header;
    
    //封面
    height = CoverHeight;
    _coverView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    _coverView.userInteractionEnabled = YES;
    _coverView.backgroundColor = [UIColor darkGrayColor];
    
    self.coverWidth  = width*2;
    self.coverHeight = height*2;
    [header addSubview:_coverView];
    
    //用户头像
    x = self.view.frame.size.width - AvatarRightMargin - AvatarSize;
    y = header.frame.size.height - AvatarSize - 20;
    width = AvatarSize;
    height = width;
    
    
    UIButton *avatarBg = [[UIButton alloc] initWithFrame:CGRectMake(x, y, width, height)];
    avatarBg.backgroundColor = [UIColor whiteColor];
    avatarBg.layer.borderWidth=0.5;
    avatarBg.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [avatarBg addTarget:self action:@selector(onClickUserAvatar:) forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:avatarBg];
    
    x = AvatarPadding;
    y = x;
    width = CGRectGetWidth(avatarBg.frame) - 2*AvatarPadding;
    height = width;
    _userAvatarView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    [avatarBg addSubview:_userAvatarView];
    self.userAvatarSize = width*2;
    
    //用户昵称
    if (_userNickView == nil) {
        _userNickView = [[MLLabel alloc] initWithFrame:CGRectZero];
        _userNickView.textColor = [UIColor whiteColor];
        _userNickView.font = NickFont;
        _userNickView.numberOfLines = 1;
        _userNickView.adjustsFontSizeToFitWidth = NO;
        [header addSubview:_userNickView];
    }
    //用户签名
    if (_userSignView== nil) {
        _userSignView = [[MLLabel alloc] initWithFrame:CGRectZero];
        _userSignView.textColor = [UIColor lightGrayColor];
        _userSignView.font = SignFont;
        _userSignView.numberOfLines = 1;
        _userSignView.adjustsFontSizeToFitWidth = NO;
        [header addSubview:_userSignView];
    }
    
    //下拉刷新
    if (_refreshControl == nil) {
        _refreshControl = [[UIRefreshControl alloc] init];
        [_refreshControl addTarget:self action:@selector(onPullDown:) forControlEvents:UIControlEventValueChanged];
        [_tableView addSubview:self.refreshControl];
    }
    
}

-(void) initFooter
{
    CGFloat x,y,width, height;
    x=0;
    y=0;
    width = self.view.frame.size.width;
    height = 0.1;
    
    _footer = [[UIView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    _footer.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = _footer;
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    indicator.center = CGPointMake(_footer.frame.size.width/2, 30);
    indicator.hidden = YES;
    [indicator startAnimating];
    
    [_footer addSubview:indicator];
    
    
}

#pragma mark - TableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}


#pragma mark - TabelViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"DFBaseTimeLineViewController.h ===========indexPath.section %ld,indexPath.row %ld",(long)indexPath.section,(long)indexPath.row);
    
}

#pragma mark - PullMoreFooterDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_isLoadingMore) {
        return;
    }
    if (scrollView.contentOffset.y+self.tableView.frame.size.height - 30 > scrollView.contentSize.height) {
        
        [self showFooter];
    }
}


-(void) showFooter
{
    
    CGRect frame = _tableView.tableFooterView.frame;
    CGFloat x,y,width,height;
    width = frame.size.width;
    height = 50;
    x = frame.origin.x;
    y = frame.origin.y;
    _footer.frame = CGRectMake(x, y, width, height);
    _tableView.tableFooterView = _footer;
    
    _isLoadingMore = YES;
    [self loadMore];
}

-(void) hideFooter
{
    
    [UIView animateWithDuration:0.5 animations:^{
        CGRect frame = _tableView.tableFooterView.frame;
        CGFloat x,y,width,height;
        width = frame.size.width;
        height = 0.1;
        x = frame.origin.x;
        y = frame.origin.y;
        _footer.frame = CGRectMake(x, y, width, height);
        _tableView.tableFooterView = _footer;
        
        _isLoadingMore = NO;
        
    }];
    
}


-(void) onPullDown:(id) sender
{
    [self refresh];
}


-(void) refresh
{
    [_tableView reloadData];

}

-(void) loadMore
{

    
}


-(void)endLoadMore
{
    [_tableView reloadData];
    [self hideFooter];
    
}

-(void)endRefresh
{
    [_tableView reloadData];
    [_refreshControl endRefreshing];
}

#pragma mark - Method
-(void)setCover:(NSString *)url
{
    [_coverView sd_setImageWithURL:[NSURL URLWithString:url]];
}

-(void)setUserAvatar:(NSString *)url
{
    [_userAvatarView sd_setImageWithURL:[NSURL URLWithString:url]];
}

-(void)setUserNick:(NSString *)nick
{
    CGFloat x, y, width, height;
    
    CGSize size = [MLLabel getViewSizeByString:nick font:NickFont];
    width = size.width;
    height = size.height;
    x = CGRectGetMinX(_userAvatarView.superview.frame) - width - 5;
    y = CGRectGetMidY(_userAvatarView.superview.frame) - height - 2;
    _userNickView.frame = CGRectMake(x, y, width, height);
    _userNickView.text = nick;
}


-(void)setUserSign:(NSString *)sign
{
    CGFloat x, y, width, height;
    
    CGSize size = [MLLabel getViewSizeByString:sign font:SignFont];
    width = size.width;
    height = size.height;
    x = CGRectGetWidth(self.view.frame) - width - 15;
    y = CGRectGetMaxY(_userAvatarView.superview.frame) + 5;
    _userSignView.frame = CGRectMake(x, y, width, height);
    _userSignView.text = sign;
}


-(void) onClickUserAvatar:(id) sender
{
    [self onClickHeaderUserAvatar];
}


-(void)onClickHeaderUserAvatar
{
    MyHeadViewController *myHeadVC =[[MyHeadViewController alloc]init];
    [self.navigationController pushViewController:myHeadVC animated:YES];
}

@end
