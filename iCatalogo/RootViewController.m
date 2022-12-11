//
//  RootViewController.m
//  iCatalogo
//
//  Created by Albertomac on 30/09/13.
//  Copyright (c) 2013 Albertomac. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.interactivePopGestureRecognizer setEnabled:NO];
    
    [self.navigationController setToolbarHidden:YES];
    
    //Creazione dei paths necessari
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = paths[0];
    
    //Xml da esportare nella cartella documents
    NSString *backupPath = [documentsPath stringByAppendingPathComponent:@"Backup"];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    [fm createDirectoryAtPath:backupPath withIntermediateDirectories:YES attributes:nil error:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"iCatalogo";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
