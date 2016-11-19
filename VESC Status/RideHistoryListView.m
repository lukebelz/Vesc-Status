//
//  RideHistoryListView.m
//  VESC Status
//
//  Created by Heya on 10/25/16.
//  Copyright © 2016 Rocket Boards. All rights reserved.
//

#import "RideHistoryListView.h"

@implementation RideHistoryListView

- (id) initWithFrame:(CGRect)frame DataPath: (NSString*) dataPath_ {
    
    dataPath = dataPath_;
    
    rideHistoryPaths = [[NSMutableArray alloc] init];
    rideHistoryNames = [[NSMutableArray alloc] init];
    
    self = [super initWithFrame:frame];
    [self setBackgroundColor:[UIColor whiteColor]];
    
    Structures *strct = [[Structures alloc] init];
        
    [self addSubview:[strct createLabelWtihX:0 Y:0 Width:self.frame.size.width Height:50 Font:@"Avenir" FontSize:20 Text:@"Ride History" TextColor: [UIColor blackColor] TextAlignment:NSTextAlignmentCenter]];
    
    rideHistoryTableView = [[UITableView alloc]init];
    rideHistoryTableView.frame = CGRectMake(10,40,self.frame.size.width-20,self.frame.size.height-40);
    rideHistoryTableView.dataSource=self;
    rideHistoryTableView.delegate=self;
    rideHistoryTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [rideHistoryTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    [rideHistoryTableView reloadData];
    [self addSubview:rideHistoryTableView];
    
    [self updateRideHistoryList];
    
    return self;
}

-(void) updateRideHistoryList {
    rideHistoryPaths = [[NSMutableArray alloc] init];
    rideHistoryNames = [[NSMutableArray alloc] init];
    
    NSArray* dirs = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:dataPath
                                                                        error:NULL];
    [dirs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *filename = (NSString *)obj;
        NSString *extension = [[filename pathExtension] lowercaseString];
        if ([extension isEqualToString:@"txt"]) {
            [rideHistoryNames addObject:[filename stringByReplacingOccurrencesOfString:@".txt" withString:@""]];
            [rideHistoryPaths addObject:[dataPath stringByAppendingPathComponent:filename]];
        }
    }];
    
    [rideHistoryTableView reloadData];
}

#pragma mark - Table Functions

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [rideHistoryNames count];
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //remove the deleted object from your data source.
        //If your data source is an NSMutableArray, do this
        [[NSFileManager defaultManager] removeItemAtPath:rideHistoryPaths[indexPath.row] error:nil];
        
        [rideHistoryPaths removeObjectAtIndex:indexPath.row];
        [rideHistoryNames removeObjectAtIndex:indexPath.row];
        [tableView reloadData]; // tell table to refresh now
    }
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier   forIndexPath:indexPath] ;
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text=[rideHistoryNames objectAtIndex:indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"loadPastData" object:[rideHistoryPaths objectAtIndex:indexPath.row]];
    NSLog(@"You click on item %ld", (long)indexPath.row);
}

@end
