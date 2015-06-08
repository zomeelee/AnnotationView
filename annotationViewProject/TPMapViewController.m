//
//  MapViewController.m
//  TestProjV2
//
//  Created by Dima on 29.04.15.
//  Copyright (c) 2015 Dima. All rights reserved.
//

#import "TPMapViewController.h"
#import "TPSaveInformationContainer.h"
#import "AppDelegate.h"
#import "TPChoosingSourceViewController.h"

@interface TPMapViewController ()

@property (strong, nonatomic) NSMutableArray *picArray;
@property (strong, nonatomic) NSMutableArray *titleArray;
@property (strong, nonatomic) NSMutableArray *coordinateAnnotationArrayLat;
@property (strong, nonatomic) NSMutableArray *coordinateAnnotationArrayLong;
@property (strong, nonatomic) NSMutableArray *annotationsArrayForMap;
@property (nonatomic, nonatomic) CLLocationCoordinate2D locCoordMapViewController;
@property (nonatomic, nonatomic) UIAlertView* isCreateAnnotationAlert;
@property (nonatomic, nonatomic) CGPoint point;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (weak, nonatomic) UIBarButtonItem *btChangeType;
@property (weak, nonatomic) UIBarButtonItem *btNew;
@property (weak, nonatomic) IBOutlet UIToolbar *mapToolBar;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *mapToolBarItem;

- (void)MapType;
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;

@end

@implementation TPMapViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [TPSaveInformationContainer sharedManager].annotationsImage = nil;
    [self.navigationController setNavigationBarHidden:NO];
    self.picArray = [[NSMutableArray alloc] init];
    self.titleArray = [[NSMutableArray alloc] init];
    self.coordinateAnnotationArrayLat = [[NSMutableArray alloc] init];
    self.coordinateAnnotationArrayLong = [[NSMutableArray alloc] init];
    self.annotationsArrayForMap = [[NSMutableArray alloc] init];

    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"AnnotationStore" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    NSManagedObject *matches = nil;
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    
    if([objects count] == 0){
        
        NSLog(@"No matches");
    }
    else{
        
        for(int i = 0; i < [objects count]; i++){
            
            matches = objects[i];
            [self.titleArray addObject:[matches valueForKey:@"name"]];
            [self.picArray addObject: [UIImage imageWithData:[matches valueForKey:@"picture"]]];
            [self.coordinateAnnotationArrayLat addObject:[matches valueForKey:@"coordinateLat"]];
            [self.coordinateAnnotationArrayLong addObject:[matches valueForKey:@"coordinateLong"]];
        }
    }
    for(int i = 0; i < [self.coordinateAnnotationArrayLat count]; i++){
        
        if([self.coordinateAnnotationArrayLat count] == 0){
            
            NSLog(@"No matches NUMAnnotationArray");
            break;
        }
        else{
            
            TPAnnotationView *AV = [TPAnnotationView new];
            AV.title = self.titleArray[i];
            AV.image = self.picArray[i];
            CLLocationCoordinate2D coord;
            coord.latitude = (CLLocationDegrees)[self.coordinateAnnotationArrayLat[i] doubleValue];
            coord.longitude = (CLLocationDegrees)[self.coordinateAnnotationArrayLong[i] doubleValue];
            AV.coordinate = coord;
            [_mapView addAnnotation:AV];
        }
    }

    _mapView.delegate = self;
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;

    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager startUpdatingLocation];
    
    // create the region
    MKCoordinateRegion Region;
    
    //Center
    CLLocationCoordinate2D center;
    center.latitude = WIMB_LATITUDE;
    center.longitude = WINB_LONGITUDE;
    
    //Span
    MKCoordinateSpan span;
    span.latitudeDelta = THE_SPAN;
    span.longitudeDelta = THE_SPAN;
    Region.center = center;
    Region.span = span;
    
    // Set on Map
    _mapView.showsUserLocation = YES;
    [_mapView setMapType: MKMapTypeSatellite];
    [_mapView setRegion:Region animated:YES];
    [_mapView setScrollEnabled: YES];

    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
    [self.mapView addGestureRecognizer:longPressGesture];
    self.mapToolBarItem = [[UIBarButtonItem alloc]initWithTitle:@"Map Type"style: UIBarButtonItemStylePlain target:self action: @selector(MapType)];
    [self.mapToolBar setHidden:NO];
    [self.mapToolBar setBarStyle: UIBarStyleBlackOpaque];
    [self.mapToolBar setItems:[NSArray arrayWithObjects:_mapToolBarItem, nil] animated:YES];
    self.isCreateAnnotationAlert = [[UIAlertView alloc] initWithTitle:@"Annotation!"
                                                              message:@"Create annotation ?"
                                                             delegate:self
                                                    cancelButtonTitle:@"Yes"
                                                    otherButtonTitles:@"No", nil];
}

- (void)viewDidAppear:(BOOL)animated{

    [TPSaveInformationContainer sharedManager].annotationsImage = nil;
}

- (void)handleLongPressGesture:(UIGestureRecognizer*)sender{
    
    if (sender.state == UIGestureRecognizerStateEnded){
        
        [self.mapView removeGestureRecognizer:sender];
    }
    else{
        
        self.point = [sender locationInView:self.mapView];
        [self.isCreateAnnotationAlert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
   
    if(alertView == self.isCreateAnnotationAlert){
        
            if(buttonIndex == 0){
                
                self.locCoordMapViewController = [self.mapView convertPoint: self.point toCoordinateFromView: self.mapView];
                [TPSaveInformationContainer sharedManager].coordinateLat = [NSNumber numberWithFloat:self.locCoordMapViewController.latitude];
                [TPSaveInformationContainer sharedManager].coordinateLong = [NSNumber numberWithFloat:self.locCoordMapViewController.longitude];
                UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
                TPChoosingSourceViewController *CSVC = [mainStoryboard instantiateViewControllerWithIdentifier: @"ChoosingViewer"];
                [self.navigationController pushViewController:CSVC animated:YES];
            }
            else{
                
                return;
            }
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:(id <MKAnnotation>)annotation {
    
    TPAnnotationView *annotationOnMap = (TPAnnotationView *)annotation;
    MKAnnotationView *pinView = nil;
    
    if(annotation != mV.userLocation){
        
        NSString *defaultPinID = @"pin!";
        pinView = (MKAnnotationView *)[mV dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
        if ( pinView == nil ){
            
            pinView = [[MKAnnotationView alloc]
                       initWithAnnotation:annotation reuseIdentifier:defaultPinID];
        }
        
        pinView.canShowCallout = YES;
        UIImage * img = annotationOnMap.image;
        CGRect resizeRect;
        resizeRect.size.height = 40;
        resizeRect.size.width = 40;
        resizeRect.origin = (CGPoint){0.0f, 0.0f};
        UIGraphicsBeginImageContext(resizeRect.size);
        [img drawInRect:resizeRect];
        UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        pinView.image = resizedImage;
    }
    else{
        
        return nil;
    }
    
    return pinView;
}

- (void)MapType {
    
    UIActionSheet *actSheet = [[UIActionSheet alloc] initWithTitle:@"Map Type"
                                                          delegate:self
                                                 cancelButtonTitle:@"Cancel"
                                            destructiveButtonTitle:nil
                                                 otherButtonTitles:@"Satellite",@"Hybrid",@"Standart",nil];
    [actSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if(buttonIndex == 0){
        
        [_mapView setMapType: MKMapTypeSatellite];
    }
    else if(buttonIndex == 1){
        
        [_mapView setMapType: MKMapTypeHybrid];
    }
    else if (buttonIndex == 2){
        
        [_mapView setMapType: MKMapTypeStandard];
    }
    else{
        
        return;
    }
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    
    MKCoordinateRegion curMapRegion;
    curMapRegion.center = self.mapView.userLocation.coordinate;
    curMapRegion.span.latitudeDelta = 0.2;
    curMapRegion.span.longitudeDelta = 0.2;
    [self.mapView setRegion:curMapRegion animated:YES];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

@end
