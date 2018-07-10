//
//  DownloadManager.h
//  MeteoDownload
//
//  Created by Albertomac on 29/01/14.
//  Copyright (c) 2014 Albertomac. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AMSessionManagerDelegate <NSObject>

@required
- (void)sessionManagerRecivedData:(NSData *)data;

@end


@interface AMSessionManager : NSObject <NSURLSessionDelegate, NSURLSessionDownloadDelegate>

@property (nonatomic, weak) id <AMSessionManagerDelegate> _delegate;
@property NSURLSession *_session;
@property NSURLSessionConfiguration *_configuration;

- (id)initWithDelegate:(id)delegate timeoutInterval:(NSTimeInterval)interval;
- (void)downloadFromUrlString:(NSString *)urlString;
- (void)downloadFromUrl:(NSURL *)url;

@end
