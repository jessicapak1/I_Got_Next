//
//  MapViewController.h
//  FinalProject
//
//  Created by Jessica Pak on 5/4/16.
//  Copyright © 2016 Jessica Pak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>


@interface MapViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end
