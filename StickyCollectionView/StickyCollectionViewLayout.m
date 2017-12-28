//
//  StickyCollectionViewLayout.m
//  StickyCollectionView
//
//  Created by Anca Julean on 27/12/2017.
//  Copyright © 2017 Anca Julean. All rights reserved.
//

#import "StickyCollectionViewLayout.h"

@interface StickyCollectionViewLayout()

@property (nonatomic, strong) NSMutableArray *itemAttributes;
@property (nonatomic, strong) NSMutableArray *itemsSize;
@property (nonatomic, assign) CGSize contentSize;

@end


@implementation StickyCollectionViewLayout

- (void)prepareLayout {
    if ([self.collectionView numberOfSections] == 0) {
        return;
    }
    
    NSUInteger column = 0; // Current column insisde row
    CGFloat xOffset = 0.0;
    CGFloat yOffset = 0.0;
    CGFloat contentWidth = 0.0; // To determine contentSize
    CGFloat contentHeight = 0.0; // To determine contentSize
    
    if (self.itemAttributes.count > 0) {
        for (int section = 0; section < [self.collectionView numberOfSections]; section++) {
            NSUInteger numberOfItems = [self.collectionView numberOfItemsInSection:section];
            for (NSUInteger index = 0; index < numberOfItems; index++) {
                if (section != 0 && index != 0) { // this cell should not be stickied
                    continue;
                }
                UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:section]];
                if (section == 0) { // We stick the first row
                    CGRect frame = attributes.frame;
                    frame.origin.y = self.collectionView.contentOffset.y;
                    attributes.frame = frame;
                }
                if (index == 0) { // We stick the first column
                    CGRect frame = attributes.frame;
                    frame.origin.x = self.collectionView.contentOffset.x;
                    attributes.frame = frame;
                }
            }
        }
        return;
    }
    
    // The following code is executed only the first time we prepare the layout
    self.itemAttributes = [@[] mutableCopy];
    self.itemsSize = [@[] mutableCopy];
    
    NSUInteger numberOfColumns = [self.collectionView numberOfItemsInSection:0];
    // we calculate the size of each column
    if (self.itemsSize.count != numberOfColumns) {
        [self calculateItemsSize];
    }
    
    // we loop through all the items
    for (int section = 0; section < [self.collectionView numberOfSections]; section++) {
        NSMutableArray *sectionAttributes = [@[] mutableCopy];
        for (NSUInteger index = 0; index < [self.collectionView numberOfItemsInSection:section]; index++) {
            CGSize itemSize = [self.itemsSize[index] CGSizeValue];
            itemSize.height += (section == 0) ? 35.0 : 0.0; // adding some more space for the top row so it's higher
            
            // We create UICollectionViewLayoutAttributes object for each item and add it to the array
            // We will use this later in layoutAttributesForItemAtIndexPath:
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:section];
            UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            attributes.frame = CGRectIntegral(CGRectMake(xOffset, yOffset, itemSize.width, itemSize.height));
            
            if (section == 0 && index == 0) {
                attributes.zIndex = 1024; // Setting this value for the item @sec0row0 in order to make it visible over first row and column
            } else if (section == 0 || index == 0) {
                attributes.zIndex = 1023; // Setting this value so it is visible on top of other rows and columns
            }
            if (section == 0) {
                CGRect frame = attributes.frame;
                frame.origin.y = self.collectionView.contentOffset.y;
                attributes.frame = frame; // stick to the top
            }
            if (index == 0) {
                CGRect frame = attributes.frame;
                frame.origin.x = self.collectionView.contentOffset.x;
                attributes.frame = frame; // stick to the left
            }
            [sectionAttributes addObject:attributes];
            
            xOffset = xOffset + itemSize.width;
            column++;
            
            // create a new row if this was the last column
            if (column == numberOfColumns) {
                if (xOffset > contentWidth) {
                    contentWidth = xOffset;
                }
                
                // reset values
                column = 0;
                xOffset = 0;
                yOffset += itemSize.height;
            }
        }
        [self.itemAttributes addObject:sectionAttributes];
    }
    
    // get the last item to calculate the total height of the content
    UICollectionViewLayoutAttributes *attributes = [[self.itemAttributes lastObject] lastObject];
    contentHeight = attributes.frame.origin.y + attributes.frame.size.height;
    self.contentSize = CGSizeMake(contentWidth, contentHeight);
}

- (CGSize)collectionViewContentSize {
    return self.contentSize;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.itemAttributes[indexPath.section][indexPath.row];
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *attributes = [@[] mutableCopy];
    for (NSArray *section in self.itemAttributes) {
        [attributes addObjectsFromArray:[section filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UICollectionViewLayoutAttributes * evaluatedObject, NSDictionary *bindings) {
            return CGRectIntersectsRect(rect, [evaluatedObject frame]);
        }]]];
    }
    return attributes;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES; // setting this to YES to call prepareLayout on every scroll
}

- (CGSize)sizeForItemWithColumnIndex:(NSUInteger)columnIndex {
    CGSize size = [@"Player XX" sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:15]}];
    if (columnIndex == 0) {
        size.width = 25.0; // make first column with special width
    }
    return CGSizeMake([@(size.width + 9) floatValue], 35.0); // extra 9px space for all items
}

- (void)calculateItemsSize {
    for (NSUInteger index = 0; index < [self.collectionView numberOfItemsInSection:0]; index++) {
        if (self.itemsSize.count <= index) {
            CGSize itemSize = [self sizeForItemWithColumnIndex:index];
            NSValue *itemSizeValue = [NSValue valueWithCGSize:itemSize];
            [self.itemsSize addObject:itemSizeValue];
        }
    }
}

@end
