//
//  SubproductCollectionViewCell.h
//  iCatalogo
//
//  Created by Alberto Ottimo on 04/10/15.
//  Copyright © 2015 Albertomac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubproductCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *subproductLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

- (void)setupWithSubproduct:(NSManagedObject *)subproduct;

@end
