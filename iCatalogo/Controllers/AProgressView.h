//
//  AProgressView.h
//  iCatalogo
//
//  Created by Albertomac on 20/12/13.
//  Copyright (c) 2013 Albertomac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@protocol AProgressViewDelegate <NSObject>
@required
- (void)progressviewDidFailDownload;
- (void)progressViewDidSaveFile;
@end


@interface AProgressView : UIProgressView <NSURLConnectionDataDelegate>

@property (nonatomic, weak) id <AProgressViewDelegate> delegate;
@property (nonatomic, strong) UILabel *label;

@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSMutableData *receivedData;
@property (nonatomic, strong) NSOutputStream * stream;
@property (nonatomic, assign) long long current;
@property (nonatomic, assign) long long max;

- (void)reset;
- (void)increment:(long)value;
- (void)updateProgress;
- (void)updateText:(NSString *)text;
- (void)startDownloadFromUrl:(NSString *)string timeInterval:(NSTimeInterval)interval;
- (void)startDownloadWithRequest:(NSMutableURLRequest *)request timeoutInterval:(NSTimeInterval)interval;

@end


