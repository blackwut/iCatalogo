//
//  SubproductsCollectionView.h
//  iCatalogo
//
//  Created by Alberto Ottimo on 04/10/15.
//  Copyright © 2015 Albertomac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubproductsCollectionView : UICollectionView <UICollectionViewDataSource, UICollectionViewDelegate>

- (void)setupWithProduct:(NSManagedObject *)product;

@end
