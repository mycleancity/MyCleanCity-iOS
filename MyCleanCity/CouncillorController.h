//
//  CouncillorController.h
//  MyCleanCity
//
//  Created by fliptoo on 7/2/15.
//  Copyright (c) 2015 StrongByte Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface CouncillorController : UITableViewController

@property (nonatomic, weak) IBOutlet UIImageView *photo;
@property (nonatomic, weak) IBOutlet MKMapView *map;
@property (nonatomic, weak) IBOutlet UILabel *nameLbl;
@property (nonatomic, weak) IBOutlet UILabel *zoneLbl;
@property (nonatomic, weak) IBOutlet UILabel *mobileLbl;
@property (nonatomic, weak) IBOutlet UILabel *emailLbl;
@property (nonatomic, strong) NSDictionary *councillor;

- (IBAction)latestComplaints:(id)sender;
- (IBAction)latestCulprits:(id)sender;
- (IBAction)latestThinkBox:(id)sender;

@end
