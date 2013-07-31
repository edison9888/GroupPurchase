//
//  MapViewController.m
//  GroupPurchase
//
//  Created by xcode on 13-3-28.
//  Copyright (c) 2013年 LiHong. All rights reserved.
//

#import "MapViewController.h"
#import "ProductAnnotation.h"
#import "ProductOrderForLifeController.h"
#import "ProductOrderForProductController.h"

@interface MapViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) ProductAnnotation *annotation;
@property (strong, nonatomic) Product *product;
@end

@implementation MapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"商品位置";
    }
    return self;
}

- (void)viewDidUnload
{
    [self setMapView:nil];
    [self setMapView:nil];
    [super viewDidUnload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)showProductLocation:(Product *)product
{
    self.product = product;
    
    MKCoordinateRegion newRegion;
    
    newRegion.center.latitude = product.latitude;
    newRegion.center.longitude = product.longitude;
    newRegion.span.latitudeDelta =  0.006891;
    newRegion.span.longitudeDelta = 0.006891;
        
    [self.mapView setRegion:newRegion animated:NO];

    self.annotation = [[ProductAnnotation alloc] init];
    self.annotation.c2d = newRegion.center;
    self.annotation.titleStr = product.shopName;
    
    [self.mapView removeAnnotation:self.annotation];
    [self.mapView addAnnotation:self.annotation];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    // if it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    // try to dequeue an existing pin view first
    static NSString* BridgeAnnotationIdentifier = @"bridgeAnnotationIdentifier";
    MKPinAnnotationView* pinView = (MKPinAnnotationView *)
    [mapView dequeueReusableAnnotationViewWithIdentifier:BridgeAnnotationIdentifier];
    if (!pinView)
    {
        // if an existing pin view was not available, create one
        MKPinAnnotationView* customPinView = [[MKPinAnnotationView alloc]
                                               initWithAnnotation:annotation reuseIdentifier:BridgeAnnotationIdentifier];
        customPinView.pinColor = MKPinAnnotationColorPurple;
        customPinView.animatesDrop = YES;
        customPinView.canShowCallout = YES;
        
        // add a detail disclosure button to the callout which will open a new view controller page
        //
        // note: you can assign a specific call out accessory view, or as MKMapViewDelegate you can implement:
        //  - (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control;
        //
        UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [rightButton addTarget:self
                        action:@selector(showDetails:)
              forControlEvents:UIControlEventTouchUpInside];
        customPinView.rightCalloutAccessoryView = rightButton;
        
        return customPinView;
    }
    else
    {
        pinView.annotation = annotation;
    }
    return pinView;
}

- (void)showDetails:(UIButton *)sender
{
    if(self.product.type == 2)
    {
        ProductOrderForLifeController *polc;
        polc = [[ProductOrderForLifeController alloc] initWithNibName:@"ProductOrderForLifeController" bundle:nil];
        [self.navigationController pushViewController:polc animated:YES];
        polc.product = self.product;
    }
    else
    {
        ProductOrderForProductController *popc;
        popc = [[ProductOrderForProductController alloc] initWithNibName:@"ProductOrderForProductController" bundle:nil];
        [self.navigationController pushViewController:popc animated:YES];
        popc.product = self.product;
    }
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{

}


@end
