//
//  APhoto.m
//  iCatalogo
//
//  Created by Albertomac on 07/12/13.
//  Copyright (c) 2013 Albertomac. All rights reserved.
//

#import "APhoto.h"

@implementation APhoto

@synthesize delegate, scrollView, imageView;

- (id)initWithImage:(UIImage *)image delegate:(UIViewController *)delegate
{
    self.delegate = delegate;
        
    CGSize viewSize = CGSizeMake(delegate.view.bounds.size.width,
                                 delegate.view.bounds.size.height);
    CGSize scrollSize = CGSizeMake(image.size.width * (viewSize.height / image.size.height),
                                  viewSize.height);
    CGPoint scrollOrigin = CGPointMake((viewSize.width - scrollSize.width) / 2,
                                       (viewSize.height - scrollSize.height) / 2);
    
    CGRect imageRect = CGRectMake(0, 0, scrollSize.width, scrollSize.height);
    CGRect scrollRect = CGRectMake(scrollOrigin.x, scrollOrigin.y,
                                  scrollSize.width, scrollSize.height);
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:scrollRect];
    
    self.imageView = [[UIImageView alloc] initWithImage:image];
    [self.imageView setFrame:imageRect];
    
    [self.scrollView addSubview:imageView];
    [self.scrollView setContentSize:imageRect.size];
    [self.scrollView setDelegate:self];
    [self.scrollView setScrollEnabled:YES];
    [self.scrollView setMinimumZoomScale:1.0];
    [self.scrollView setMaximumZoomScale:3.0];
    [self.scrollView setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTwice:)];
    [doubleTap setNumberOfTapsRequired:2];
    [self.scrollView addGestureRecognizer:doubleTap];
        
    self = [super initWithFrame:CGRectMake(0, 0, viewSize.width, viewSize.height)];
    [self setBackgroundColor:[UIColor clearColor]];
    [self.layer setBackgroundColor:[UIColor blackColor].CGColor];
    [self.layer setOpacity:0.0];
    
    [self addSubview:self.scrollView];

    return self;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)tapTwice:(UITapGestureRecognizer *)gestureRecognizer
{
    if ([self.scrollView zoomScale] < 1.75) {
        [self.scrollView setZoomScale:[self.scrollView maximumZoomScale] animated:YES];
    } else {
        [self.scrollView setZoomScale:[self.scrollView minimumZoomScale] animated:YES];
    }
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch * touch = [[touches allObjects] objectAtIndex:0];
    CGPoint point = [touch locationInView:self];

    if(!CGRectContainsPoint(self.scrollView.frame, point)) {
        [self close];
    }
}

- (void)show
{
    [self.delegate.view addSubview:self];
    
    [UIView animateWithDuration:0.5f
                          delay:0.0
                        options:(UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState)
                     animations:^{
                         [self.layer setOpacity:1.0f];
                     } completion:^(BOOL finished) {
                     }];
}

- (void)close
{
    [UIView animateWithDuration:0.5f
                          delay:0.0
                        options:(UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState)
                     animations:^{
                         [self.layer setOpacity:0.0f];
                     } completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];
}

@end
