//
//  OrderViewController.h
//  iCatalogo
//
//  Created by Albertomac on 02/10/13.
//  Copyright (c) 2013 Albertomac. All rights reserved.
//

#import "TableViewController.h"
#import <MessageUI/MFMailComposeViewController.h>

@interface OrderViewController : TableViewController <TableViewDelegate, MFMailComposeViewControllerDelegate, UIDocumentInteractionControllerDelegate>

@property (strong, nonatomic) NSManagedObject *client;

@end
