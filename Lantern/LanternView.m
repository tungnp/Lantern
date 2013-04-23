//
//  LanternView.m
//  Lantern
//
//  Created by stevie nguyen on 4/22/13.
//  Copyright (c) 2013 tung nguyen. All rights reserved.
//

#import "LanternView.h"
#import <QuartzCore/QuartzCore.h>
#define IMAGES_NUMBER 12
#define IMAGE_WIDTH 320
#define IMAGE_DISTANCE 0

@interface LanternView(){
    UIScrollView*   _scrollView;
    NSMutableArray* _imageViewsArray;
    CGPoint _RightOffSet;
    CGPoint _LeftOffset;
    CGFloat _distance;
}@end

@implementation LanternView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (id) init{
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, 320, 480);
        float width = self.frame.size.width;
        float height = self.frame.size.height;
        self.backgroundColor = [UIColor blackColor];
        
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0,width, height)];
        _scrollView.delegate = self;
        [_scrollView setContentSize:CGSizeMake(2 * IMAGE_WIDTH * IMAGES_NUMBER, height)];
        [self doubleLoadImageViewToScrollView];
        _scrollView.contentOffset=CGPointMake(_distance, 0);
        [self addSubview:_scrollView];
        _LeftOffset = CGPointMake( IMAGE_WIDTH * IMAGES_NUMBER / 2 - IMAGE_DISTANCE, 0);
        _RightOffSet = CGPointMake( IMAGE_WIDTH * 3 * IMAGES_NUMBER / 2 - IMAGE_DISTANCE, 0);
        _distance = fabsf(_RightOffSet.x - _LeftOffset.x);
        
        _scrollView.contentOffset = CGPointMake(_distance, 0);
        NSLog(@"%f %f %f",_LeftOffset.x, _RightOffSet.x,_distance);
    }
    return self;
}
- (void) doubleLoadImageViewToScrollView{
    _imageViewsArray = [NSMutableArray new];
    for (int i = 0; i < IMAGES_NUMBER; i++) {
        UIImage* image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",i]];
        //UIImage* image = [UIImage imageNamed:[NSString stringWithFormat:@"%d",i]];
        UIImageView* imageView = [[UIImageView alloc]initWithImage:image];
        [_imageViewsArray addObject:imageView];
    }
    for (int i = 0; i < IMAGES_NUMBER; i++) {
        UIImage* image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",i]];
        //UIImage* image = [UIImage imageNamed:[NSString stringWithFormat:@"%d",i]];
        UIImageView* imageView = [[UIImageView alloc]initWithImage:image];
        [_imageViewsArray addObject:imageView];
    }

    float height = self.frame.size.height;
    for ( int i = 0; i < 2*IMAGES_NUMBER; i++ ) {
        UIImageView* imageView = _imageViewsArray[i];
        imageView.frame = CGRectMake(IMAGE_WIDTH * i + IMAGE_DISTANCE, 0, IMAGE_WIDTH, height);
        imageView.contentMode = UIViewContentModeScaleAspectFit;
                        
        [_scrollView addSubview:imageView];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(void)setAnchorPoint:(CGPoint)anchorPoint forView:(UIView *)view
{
    CGPoint newPoint = CGPointMake(view.bounds.size.width * anchorPoint.x, view.bounds.size.height * anchorPoint.y);
    CGPoint oldPoint = CGPointMake(view.bounds.size.width * view.layer.anchorPoint.x, view.bounds.size.height * view.layer.anchorPoint.y);
    
    newPoint = CGPointApplyAffineTransform(newPoint, view.transform);
    oldPoint = CGPointApplyAffineTransform(oldPoint, view.transform);
    
    CGPoint position = view.layer.position;
    
    position.x -= oldPoint.x;
    position.x += newPoint.x;
    
    position.y -= oldPoint.y;
    position.y += newPoint.y;
    
    view.layer.position = position;
    view.layer.anchorPoint = anchorPoint;
}
#pragma mark <UIScrollViewDelegate>
- (void) scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint currentOffset = scrollView.contentOffset;
    if (fabs(currentOffset.x - _LeftOffset.x) > _distance) {
        scrollView.contentOffset = CGPointMake(currentOffset.x - _distance, currentOffset.y);
        return;
    }
    else if (fabs(currentOffset.x - _RightOffSet.x) > _distance){
        scrollView.contentOffset = CGPointMake(currentOffset.x + _distance, currentOffset.y);
        return;
    }
    int index = ((int)(currentOffset.x - IMAGE_DISTANCE)) / IMAGE_WIDTH;
    float deviation = ((int)(currentOffset.x-IMAGE_DISTANCE)) % IMAGE_WIDTH;
    float angle = (deviation / IMAGE_WIDTH) * M_PI_2;
    
    UIImageView* imageView = (UIImageView*)_imageViewsArray[index];
    if (imageView.layer.anchorPoint.x != 1) {
        [self setAnchorPoint:CGPointMake(1, 0) forView:imageView];
    }
    imageView.layer.transform = CATransform3DMakeRotation(angle, 0, 1, 0);
    
    UIImageView* imageViewSecond = (UIImageView*)_imageViewsArray[index+1];
    if (imageViewSecond.layer.anchorPoint.x != 0) {
        [self setAnchorPoint:CGPointMake(0, 0) forView:imageViewSecond];
    }
    imageViewSecond.layer.transform = CATransform3DMakeRotation(M_PI_2 - angle, 0, -1, 0);
    NSLog(@"%f",currentOffset.x);
    
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    targetContentOffset->x = (((int)targetContentOffset->x)/IMAGE_WIDTH)*IMAGE_WIDTH;
}
@end
