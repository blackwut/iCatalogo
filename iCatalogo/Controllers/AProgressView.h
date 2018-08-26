//
//  AProgressView.h
//  iCatalogo
//
//  Created by Albertomac on 20/12/13.
//  Copyright (c) 2013 Albertomac. All rights reserved.
//

#import <UIKit/UIKit.h>

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
@property (nonatomic, assign) long long current;
@property (nonatomic, assign) long long max;

- (void)reset;
- (void)increment;
- (void)startDownloadFromUrl:(NSString *)string timeInterval:(NSTimeInterval)interval;

@end


