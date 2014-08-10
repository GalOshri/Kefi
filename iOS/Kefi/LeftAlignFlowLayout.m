//
//  LeftAlignFlowLayout.m
//  Kefi
//
//  Created by Gal Oshri on 6/5/14.
//  Copyright (c) 2014 Kefi. All rights reserved.
//

#import "LeftAlignFlowLayout.h"

const NSInteger kMaxCellSpacing = 9;

@implementation LeftAlignFlowLayout

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray* attributesToReturn = [super layoutAttributesForElementsInRect:rect];
    for (UICollectionViewLayoutAttributes* attributes in attributesToReturn) {
        if (nil == attributes.representedElementKind) {
            NSIndexPath* indexPath = attributes.indexPath;
            attributes.frame = [self layoutAttributesForItemAtIndexPath:indexPath].frame;
        }
    }
    return attributesToReturn;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes* currentItemAttributes =
    [super layoutAttributesForItemAtIndexPath:indexPath];
    
    UIEdgeInsets sectionInset = [(UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout sectionInset];
    
    if (indexPath.item == 0)
    {
        // first item of section
        CGRect frame = currentItemAttributes.frame;
        frame.origin.x = sectionInset.left; // first item of the section should always be left aligned
        currentItemAttributes.frame = frame;
        
       // NSLog(@"first item with x:%f, y:%f", currentItemAttributes.frame.origin.x, currentItemAttributes.frame.origin.y);
        return currentItemAttributes;
    }
    
    NSIndexPath* previousIndexPath = [NSIndexPath indexPathForItem:indexPath.item-1 inSection:indexPath.section];
    CGRect previousFrame = [self layoutAttributesForItemAtIndexPath:previousIndexPath].frame;
    CGFloat previousFrameRightPoint = previousFrame.origin.x + previousFrame.size.width + kMaxCellSpacing;
    
    // hack? We will always at least be at least as big.
    CGRect currentFrame = currentItemAttributes.frame;
    NSLog(@"changed height");
    currentItemAttributes.frame = CGRectMake(currentFrame.origin.x, previousFrame.origin.y, currentFrame.size.width, currentFrame.size.height);
    
    CGRect strecthedCurrentFrame = CGRectMake(0,
                                              currentItemAttributes.frame.origin.y,
                                              self.collectionView.frame.size.width,
                                              currentFrame.size.height);
    
    if (!CGRectIntersectsRect(previousFrame, strecthedCurrentFrame))
    {
        CGRect frame = CGRectMake(sectionInset.left, currentFrame.origin.y, currentItemAttributes.frame.size.width, currentFrame.size.height);
        
        [currentItemAttributes setFrame:frame];
        currentFrame = frame;
        
        // NSLog(@"new line started. Old Frame x:%f, y:%f. New frame x: %f and y: %f",previousFrame.origin.x, previousFrame.origin.y,currentItemAttributes.frame.origin.x, currentItemAttributes.frame.origin.y);
        return currentItemAttributes;
    }

    else if (previousFrameRightPoint + currentItemAttributes.frame.size.width + kMaxCellSpacing > self.collectionView.frame.size.width)
    {
        CGRect frame = CGRectMake(sectionInset.left, currentItemAttributes.frame.origin.y + 25, currentItemAttributes.frame.size.width, currentFrame.size.height);
        
        [currentItemAttributes setFrame:frame];
        currentFrame = frame;
        
       // NSLog(@"new line bc text too long. Old frame x:%f, y:%f. New frame has x: %f and y: %f",previousFrame.origin.x, previousFrame.origin.y,currentItemAttributes.frame.origin.x, currentItemAttributes.frame.origin.y);
        return currentItemAttributes;
    }
    
    else {
        CGRect frame = currentItemAttributes.frame;
        frame.origin.x = previousFrameRightPoint;
        frame.origin.y = previousFrame.origin.y;
        [currentItemAttributes setFrame:frame];
        currentFrame = frame;
        
        // NSLog(@"continue same line");
        return currentItemAttributes;
    }

}


@end
