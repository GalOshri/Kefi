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
    NSLog(@"previous frame is  x: %f and y: %f",previousFrame.origin.x, previousFrame.origin.y);
    
    /*
    if (!CGRectIntersectsRect(previousFrame, strecthedCurrentFrame)) { // if current item is the first item on the line
        // the approach here is to take the current frame, left align it to the edge of the view
        // then stretch it the width of the collection view, if it intersects with the previous frame then that means it
        // is on the same line, otherwise it is on it's own new line
        CGRect frame = currentItemAttributes.frame;
        frame.origin.x = sectionInset.left;
        
        
        [currentItemAttributes setFrame:frame];
        currentFrame = frame;
        
        NSLog(@"new line. previous frame has x: %f and y: %f. Current frame has x: %f and y: %f", previousFrame.origin.x, previousFrame.origin.y,frame.origin.x, frame.origin.y);
        
        return currentItemAttributes;
    }*/
    
   if (previousFrameRightPoint + currentItemAttributes.frame.size.width + kMaxCellSpacing > self.collectionView.frame.size.width) {
        CGRect frame = CGRectMake(sectionInset.left, currentItemAttributes.frame.origin.y + 25, currentItemAttributes.frame.size.width, currentFrame.size.height);
        
        [currentItemAttributes setFrame:frame];
        currentFrame = frame;
        
        NSLog(@"new line due to text being too long. New frame has x: %f and y: %f",currentItemAttributes.frame.origin.x, currentItemAttributes.frame.origin.y);
        
        return currentItemAttributes;
        
    }
    
    else {
        
        CGRect frame = currentItemAttributes.frame;
        frame.origin.x = previousFrameRightPoint;
        [currentItemAttributes setFrame:frame];
        currentFrame = frame;
        
        NSLog(@"continue same line");
        
        return currentItemAttributes;
    }

}


@end
