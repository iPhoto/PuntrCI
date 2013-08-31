//
//  CollectionManagerDelegate.h
//  Puntr
//
//  Created by Momus on 01.09.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#ifndef Puntr_CollectionManagerDelegate_h
#define Puntr_CollectionManagerDelegate_h

@protocol CollectionManagerDelegate <NSObject>

@optional

- (void)collectionViewDidSelectCellWithModel:(NSObject *)model;

@end


#endif
