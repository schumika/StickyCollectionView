//
//  AJPlayer.h
//  StickyCollectionView
//
//  Created by Anca Julean on 27/12/2017.
//  Copyright © 2017 Anca Julean. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AJPlayer : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray *scores;

- (id)initWithName:(NSString *)name andScores:(NSArray *)scores;
- (double)total;

@end
