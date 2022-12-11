//
//  APhoto.h
//  iCatalogo
//
//  Created by Albertomac on 07/12/13.
//  Copyright (c) 2013 Albertomac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface APhoto : UIView <UIScrollViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, weak) UIViewController *delegate;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;

- (instancetype)initWithImage:(UIImage *)image delegate:(UIViewController *)del NS_DESIGNATED_INITIALIZER;
- (void)show;
- (void)close;

@end
