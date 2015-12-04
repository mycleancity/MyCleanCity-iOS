//
//  CulpritController.h
//  MyCleanCity
//
//  Created by fliptoo on 1/27/15.
//  Copyright (c) 2015 StrongByte Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "ComplaintDetailCell.h"
#import "SimpleButton.h"

@interface CulpritController : UITableViewController

@property (nonatomic, strong) NSDictionary *complaint;
@property (nonatomic, weak) IBOutlet UIImageView *photo;
@property (nonatomic, weak) IBOutlet UILabel *descLbl;
@property (nonatomic, weak) IBOutlet UILabel *addressLbl;
@property (nonatomic, weak) IBOutlet MKMapView *map;
@property (nonatomic, weak) IBOutlet UILabel *reportedByLbl;
@property (nonatomic, weak) IBOutlet UILabel *reportedOnLbl;
@property (nonatomic, weak) IBOutlet UILabel *repeatLbl;
@property (nonatomic, weak) IBOutlet UILabel *youtubeLbl;
@property (nonatomic, weak) IBOutlet ComplaintDetailCell *detailCell;
@property (nonatomic, weak) IBOutlet ComplaintDetailCell *addressCell;
@property (nonatomic, weak) IBOutlet UILabel *statusLbl;
@property (nonatomic, weak) IBOutlet SimpleButton *commentButton;
@property (nonatomic, weak) IBOutlet SimpleButton *shareButton;

- (IBAction)comment:(id)sender;
- (IBAction)share:(id)sender;

@end
