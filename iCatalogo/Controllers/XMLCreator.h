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

@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSString *text;
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSData *data;
- (void)createXMLOrders;
- (BOOL)saveWithFileName:(NSString *)fileName;
- (void)createXMLPhotoHash:(NSString *)filename;

@end
