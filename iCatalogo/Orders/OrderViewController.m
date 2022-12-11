//
//  OrderViewController.m
//  iCatalogo
//
//  Created by Albertomac on 02/10/13.
//  Copyright (c) 2013 Albertomac. All rights reserved.
//

#import "OrderViewController.h"
#import "CatalogListViewController.h"
#import "ProductViewController.h"
#import "PDFCreator.h"

@interface OrderViewController ()

@property (nonatomic, strong) UIBarButtonItem *previewButton;
@property (nonatomic, strong) UIBarButtonItem *totalLabel;
@property (nonatomic, strong) UIBarButtonItem *sendButton;

@end

@implementation OrderViewController

@synthesize client;
@synthesize previewButton, totalLabel, sendButton;


- (IBAction)sendOrder:(id)sender
{
    if([self.list count]==0)
        return;
    
	PDFCreator *pdf = [[PDFCreator alloc] initWithNibName:@"PDFCreator" bundle:nil];
    
    [self.view addSubview:pdf.view];
    [pdf.view removeFromSuperview];
    
    NSString *pdfPath = [pdf createPdfOfClient:client];
    NSData *data = [NSData dataWithContentsOfFile:pdfPath];
    
    MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
    [mail setMailComposeDelegate:self];
    
    NSLog(@"email: %@", [client valueForKey:@"email"]);
    
    if([MFMailComposeViewController canSendMail]){
        
        NSString *email = [client valueForKey:@"email"];
        
        if(email != nil)
            [mail setToRecipients:@[email]];
        
        [mail setSubject:@"Ordine Mediterranea Casalinghi"];
        [mail setMessageBody:@"Puoi scaricare l'ordine" isHTML:NO];
        [mail addAttachmentData:data mimeType:@"application/pdf" fileName:@"Ordine.pdf"];
        [self presentViewController:mail animated:YES completion:nil];
    }
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
	
	[self dismissViewControllerAnimated:YES completion:nil];
	
    if (result == MFMailComposeResultFailed){
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Messaggio non inviato!" message:@"Non è stato possibile inviare la tua e-mail" delegate:self cancelButtonTitle:@"Annulla" otherButtonTitles:nil];
		[alert show];
	}
}

- (IBAction)previewOrder:(id)sender
{
    if([self.list count]==0)
        return;
    
    PDFCreator *pdfCreator = [[PDFCreator alloc] initWithNibName:@"PDFCreator" bundle:nil];
    
    [self.view addSubview:pdfCreator.view];
    [pdfCreator.view removeFromSuperview];
        
    NSURL *urlPdf = [NSURL fileURLWithPath:[pdfCreator createPdfOfClient:client]];
    
    UIDocumentInteractionController *documentController = [UIDocumentInteractionController interactionControllerWithURL:urlPdf];
    [documentController setDelegate:self];
    [documentController presentPreviewAnimated:YES];
}

- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller
{
    return self;
}

- (void)configureCell:(UITableViewCell *)cell withObject:(NSManagedObject *)object
{
    UILabel *productLabel = (UILabel *)[cell viewWithTag:1];
	UILabel *supplierLabel = (UILabel *)[cell viewWithTag:2];
    UILabel *subproductLabel = (UILabel *)[cell viewWithTag:3];
    UILabel *quantityLabel = (UILabel *)[cell viewWithTag:4];
    
    
    NSMutableString *product = [[[[object valueForKey:@"subproduct"] valueForKey:@"product"] valueForKey:@"product"] mutableCopy];
    NSString *subproduct = [[object valueForKey:@"subproduct"] valueForKey:@"subproduct"];
	NSString *supplier = [[[object valueForKey:@"subproduct"] valueForKey:@"product"] valueForKey:@"supplier"];
    NSString *quantity = [object valueForKey:@"quantity"];
    
    NSString *note = [object valueForKey:@"note"];
    NSString *xSubproduct = [object valueForKey:@"xSubproduct"];
    NSString *xType = [object valueForKey:@"xType"];
    NSString *xColor = [object valueForKey:@"xColor"];
    NSString *xPackage = [object valueForKey:@"xPackage"];
    NSString *xCartoon = [object valueForKey:@"xCartoon"];

    if ([note length] > 0)
        [product appendFormat:@" - %@", note];
    
    //Se esistono valori per xSubproduct, xColor o xType allora non inserisce la misura.
    if ([xSubproduct length] > 0){
        [product appendFormat:@" - %@ x Misura", xSubproduct];
        subproduct = @"";
    }
    if ([xColor length] > 0){
        [product appendFormat:@" - %@ x Colore", xColor];
        subproduct = @"";
    }
    if ([xType length] > 0){
        [product appendFormat:@" - %@ x Tipo", xType];
        subproduct = @"";
    }
    
    if ([xPackage length] > 0)
        [product appendFormat:@" - %@ x Confezione", xPackage];
    if ([xCartoon length] > 0)
        [product appendFormat:@" - %@ x Cartone", xCartoon];
    
    [productLabel setText:product];
	[supplierLabel setText:supplier];
    [subproductLabel setText:subproduct];
    [quantityLabel setText:quantity];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"catalogList"]){
        CatalogListViewController *controller = [segue destinationViewController];
        controller.client = client;
        
    } else if([[segue identifier] isEqualToString:@"product"]) {
        ProductViewController *controller = [segue destinationViewController];
        controller.client = client;
        
        NSManagedObject *order = [self.list objectAtIndex:[[self.tableView indexPathForSelectedRow] row]];
        controller.product = [[order valueForKey:@"subproduct"] valueForKey:@"product"];
        controller.order = order;
    }
}

- (void)deleteObjectWithIndexPath:(NSIndexPath *)index
{
    NSManagedObject *object = [self.list objectAtIndex:[index row]];
    [[AppDelegate sharedAppDelegate] deleteObject:object error:nil];
    [self.list removeObject:object];
    
    [totalLabel setTitle:[[AppDelegate sharedAppDelegate] getTotalOrderOf:client]];
}

#pragma Application

- (void)configureView
{
    [self setTitle:[client valueForKey:@"client"]];
    [self setCanEdit:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self setDelegate:self];
    [super viewWillAppear:animated];
    
    self.list = [NSMutableArray arrayWithArray:[[client valueForKey:@"orders"] allObjects]];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"subproduct.product.product" ascending:YES];
    [self.list sortUsingDescriptors:[NSArray arrayWithObject:sort]];
    
    [self.tableView reloadData];
    
    previewButton = [[UIBarButtonItem alloc] initWithTitle:@"Vis. Ordine" style:UIBarButtonItemStylePlain target:self action:@selector(previewOrder:)];
    totalLabel = [[UIBarButtonItem alloc] initWithTitle:[[AppDelegate sharedAppDelegate] getTotalOrderOf:client] style:UIBarButtonItemStylePlain target:self action:nil];
    sendButton = [[UIBarButtonItem alloc] initWithTitle:@"Invia Ordine" style:UIBarButtonItemStylePlain target:self action:@selector(sendOrder:)];
    
    UIBarButtonItem *flexyLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *flexyRight = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    [self setToolbarItems:@[previewButton, flexyLeft, totalLabel, flexyRight, sendButton]];
    [self.navigationController setToolbarHidden:NO];
}

@end
