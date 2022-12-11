//
//  AProgressView.m
//  iCatalogo
//
//  Created by Albertomac on 20/12/13.
//  Copyright (c) 2013 Albertomac. All rights reserved.
//

#import "AProgressView.h"
#import "ZipArchive.h"

@implementation AProgressView

@synthesize delegate, label;
@synthesize url, receivedData, stream, current, max;


- (void)reset
{
    self.current = 0;
    self.max = 1;
    [self my_updateProgress];
}

- (void)my_updateProgress
{
    float value = (float) self.current / self.max;
    [self setProgress:value animated:NO];
}

- (void)updateProgress
{
    [self performSelectorInBackground:@selector(my_updateProgress) withObject:nil];
}

- (void)updateText:(NSString *)text
{
    [self.label performSelectorInBackground:@selector(setText:) withObject:text];
}

- (void)increment:(long)value
{
    self.current += value;
    [self updateProgress];
}

- (void)startDownloadFromUrl:(NSString *)string timeInterval:(NSTimeInterval)interval
{
    [self updateText:@"Richiesta file..."];
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:string] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:interval];
    NSURLConnection * connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
    [connection start];
}

- (void)startDownloadWithRequest:(NSMutableURLRequest *)request timeoutInterval:(NSTimeInterval)interval
{
    [self updateText:@"Richiesta file..."];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
    [connection start];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self updateText:@"Download..."];
    self.current = 0;
    self.max = [response expectedContentLength];
    [self my_updateProgress];
    
    NSURL * updateURL = [[[AppDelegate sharedAppDelegate] applicationDocumentsDirectory] URLByAppendingPathComponent:@"update.zip"];
    self.stream = [[NSOutputStream alloc] initWithURL:updateURL append:NO];
    [self.stream open];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.stream write:[data bytes] maxLength:[data length]];
    [self increment:[data length]];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self updateText:@"Connessione fallita."];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [delegate progressviewDidFailDownload];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self updateText:@"Salvataggio file..."];
    [self.stream close];
    [delegate progressViewDidSaveFile];
}

@end
