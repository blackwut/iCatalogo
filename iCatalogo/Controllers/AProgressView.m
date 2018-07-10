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
@synthesize url, receivedData, current, max;


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if(self){
        [self reset];
    }
    return self;
}

- (void)reset
{
    self.receivedData = [[NSMutableData alloc] initWithCapacity:0];
    self.current = 0;
    self.max = 0;
    self.progress = 0;
}

- (void)increment
{
    [self incrementOf:1];
}

- (void)incrementOf:(long)increment
{
    self.current += increment;
    self.progress = (float)current/max;
}

- (void)updateAssociatedLabelWithText:(NSString *)text
{
    [label performSelectorInBackground:@selector(setText:) withObject:text];
}

- (void)startDownloadFromUrl:(NSString *)string timeInterval:(NSTimeInterval)interval
{
    //self.receivedData = [[NSMutableData alloc] initWithCapacity:0];
    [self updateAssociatedLabelWithText:@"Richiesta file..."];
    self.url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:interval];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
    [connection start];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [self updateAssociatedLabelWithText:@"Download..."];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    self.max = [response expectedContentLength];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [receivedData appendData:data];
    [self incrementOf:[data length]];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self updateAssociatedLabelWithText:@"Connessione fallita."];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [delegate progressviewDidFailDownload];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self updateAssociatedLabelWithText:@"Salvataggio file..."];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"update.zip"];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    [receivedData writeToFile:filePath atomically:YES];
    
    [delegate progressViewDidSaveFile];
}

@end
