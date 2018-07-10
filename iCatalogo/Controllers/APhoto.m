//
//  APhoto.m
//  iCatalogo
//
//  Created by Albertomac on 07/12/13.
//  Copyright (c) 2013 Albertomac. All rights reserved.
//

#import "APhoto.h"

@implementation APhoto

@synthesize delegate, imageView;

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

- (id)initWithImage:(UIImage *)image delegate:(UIViewController *)del
{
    self.delegate = del;
    
    //Crea le misure da utilizzare
    float width = delegate.view.bounds.size.width;
    float height = delegate.view.bounds.size.height;
    
    //float widthImage = 3 * image.size.width;
    //float heightImage = 3 * image.size.height;
    
    float widthImage = image.size.width * (height / image.size.height);
    float heightImage = height;
    
    float x = (width - widthImage)/2;
    float y = (height - heightImage)/2;
    
    
    //Crea la ImageView
    imageView = [[UIImageView alloc] initWithImage:image];
    //[imageView setBounds:CGRectMake(x, y, widthImage, heightImage)];
    [imageView setFrame:CGRectMake(x, y, widthImage, heightImage)];
    
    //Crea l'oggetto
    CGRect rect = CGRectMake(0, 0, width, height);
    self = [super initWithFrame:rect];
    
    //Aggiunge la label
    [self addSubview:imageView];
    
    //Personalizza la view da visualizzare
    [self setBackgroundColor:[UIColor clearColor]];
    [self.layer setBackgroundColor:[UIColor blackColor].CGColor];
    [self.layer setOpacity:0.0];
    
    return self;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[touches allObjects] objectAtIndex:0];
    CGPoint point = [touch locationInView:self];
    
    if(!CGRectContainsPoint(self.imageView.frame, point))
        [self close];
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
