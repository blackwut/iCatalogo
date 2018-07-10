//
//  APhoto.h
//  iCatalogo
//
//  Created by Albertomac on 07/12/13.
//  Copyright (c) 2013 Albertomac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface APhoto : UIView

@property (nonatomic, weak) UIViewController *delegate;
@property (nonatomic, strong) UIImageView *imageView;

- (id)initWithImage:(UIImage *)image delegate:(UIViewController *)del;
- (void)show;
- (void)close;

@end
