//
//  StickyCollectionViewController.m
//  StickyCollectionView
//
//  Created by Anca Julean on 27/12/2017.
//  Copyright © 2017 Anca Julean. All rights reserved.
//

#import "StickyCollectionViewController.h"
#import "StickyCollectionViewCell.h"
#import "StickyTopCollectionViewCell.h"
#import "AJPlayer.h"

@interface StickyCollectionViewController ()

//@property (nonatomic, strong) NSArray *inputData;
@property (nonatomic, strong) NSMutableArray<AJPlayer *> *players;

@end

@implementation StickyCollectionViewController

static NSString * const reuseIdentifier = @"ContentCell";
static NSString * const topCellReuseIdentifier = @"TopCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createInputData];
}

- (void)createInputData {
    NSArray *standardScores = @[@200, @499, @399, @599, @372, @596, @398, @297, @276, @345, @436, @45, @72, @365, @765, @398, @297, @276, @345, @436, @45, @72, @365, @765];
    
    
    // ------------------------------------------------------------------------------------------------------------------------------------------------------------
    
    // create data (TODO: get from db)
    self.players = [NSMutableArray array];
    for (int plIndex = 0; plIndex < 12; plIndex ++) {
        AJPlayer *player = [[AJPlayer alloc] initWithName:[NSString stringWithFormat:@"Pl.%d", plIndex+1] andScores:[standardScores copy]];
        [self.players addObject:player];
    }
    
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self.players[0].scores count] + 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.players.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = nil;
    if (indexPath.section == 0 && indexPath.row != 0) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:topCellReuseIdentifier forIndexPath:indexPath];
    } else {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    }
    
    if (indexPath.section % 2 != 0) {
        cell.backgroundColor = indexPath.row == 0 ? [UIColor colorWithWhite:0.7 alpha:1.0] : [UIColor colorWithWhite:242.0/255.0 alpha:1.0];
    } else {
        cell.backgroundColor = indexPath.row == 0 ? [UIColor colorWithWhite:0.5 alpha:1.0] : [UIColor whiteColor];
    }
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [(StickyCollectionViewCell *)cell contentLabel].text = @"X";
        } else {
            [(StickyTopCollectionViewCell *)cell topLabel].text = self.players[indexPath.row-1].name;  // player name
            [(StickyTopCollectionViewCell *)cell bottomLabel].text = [NSString stringWithFormat:@"%g", [self.players[indexPath.row-1] total]]; // player total
        }
    } else {
        int round = (int)(self.players[0].scores.count - indexPath.section);
        if (indexPath.row == 0) {
            [(StickyCollectionViewCell *)cell contentLabel].text = [NSString stringWithFormat:@"#%d", round+1]; // #round
        } else {
            [(StickyCollectionViewCell *)cell contentLabel].text = [NSString stringWithFormat:@"%d", [(NSNumber *)self.players[indexPath.row - 1].scores[round] intValue]]; // score
        }
    }
    
    return cell;
}

@end
