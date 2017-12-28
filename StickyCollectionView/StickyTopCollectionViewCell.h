//
//  StickyTopCollectionViewCell.h
//  StickyCollectionView
//
//  Created by Anca Julean on 27/12/2017.
//  Copyright © 2017 Anca Julean. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StickyTopCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;

@end
