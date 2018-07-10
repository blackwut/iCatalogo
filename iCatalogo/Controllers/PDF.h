//
//  PDF.h
//  iCatalogo
//
//  Created by Albertomac on 08/12/13.
//  Copyright (c) 2013 Albertomac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PDF : NSObject

@property (nonatomic, assign) int line;

- (NSString *)createPdfOfClient:(NSManagedObject *)client;

@end
