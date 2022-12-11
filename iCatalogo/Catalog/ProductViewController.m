//
//  ProductViewController.m
//  iCatalogo
//
//  Created by Albertomac on 05/10/13.
//  Copyright (c) 2013 Albertomac. All rights reserved.
//

#import "ProductViewController.h"

@interface ProductViewController ()

@property (nonatomic, strong) NSArray *list;
@property (nonatomic, assign) BOOL goBackAfterInsert;
@property (nonatomic, assign) BOOL selectAutomatic;

@end

@implementation ProductViewController

@synthesize image, productLabel, supplierLabel, xSubproduct, xColor, xType, xPackage, xCartoon, note, quantity, add, table;
@synthesize list, client, order, product, goBackAfterInsert, selectAutomatic;
@synthesize barcodeText;

- (void)openPhoto
{
	UIImage *img = image.image;
	
	if (img) {
		APhoto *photo = [[APhoto alloc] initWithImage:img delegate:self];
		[photo show];
	}
}

#pragma -mark TextField

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //Controlla e sistema l'input
    NSString *toCompare = [NSString stringWithFormat:@"%@%@",textField.text, string];
    NSString *regex = @"^$|^0$|^[1-9]{1}[0-9]{0,}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    if(![predicate evaluateWithObject:toCompare]){
        regex = @"^[0-9]$";
        predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        if(![predicate evaluateWithObject:string])
            return NO;
        
        textField.text = string;
        return NO;
    }
    
    //Sistema la quantità in base al campo in cui è inserita
    //(es. Se viene inserita la quantità in xType, il TextField quantity viene impostato a 0,
    // se viene inserito il valore in quantity, i TextFields "x" verranno impostati a 0)
    if(textField == quantity){
        xSubproduct.text = @"";
        xType.text = @"";
        xColor.text = @"";
        xPackage.text = @"";
        xCartoon.text = @"";
        
    } else if(textField == xSubproduct){
        quantity.text = @"";
        xType.text = @"";
        
    } else if(textField == xType){
        quantity.text = @"";
        xSubproduct.text = @"";
        
    } else {
        quantity.text = @"";
    }

    return YES;
}

- (void)setInputTextFieldsEnabled:(BOOL)boolean
{
    xSubproduct.enabled = boolean;
    xType.enabled = boolean;
    xColor.enabled = boolean;
    xPackage.enabled = boolean;
    xCartoon.enabled = boolean;
    quantity.enabled = boolean;
    
    for (int i = 0; i<7; i++){
        ((UIButton *)[self.view viewWithTag:i+14]).enabled = boolean;
    }
}

#pragma -mark IBActions

- (IBAction)selectStandardQuantity:(id)sender
{
    //Permette la selezione di una determinata quantità grazie ai Buttons nello storyboards
    xSubproduct.text = @"";
    xType.text = @"";
    xColor.text = @"";
    xPackage.text = @"";
    xCartoon.text = @"";
    
    quantity.text = [sender titleLabel].text;
}

- (IBAction)insertProducts:(id)sender
{
    //Controlla se almeno in un campo delle quantità c'è una quantità
    if(quantity.text.intValue == 0 &&
       xSubproduct.text.intValue == 0 &&
       xType.text.intValue == 0 &&
       xColor.text.intValue == 0 &&
       xPackage.text.intValue == 0 &&
       xCartoon.text.intValue == 0){
        
        AMessage *message = [[AMessage alloc] initWithMessage:@"Inserisci bene i campi" dismissWithin:1.5f delegate:self comeBack:NO];
        [message show];
        return;
    }
    
    //Fa sparire la tastiera
    //[self.view endEditing:YES];
    
    NSArray *indexPaths = (self.table).indexPathsForSelectedRows;
    BOOL boolMessage = NO;
    
    for(NSIndexPath *index in indexPaths){
        NSManagedObject *object = (self.list)[index.row];
        boolMessage = [self insertSubproduct:object] || boolMessage;
    }
    
    NSString *messageText;
    if(boolMessage){
        
        if(indexPaths.count > 1)
            messageText = @"Articoli Modificati";
        else messageText = @"Articolo Modificato";
            
    } else {
        
        if(indexPaths.count > 1)
            messageText = @"Articoli Inseriti";
        else messageText = @"Articolo Inserito";
    }
    
    AMessage *message = [[AMessage alloc] initWithMessage:messageText dismissWithin:1.0 delegate:self comeBack:YES];
    [message show];
	
	if (goBackAfterInsert || (self.list).count == 1) {
    	[self.navigationController popViewControllerAnimated:YES];
	} else {
		[self.table reloadData];
	}
}

- (BOOL)insertSubproduct:(NSManagedObject *)subproduct
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"subproduct = %@ AND client = %@", subproduct, client];
    NSArray *orders = [[AppDelegate sharedAppDelegate] searchEntity:@"Orders" withPredicate:predicate sortedBy:nil];
    
    NSManagedObjectContext *context = [AppDelegate sharedAppDelegate].managedObjectContext;
    NSManagedObject *object;
    
    if(orders.count > 0)
        object = orders[0];
    else object = [NSEntityDescription insertNewObjectForEntityForName:@"Orders" inManagedObjectContext:context];
    
    [[client valueForKey:@"orders"] addObject:object];

    [object setValue:client forKey:@"client"];
    [object setValue:subproduct forKey:@"subproduct"];
    [object setValue:note.text forKey:@"note"];
    [object setValue:quantity.text forKey:@"quantity"];
    [object setValue:xSubproduct.text forKey:@"xSubproduct"];
    [object setValue:xColor.text forKey:@"xColor"];
    [object setValue:xType.text forKey:@"xType"];
    [object setValue:xPackage.text forKey:@"xPackage"];
    [object setValue:xCartoon.text forKey:@"xCartoon"];
    
    
     if(orders.count == 0)
         [context insertObject:object];
    
    [context save:nil];
    
    return orders.count>0;
}

#pragma TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return list.count;
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//	UIColor * selectedColor = (indexPath.row % 2 == 0 ? lightBlue : [UIColor clearColor]);
//	[cell setBackgroundColor:selectedColor];
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.table dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
	
	cell.selectionStyle = UITableViewCellSelectionStyleDefault;
	UIView * selectedBackgroundView = [[UIView alloc] init];
	[selectedBackgroundView setBackgroundColor:lightGreen];
	cell.selectedBackgroundView = selectedBackgroundView;
	 
    NSManagedObject *object = list[indexPath.row];
    
    [self configureCell:cell withObject:object];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell withObject:(NSManagedObject *)object
{
    UILabel *barcode = (UILabel *)[cell viewWithTag:1];
    UILabel *sub = (UILabel *)[cell viewWithTag:2];
    UILabel *quantityPackage = (UILabel *)[cell viewWithTag:3];
    UILabel *quantityCartoon = (UILabel *)[cell viewWithTag:4];
    UILabel *quantityStock = (UILabel *)[cell viewWithTag:5];
    UILabel *price = (UILabel *)[cell viewWithTag:6];
    UILabel *profit = (UILabel *)[cell viewWithTag:7];
    
    barcode.text = [object valueForKey:@"barcode"];
    
    NSMutableString *subproductString = [[object valueForKey:@"subproduct"] mutableCopy];
    NSString *noteString = [object valueForKey:@"note"];
    
    if (noteString.length > 0 )
        [subproductString appendFormat:@" - %@", noteString];
    
    sub.text = subproductString;
    quantityPackage.text = [object valueForKey:@"quantityPackage"];
    quantityCartoon.text = [object valueForKey:@"quantityCartoon"];
    quantityStock.text = [object valueForKey:@"quantity"];
    price.text = [NSString stringWithFormat:@"€ %@", [object valueForKey:@"price"]];
    profit.text = [object valueForKey:@"profit"];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if((self.table).indexPathsForSelectedRows.count-1 == 0){
        
        xSubproduct.backgroundColor = [UIColor clearColor];
        xColor.backgroundColor = [UIColor clearColor];
        xType.backgroundColor = [UIColor clearColor];
        xPackage.backgroundColor = [UIColor clearColor];
        xCartoon.backgroundColor = [UIColor clearColor];
        
        quantity.text = @"";
        
        [add setEnabled:NO];
        
        [self setInputTextFieldsEnabled:NO];
    }

    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [add setEnabled:YES];
    [self setInputTextFieldsEnabled:YES];
    
    UIColor *red = [UIColor colorWithRed:1.0f green:0.0f blue:0.0f alpha:0.5f];
    
    NSManagedObject *subproduct = list[indexPath.row];
    
    //xColor
    if([[subproduct valueForKey:@"quantityColor"] integerValue] > 0)
        xColor.backgroundColor = [UIColor clearColor];
    else xColor.backgroundColor = red;
    
    //xPackage
    if([[subproduct valueForKey:@"quantityPackage"] integerValue] > 0)
        xPackage.backgroundColor = [UIColor clearColor];
    else xPackage.backgroundColor = red;
    
    //xCartoon
    if([[subproduct valueForKey:@"quantityCartoon"] integerValue] > 0)
        xCartoon.backgroundColor = [UIColor clearColor];
    else xCartoon.backgroundColor = red;
    
    quantity.text = [subproduct valueForKey:@"quantityPackage"];
}

#pragma Application

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	NSUserDefaults *options = [NSUserDefaults standardUserDefaults];
	goBackAfterInsert = [options boolForKey:goBackInsertOption];
	selectAutomatic = [options boolForKey:selectAutomaticOption];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	
	[self.add setBackgroundColor:lightGreen];
	[self.add setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	
    [self.navigationController setToolbarHidden:YES];

    //Se non si sta facendo un ordine
    if(client == nil){
        
        [self.table setAllowsSelection:NO];
        
        for(int i = 1; i<23; i++)
            [[self.view viewWithTag:i] setHidden:YES];
    }
    
    [self setInputTextFieldsEnabled:NO];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openPhoto)];
    tap.numberOfTouchesRequired = 1;
    [image addGestureRecognizer:tap];
        
    image.image = [UIImage imageWithContentsOfFile:[[AppDelegate sharedAppDelegate] absolutePathWithFilePath:[product valueForKey:@"photo"]]];
    productLabel.text = [product valueForKey:@"product"];
    supplierLabel.text = [product valueForKey:@"supplier"];
    
    self.list = [[product valueForKey:@"subproducts"] allObjects];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"subproduct" ascending:YES];
    self.list = [self.list sortedArrayUsingDescriptors:@[sort]];
    [self.table reloadData];
    
    //Se si sta modificando un ordine
    if(order != nil){
        
        [self setInputTextFieldsEnabled:YES];
        
        NSManagedObject *subproduct = [order valueForKey:@"subproduct"];

        NSIndexPath *index = [NSIndexPath indexPathForRow:[self.list indexOfObject:subproduct] inSection:0];
        [self.table selectRowAtIndexPath:index animated:NO scrollPosition:UITableViewScrollPositionNone];
        [self tableView:self.table didSelectRowAtIndexPath:index];
        
        quantity.text = [order valueForKey:@"quantity"];
        note.text = [order valueForKey:@"note"];
        xSubproduct.text = [order valueForKey:@"xSubproduct"];
        xColor.text = [order valueForKey:@"xColor"];
        xType.text = [order valueForKey:@"xType"];
        xPackage.text = [order valueForKey:@"xPackage"];
        xCartoon.text = [order valueForKey:@"xCartoon"];
	} else {
		if (selectAutomatic && list.count == 1) {
			NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
			[self.table selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
			[self tableView:self.table didSelectRowAtIndexPath:indexPath];
		}
	}
    
    if (self.barcodeText) {
        if (client == nil) [self.table setAllowsSelection:YES]; // make selection even if no client is selected
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"barcode ENDSWITH[cd] %@", barcodeText];
        NSArray *barcodeList = [self.list filteredArrayUsingPredicate:predicate];
        for (NSManagedObject *selected in barcodeList) {
            NSIndexPath *index = [NSIndexPath indexPathForRow:[self.list indexOfObject:selected] inSection:0];
            [self.table selectRowAtIndexPath:index animated:NO scrollPosition:UITableViewScrollPositionNone];
            [self tableView:self.table didSelectRowAtIndexPath:index];
        }
        if (client == nil) [self.table setAllowsSelection:NO]; // revert if no client is selected
    }
	
	(self.table).separatorInset = UIEdgeInsetsZero;
//	[self.table setSeparatorColor:[UIColor clearColor]];
}

@end
