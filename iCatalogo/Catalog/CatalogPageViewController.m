//
//  CatalogPageViewController.m
//  iCatalogo
//
//  Created by Albertomac on 03/10/13.
//  Copyright (c) 2013 Albertomac. All rights reserved.
//

#import "CatalogPageViewController.h"
#import "CatalogViewController.h"
#import "Constants.h"
#import "AppDelegate.h"
#import "FilterCatalogViewController.h"

@interface CatalogPageViewController ()
@property (nonatomic, assign) BOOL isAnimating;
@property (nonatomic, strong) FilterCatalogViewController * filterCatalogViewController;
@end

@implementation CatalogPageViewController

@synthesize pageField, totalButton;
@synthesize client, originalList, list, page, maxPage;
@synthesize isAnimating, filterCatalogViewController;

- (IBAction)filterButtonTouched:(id)sender
{
	filterCatalogViewController = [[UIStoryboard storyboardWithName:@"Storyboard" bundle:nil] instantiateViewControllerWithIdentifier:@"filterCatalogViewController"];
	filterCatalogViewController.modalPresentationStyle = UIModalPresentationPageSheet;
	filterCatalogViewController.catalogPageViewController = self;
	
	UINavigationController * navigationController = [[UINavigationController alloc] initWithRootViewController:filterCatalogViewController];
	navigationController.modalPresentationStyle = UIModalPresentationPageSheet;
	
	[self presentViewController:navigationController animated:YES completion:^{
	}];
}

- (void)updateTitle
{
    [pageField setText:[NSString stringWithFormat:@"%d", page]];
    [pageField resignFirstResponder];
}

- (CatalogViewController *)createCatalogViewControllerWithIndexPage:(int)indexPage
{
    CatalogViewController *controller = [[self storyboard] instantiateViewControllerWithIdentifier:@"catalog"];
    [controller setClient:client];
    [controller setList:list];
    [controller setPage:indexPage];
    
    return controller;
}

-  (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    if(page < maxPage && !isAnimating)
        return [self createCatalogViewControllerWithIndexPage:page+1];

    return nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    if(page > 1 && !isAnimating)
        return [self createCatalogViewControllerWithIndexPage:page-1];
    
    return nil;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    
    CatalogViewController *controller = [[pageViewController viewControllers] objectAtIndex:0];
    int prima = [controller page];
    
    CatalogViewController *c = [previousViewControllers objectAtIndex:0];
    int dopo = [c page];

    if(prima > dopo)
        page++;
    else if(prima < dopo)
        page--;
    
    
    [self updateTitle];
    
    isAnimating = NO;
}


- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers
{
    isAnimating = YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    int valuePageField = [[textField text] intValue];
    if(valuePageField != 0 && valuePageField < [self maxPage]){
    
        if(page != valuePageField){
            int direction = (page > valuePageField) ? UIPageViewControllerNavigationDirectionReverse : UIPageViewControllerNavigationDirectionForward;
            page = valuePageField;
            [self setViewControllers:@[[self createCatalogViewControllerWithIndexPage:page]] direction:direction animated:YES completion:nil];
        }
        
        [textField resignFirstResponder];
    }
        
    return YES;
}

- (void)reloadPageViewController
{
	NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
	
	if([[settings valueForKey:searchChanged] boolValue]){
		page = 1;
		[settings setBool:NO forKey:searchChanged];
	} else {
		page = [[settings valueForKey:catalogPage] intValue];
	}
	
	maxPage = (int)(([list count] + 5) / 6);
	
	[pageField setText:[NSString stringWithFormat:@"%d", page]];
	
	[self setViewControllers:@[[self createCatalogViewControllerWithIndexPage:page]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:YES];
    
    [self setDataSource:self];
    [self setDelegate:self];
	
	[self reloadPageViewController];
	
	if(client) {
		NSString *totalString = [[AppDelegate sharedAppDelegate] getTotalOrderOf:client];
		[totalButton setTitle:totalString];
	} else {
		[totalButton setTitle:@""];
	}
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    NSUserDefaults *options = [NSUserDefaults standardUserDefaults];
    [options setInteger:page forKey:catalogPage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
