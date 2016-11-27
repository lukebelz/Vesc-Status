//
//  RideHistoryListView.h
//  VESC Status
//
//  Created by Heya on 10/25/16.
//  Copyright © 2016 Rocket Boards. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Structures.h"
#import "SVProgressHUD.h"

@interface RideHistoryListView : UIView <UITableViewDataSource,UITableViewDelegate> {
    NSString *dataPath;
    
    UITableView *rideHistoryTableView;
    
    NSMutableArray *rideHistoryPaths;
    NSMutableArray *rideHistoryNames;
}

- (id) initWithFrame:(CGRect)frame DataPath: (NSString*) dataPath_;

-(void) updateRideHistoryList;

@end
