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
    
    if (indexPath.item == 0) { // first item of section
        CGRect frame = currentItemAttributes.frame;
        frame.origin.x = sectionInset.left; // first item of the section should always be left aligned
        currentItemAttributes.frame = frame;
        
        return currentItemAttributes;
    }
    
    NSIndexPath* previousIndexPath = [NSIndexPath indexPathForItem:indexPath.item-1 inSection:indexPath.section];
    CGRect previousFrame = [self layoutAttributesForItemAtIndexPath:previousIndexPath].frame;
    CGFloat previousFrameRightPoint = previousFrame.origin.x + previousFrame.size.width + kMaxCellSpacing;
    
    CGRect currentFrame = currentItemAttributes.frame;
    CGRect strecthedCurrentFrame = CGRectMake(0,
                                              currentFrame.origin.y,
                                              self.collectionView.frame.size.width,
                                              currentFrame.size.height);
    
    // NSLog(@"previous frame is  x: %f and y: %f",previousFrame.origin.x, previousFrame.origin.y);
    
    if (!CGRectIntersectsRect(previousFrame, strecthedCurrentFrame)) {
        CGRect frame = CGRectMake(sectionInset.left, currentItemAttributes.frame.origin.y, currentItemAttributes.frame.size.width, currentFrame.size.height);
        
        [currentItemAttributes setFrame:frame];
        currentFrame = frame;
        
        // NSLog(@"new line. New frame has x: %f and y: %f",currentItemAttributes.frame.origin.x, currentItemAttributes.frame.origin.y);
        
        return currentItemAttributes;

    }

    else if (previousFrameRightPoint + currentItemAttributes.frame.size.width + kMaxCellSpacing > self.collectionView.frame.size.width) {
        CGRect frame = CGRectMake(sectionInset.left, currentItemAttributes.frame.origin.y + 25, currentItemAttributes.frame.size.width, currentFrame.size.height);
        
        [currentItemAttributes setFrame:frame];
        currentFrame = frame;
        
        // NSLog(@"new line due to text being too long. New frame has x: %f and y: %f",currentItemAttributes.frame.origin.x, currentItemAttributes.frame.origin.y);
        
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
