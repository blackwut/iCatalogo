//
//  AMessage.m
//  iCatalogo
//
//  Created by Albertomac on 03/12/13.
//  Copyright (c) 2013 Albertomac. All rights reserved.
//

#import "AMessage.h"

@implementation AMessage

@synthesize delegate, delay, comeBack;


static const float padding = 20.0f;
static const float opacity = 0.8f;
static const float cornerRadius = 10.0f;
static const CGSize offset = {4.0f, 4.0f};

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithMessage:(NSString *)message dismissWithin:(NSTimeInterval)interval delegate:(UIViewController *)del comeBack:(BOOL)back
{
    self.delegate = del;
    self.delay = interval;
    self.comeBack = back;
    
    //Crea le misure da utilizzare
    CGSize size = [message sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0f]}];
    float width = 2*padding + size.width;
    float height = 2*padding + size.height;
    float x = (delegate.view.bounds.size.width-width)/2;
    float y = (delegate.view.bounds.size.height-height)/2;
    
    //Crea la label
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(padding, padding, size.width, size.height)];
    [label setText:message];
    [label setTextColor:[UIColor whiteColor]];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setAlpha:1.0];
    
    //Crea l'oggetto
    CGRect rect = CGRectMake(x, y, width, height);
    self = [super initWithFrame:rect];
    
    //Aggiunge la label
    [self addSubview:label];
    
    //Personalizza la view da visualizzare
    [self setBackgroundColor:[UIColor clearColor]];
    [self.layer setBackgroundColor:[UIColor blackColor].CGColor];
    [self.layer setOpacity:0.0];
    [self.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.layer setShadowOffset:offset];
    [self.layer setShadowOpacity:opacity];
    [self.layer setCornerRadius:cornerRadius];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close)];
    [tap setNumberOfTapsRequired:1];
    
    [self setUserInteractionEnabled:YES];
    [self addGestureRecognizer:tap];
    
    return self;
}

- (void)addToSuperView
{
    if(comeBack)
        [self.delegate.parentViewController.view addSubview:self];
    else [self.delegate.view addSubview:self];
    
    [self.delegate.view endEditing:YES];
}

- (void)show
{
    [self addToSuperView];
    
    [UIView animateWithDuration:0.25f
                          delay:0.0
                        options:(UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState)
                     animations:^{
                         [self.layer setOpacity:0.8f];
                     } completion:^(BOOL finished) {
                         [self performSelector:@selector(close) withObject:nil afterDelay:delay];
                     }];
}

- (void)close
{
    [UIView animateWithDuration:0.25f
                          delay:0.0
                        options:(UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState)
                     animations:^{
                         [self.layer setOpacity:0.0f];
                     } completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];
}

@end