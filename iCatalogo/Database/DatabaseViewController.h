//
//  PreferencesViewController.h
//  iCatalogo
//
//  Created by Albertomac on 01/10/13.
//  Copyright (c) 2013 Albertomac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Constants.h"
#import "ZipArchive.h"
#import "AProgressView.h"
#import "AMSessionManager.h"
#import "XMLParser.h"
#import "XMLCreator.h"

@interface DatabaseViewController : UIViewController <UIAlertViewDelegate, UITextFieldDelegate, AProgressViewDelegate, AMSessionManagerDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmented;
@property (strong, nonatomic) NSMutableArray *servers;
@property (strong, nonatomic) AMSessionManager *session;
@property (assign, nonatomic) int indexServer;

@property (nonatomic, strong) IBOutlet UITextField *ipField;
@property (nonatomic, strong) IBOutlet AProgressView *progressView;
@property (nonatomic, strong) IBOutlet UILabel *progressLabel;

@end
