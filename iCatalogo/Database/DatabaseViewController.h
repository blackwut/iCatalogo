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
#import "XMLParser.h"
#import "XMLCreator.h"
#import "YLTCPBroadcaster.h"

@interface DatabaseViewController : UIViewController <UIAlertViewDelegate, UITextFieldDelegate, AProgressViewDelegate, YLTCPBroadcasterDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmented;
@property (strong, nonatomic) NSMutableArray *servers;
@property (nonatomic, strong) YLTCPBroadcaster *broadcaster;
@property (assign, nonatomic) int indexServer;

@property (nonatomic, strong) IBOutlet UITextField *ipField;
@property (weak, nonatomic) IBOutlet UIButton *updateButton;
@property (nonatomic, strong) IBOutlet AProgressView *progressView;
@property (nonatomic, strong) IBOutlet UILabel *progressLabel;
@property (nonatomic, strong) IBOutlet UISwitch *showSubproducts;
@property (nonatomic, strong) IBOutlet UISwitch *goBackInsert;
@property (nonatomic, strong) IBOutlet UISwitch *selectAutomatic;



- (IBAction)showSubproductValueChanged:(id)sender;
- (IBAction)goBackInsertValueChanged:(id)sender;
- (IBAction)selectAutomaticValueChanged:(id)sender;

@end
