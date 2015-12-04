//
//  CouncillorController.m
//  MyCleanCity
//
//  Created by fliptoo on 7/2/15.
//  Copyright (c) 2015 StrongByte Studio. All rights reserved.
//

#import "CouncillorController.h"
#import "Constant.h"
#import "UIViewController+Back.h"
#import "FAKIonIcons.h"
#import "UIViewController+BarButtonItem.h"
#import "UIImageView+AFNetworking.h"
#import "UIViewController+Storyboard.h"
#import "Api+Councillor.h"
#import "Cache.h"
#import "User.h"
#import "UIAlertView+Blocks.h"
#import "SVProgressHUD.h"
#import "ComplaintsController.h"
#import "CulpritsController.h"
#import "ThinkBoxesController.h"

@interface CouncillorController ()

@property (nonatomic, strong) NSMutableArray *complaints;
@property (nonatomic, strong) NSMutableArray *culprits;
@property (nonatomic, strong) NSMutableArray *thinkboxes;

- (void)pin:(NSDictionary *)point;

@end

@implementation CouncillorController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.hidesBackButton = YES;
    self.title = @"COUNCILLOR DETAIL";
    
    UIBarButtonItem *backItem = [self barButtonItem:[FAKIonIcons iosArrowBackIconWithSize:25]
                                             action:@selector(back:)];
    self.navigationItem.leftBarButtonItems = @[backItem];
    
    self.zoneLbl.text = [[[self.councillor objectForKey:@"zone"] valueForKey:@"name"] uppercaseString];
    self.nameLbl.text = [self.councillor objectForKey:@"name"];
    self.emailLbl.text = [self.councillor objectForKey:@"email"];
    self.mobileLbl.text = [self.councillor objectForKey:@"mobile"];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/media/image/600/%@", HOST,
                                       [self.councillor objectForKey:@"photo"]]];
    [self.photo setImageWithURL:url placeholderImage:[UIImage imageNamed:@"Placeholder"]];
    
    [SVProgressHUD show];
    [Api findCouncillor:[self.councillor valueForKey:@"ID"] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        self.complaints = [[NSMutableArray alloc] initWithArray:[responseObject valueForKey:@"complaints"]];
        self.culprits = [[NSMutableArray alloc] initWithArray:[responseObject valueForKey:@"culprits"]];
        self.thinkboxes = [[NSMutableArray alloc] initWithArray:[responseObject valueForKey:@"thinkBoxes"]];
        NSArray *maps = [responseObject valueForKey:@"maps"];
        for (NSDictionary *map in maps) {
            [self pin:map];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        [UIAlertView showOnlyWithTitle:@"Ops..." message:@"Please try again later."];
    }];
}

- (void)pin:(NSDictionary *)point {
    dispatch_queue_t queue = dispatch_queue_create("com.MyApp.AppTask",NULL);
    dispatch_queue_t main = dispatch_get_main_queue();
    dispatch_async(queue,
                   ^{
                       CLLocationCoordinate2D coordinate;
                       coordinate.latitude = [[point objectForKey:@"latitude"] doubleValue];
                       coordinate.longitude = [[point objectForKey:@"longitude"] doubleValue];
                       if(!CLLocationCoordinate2DIsValid(coordinate)) return;
                       
                       MKCoordinateSpan span;
                       span.longitudeDelta = 0.05;
                       span.latitudeDelta = 0.05;
                       
                       MKCoordinateRegion region;
                       region.center = coordinate;
                       region.span = span;
                       
                       dispatch_async(main,
                                      ^{
                                          self.map.region = region;
                                          MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
                                          annotation.coordinate = coordinate;
                                          annotation.title = [[point objectForKey:@"status"] stringValue];
                                          [self.map addAnnotation:annotation];
                                      });
                   });
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    int status = ((MKPointAnnotation *)annotation).title.intValue;
    MKPinAnnotationView *pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
    if (status == 6) {
        pinView.pinColor = MKPinAnnotationColorRed;
    } else if (status == 4) {
        pinView.pinColor = MKPinAnnotationColorGreen;
    } else {
        pinView.pinColor = MKPinAnnotationColorPurple;
    }
    return pinView;
}

- (IBAction)latestComplaints:(id)sender {
    ComplaintsController *vc = [self controller:@"Complaints"];
    vc.zone = [[self.councillor objectForKey:@"zone"] valueForKey:@"ID"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)latestCulprits:(id)sender {
    CulpritsController *vc = [self controller:@"Culprits"];
    vc.zone = [[self.councillor objectForKey:@"zone"] valueForKey:@"ID"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)latestThinkBox:(id)sender {
    ThinkBoxesController *vc = [self controller:@"ThinkBoxes"];
    vc.zone = [[self.councillor objectForKey:@"zone"] valueForKey:@"ID"];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
