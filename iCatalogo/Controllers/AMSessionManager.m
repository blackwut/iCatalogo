//
//  DownloadManager.m
//  MeteoDownload
//
//  Created by Albertomac on 29/01/14.
//  Copyright (c) 2014 Albertomac. All rights reserved.
//

#import "AMSessionManager.h"

@implementation AMSessionManager

@synthesize _delegate, _session, _configuration;

- (instancetype)initWithDelegate:(id)delegate timeoutInterval:(NSTimeInterval)interval
{
    self = [super init];
    
    if(self){
        _delegate = delegate;
        
        _configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        [_configuration setAllowsCellularAccess:YES];
        _configuration.timeoutIntervalForRequest = interval;
        _configuration.timeoutIntervalForResource = interval;
        _configuration.HTTPMaximumConnectionsPerHost = 10;
        
        _session = [NSURLSession sessionWithConfiguration:_configuration delegate:self delegateQueue:nil];
        
    }
    return self;
}

- (void)downloadFromUrlString:(NSString *)urlString
{
    [self downloadFromUrl:[NSURL URLWithString:urlString]];
}

- (void)downloadFromUrl:(NSURL *)url
{
    //NSLog(@"Session Started");
    [[_session downloadTaskWithURL:url] resume];
}


- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    //NSLog(@"DidFinishDownloadingToUrl");
    [_delegate sessionManagerRecivedData:[NSData dataWithContentsOfURL:location]];
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    //NSLog(@"PercWritten %.2f", (float)totalBytesWritten/totalBytesExpectedToWrite);
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes
{
    //NSLog(@"DidResumeAtOffset");
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
   //NSLog(@"Error");
}

@end
