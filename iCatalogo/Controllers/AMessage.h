//
//  AMessage.h
//  iCatalogo
//
//  Created by Albertomac on 03/12/13.
//  Copyright (c) 2013 Albertomac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AMessage : UIView


@property (nonatomic, weak) UIViewController *delegate;
@property (nonatomic, assign) NSTimeInterval delay;
@property (nonatomic, assign) BOOL comeBack;

- (id)initWithMessage:(NSString *)message dismissWithin:(NSTimeInterval)interval delegate:(UIViewController *)del comeBack:(BOOL)back;
- (void)show;

@end
