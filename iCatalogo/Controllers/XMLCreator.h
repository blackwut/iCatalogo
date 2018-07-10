//
//  XMLCreator.h
//  iCatalogo
//
//  Created by Albertomac on 23/12/13.
//  Copyright (c) 2013 Albertomac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@interface XMLCreator : NSObject

@property (nonatomic, strong) NSMutableString *content;

- (NSString *)text;
- (NSData *)data;
- (void)createXMLOrders;
- (BOOL)saveWithFileName:(NSString *)fileName;

@end
