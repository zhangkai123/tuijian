//
//  TJItemCell.m
//  Tuijian
//
//  Created by zhang kai on 3/13/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import "TJItemCell.h"

@implementation TJItemCell
@synthesize itemId ,theRowNum;
@synthesize userImageView ,nameLabel ,genderImageView;
@synthesize itemImageView ,commentNumLabel ,likeNumLabel;
@synthesize delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = UIColorFromRGB(0xEDEDED);
        
        coverView = [[UIView alloc]initWithFrame:CGRectZero];
        coverView.backgroundColor = UIColorFromRGB(0xF2F2F2);
        [self addSubview:coverView];
        
        userImageView = [[TJTouchableImageView alloc]initWithFrame:CGRectMake(10, 5, 40, 40)];
        userImageView.delegate = self;
        [self addSubview:userImageView];
        nameLabel = [[TJSelectableLabel alloc]initWithFrameAndTextColor:CGRectMake(60, 10, 150, 20) andTextColor:UIColorFromRGB(0x336699)];
        nameLabel.delegate = (id)self;
        [nameLabel setFont:[UIFont systemFontOfSize:12]];
        [self addSubview:nameLabel];
        genderImageView = [[UIImageView alloc]initWithFrame:CGRectMake(60, 30, 13, 13)];
        [self addSubview:genderImageView];
        userImageView.backgroundColor = [UIColor clearColor];
        nameLabel.backgroundColor = [UIColor clearColor];
        genderImageView.backgroundColor = [UIColor clearColor];
        
        recommendInfoLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, TJ_RECOMMEND_WIDTH, 0)];
        [recommendInfoLabel setFont:[UIFont systemFontOfSize:TJ_RECOMMEND_SIZE]];
        recommendInfoLabel.lineBreakMode = NSLineBreakByCharWrapping;
        recommendInfoLabel.numberOfLines = 0;
        [recommendInfoLabel setTextColor:[UIColor blackColor]];
        [self addSubview:recommendInfoLabel];
        
        itemImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 320)];
        itemImageView.backgroundColor = UIColorFromRGB(0xF5F5F5);
        [self addSubview:itemImageView];
        
        likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [likeButton setFrame:CGRectMake(0, 0, 60, 28)];
        likeButton.layer.cornerRadius = 3;
        [likeButton setClipsToBounds:YES];
        likeButton.backgroundColor = UIColorFromRGB(0xE0E0E0);
        [likeButton setImage:[UIImage imageNamed:@"favhighlight@2x.png"] forState:UIControlStateNormal];
        [likeButton setTitle:@"赞" forState:UIControlStateNormal];
        [likeButton.titleLabel setFont:[UIFont systemFontOfSize:14.f]];
        [likeButton setTitleColor:UIColorFromRGB(0xA1A1A1) forState:UIControlStateNormal];
        likeButton.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        [likeButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
        [likeButton addTarget:self action:@selector(like) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:likeButton];
        
        likeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 32, 32)];
        likeImageView.image = [UIImage imageNamed:@"like.png"];
        [self addSubview:likeImageView];
        
        likeNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 32, 32)];
        [likeNumLabel setFont:[UIFont systemFontOfSize:8]];
        likeNumLabel.textAlignment = NSTextAlignmentCenter;
        likeNumLabel.textColor = [UIColor redColor];
        [likeImageView addSubview:likeNumLabel];
        
        commentImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 28, 28)];
        commentImageView.image = [UIImage imageNamed:@"comment.png"];
        [self addSubview:commentImageView];
        
        commentNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, -1, 28, 28)];
        [commentNumLabel setFont:[UIFont systemFontOfSize:8]];
        commentNumLabel.textAlignment = NSTextAlignmentCenter;
        commentNumLabel.textColor = [UIColor redColor];
        [commentImageView addSubview:commentNumLabel];
    }
    return self;
}
-(void)setRecommendInfoAndHeight:(NSString *)recommendInfo textHeight:(float)textH
{
    recommendInfoLabel.text = recommendInfo;
    recommendInfoLabel.frame = CGRectMake(60, 50, TJ_RECOMMEND_WIDTH, textH);
    
    itemImageView.frame = CGRectMake(60, 50 + textH + 10, 150, 150);
    
    likeButton.frame = CGRectMake(10, 170 + textH + 1 + 50, 60, 28);
    likeImageView.frame = CGRectMake(240, 170 + textH + 50, 32, 32);
    commentImageView.frame = CGRectMake(240 + 32 + 5, 170 + textH + 2 + 50, 28, 28);
    
    coverView.frame = CGRectMake(0, 0, 320, textH + 260);
}
#pragma TJTouchableImageViewDelegate
-(void)selectUserImageView:(int)sectionNum
{
    [self.delegate goToUserInformationPgae:self.theRowNum];
}
#pragma TJSelectableLabelDelegate
-(void)selectLabel:(int)rowNum
{
    [self.delegate goToUserInformationPgae:self.theRowNum];
}

-(void)like
{
    [self.delegate likeItem:self.itemId liked:^(BOOL hasLiked){
        [self setLikeButtonColor:hasLiked];
        if (hasLiked) {
            likeButton.userInteractionEnabled = NO;
            [self animateHeart];
        }else{
            if ([likeNumLabel.text intValue] - 1 < 0) {
                return;
            }
            likeNumLabel.text = [NSString stringWithFormat:@"%d",[likeNumLabel.text intValue] - 1];
        }
    }];
}
-(void)setLikeButtonColor:(BOOL)hasLiked
{
    if (hasLiked) {
        likeButton.backgroundColor = UIColorFromRGB(0x9C9C9C);
        [likeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [likeButton setImage:[UIImage imageNamed:@"favSelectedHighlight@2x.png"] forState:UIControlStateNormal];
    }else{
        likeButton.backgroundColor = UIColorFromRGB(0xE0E0E0);
        [likeButton setTitleColor:UIColorFromRGB(0xA1A1A1) forState:UIControlStateNormal];
        [likeButton setImage:[UIImage imageNamed:@"favhighlight@2x.png"] forState:UIControlStateNormal];
    }
}
-(void)animateHeart
{
    CGPoint likeButtonPoint = CGPointMake(likeButton.frame.origin.x, likeButton.frame.origin.y);
    CGPoint likeViewPoint = likeImageView.center;
    heartLayer = [CALayer layer];
    heartLayer.backgroundColor = [[UIColor clearColor] CGColor];
    heartLayer.anchorPoint = CGPointMake(0., 1.);
    heartLayer.bounds = CGRectMake(0., 0., 40., 30.);
    heartLayer.position = CGPointMake(-100, 0);
    heartLayer.contents = (id)[[UIImage imageNamed:@"favSelectedHighlight@2x.png"] CGImage];
    heartLayer.contentsGravity = kCAGravityResizeAspect;
    [self.layer addSublayer:heartLayer];
    
    [heartLayer removeAnimationForKey:@"marioJump"];
    
    CGMutablePathRef jumpPath = CGPathCreateMutable();
    CGPathMoveToPoint(jumpPath, NULL, likeButtonPoint.x, likeButtonPoint.y + 10);
    CGPathAddCurveToPoint(jumpPath, NULL, likeButtonPoint.x + 50, likeButtonPoint.y - 20, likeButtonPoint.x + 200, likeButtonPoint.y - 60, likeViewPoint.x - 18, likeViewPoint.y + 8);
    
    CAKeyframeAnimation *jumpAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    jumpAnimation.path = jumpPath;
    jumpAnimation.duration = 0.7;
    jumpAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    jumpAnimation.delegate = self;
    
    CGPathRelease(jumpPath);
    
    [heartLayer addAnimation:jumpAnimation forKey:@"marioJump"];

}
#pragma mark Animation delegate methods

- (void)animationDidStart:(CAAnimation *)theAnimation {
    [CATransaction begin];
    {
        [CATransaction setDisableActions:YES];
    }
    [CATransaction commit];
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)finished {
    likeNumLabel.text = [NSString stringWithFormat:@"%d",[likeNumLabel.text intValue] + 1];
    [heartLayer removeFromSuperlayer];
    likeButton.userInteractionEnabled = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
