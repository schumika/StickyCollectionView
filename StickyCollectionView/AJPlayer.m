//
//  AJPlayer.m
//  StickyCollectionView
//
//  Created by Anca Julean on 27/12/2017.
//  Copyright © 2017 Anca Julean. All rights reserved.
//

#import "AJPlayer.h"

@implementation AJPlayer

- (id)initWithName:(NSString *)name andScores:(NSArray *)scores {
    self = [super init];
    
    if (self == nil) {
        return nil;
    }
    
    _name = name;
    _scores = scores;
    
    return self;
}

- (double)total {
    double tot = 0.0;
    for (int scoreIndex = 0; scoreIndex < [self.scores count]; scoreIndex ++) {
        tot += [self.scores[scoreIndex] intValue];
    }
    return tot;
}

@end
