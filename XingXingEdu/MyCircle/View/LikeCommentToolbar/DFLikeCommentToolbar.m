//
//  DFLikeCommentToolbar.m
//  DFTimelineView
//
//  Created by keenteam on 16/2/1.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "DFLikeCommentToolbar.h"
#import "DFLineLikeItem.h"
#import "DFTextImageLineItem.h"
#import "DFBaseLineItem.h"
@interface DFLikeCommentToolbar()




@end


@implementation DFLikeCommentToolbar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initView];
    }
    return self;
}

-(void) initView
{
    
    self.userInteractionEnabled = YES;
    
    UIImage *image = [UIImage imageNamed:@"AlbumOperateMoreViewBkg"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) resizingMode:UIImageResizingModeStretch];
    self.image = image;
    
    CGFloat x, y, width, height;
    
    x=0;
    y=0;
    width = self.frame.size.width/2;
    height = self.frame.size.height;
    
    //点赞 评论toolbar
    _likeButton = [self getButton:CGRectMake(x, y, width, height) title:@"赞" image:@"AlbumLike"];
    [_likeButton addTarget:self action:@selector(onLike:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_likeButton];
    
    x = width;
    _commentButton = [self getButton:CGRectMake(x, y, width, height) title:@"评" image:@"AlbumComment"];
    [_commentButton addTarget:self action:@selector(onComment:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_commentButton];
    
    //分割线
    height = height -16;
    y = (self.frame.size.height - height)/2;
    width = 1;
    UIView *divider = [[UIView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    divider.backgroundColor = [UIColor whiteColor];
    [self addSubview:divider];
    
}

-(UIButton *) getButton:(CGRect) frame title:(NSString *) title image:(NSString *) image
{
    UIButton *btn = [[UIButton alloc] initWithFrame:frame];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 6, 0, 0)];
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    return btn;
}
//点赞
-(void) onLike:(UIButton *)shareBtn
{
  
    if (_likeButton.selected == NO) {
        shareBtn.selected = YES;
        _likeButton = shareBtn;
        [_likeButton setTitle:@"取消" forState:UIControlStateSelected];
        if (_delegate != nil && [_delegate respondsToSelector:@selector(onLike)]) {
            
            [_delegate onLike];
        }
    }
    else{
        shareBtn.selected=NO;
        _likeButton=shareBtn;
         [_likeButton setTitle:@"赞" forState:UIControlStateNormal];
        
        if (_delegate != nil && [_delegate respondsToSelector:@selector(onLike)]) {
            [_delegate onLike];
        }
    }
    
}

-(void) onComment:(id) sender{
    if (_delegate != nil && [_delegate respondsToSelector:@selector(onComment)]) {
        [_delegate onComment];
    }
}
@end
