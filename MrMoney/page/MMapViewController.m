//
//  MMapViewController.m
//  MrMoney
//
//  Created by xingyong on 14-3-5.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MMapViewController.h"
#import "MPointAnnotation.h"
#import "MPlaceData.h"
@interface MMapViewController ()<UIAlertViewDelegate>
@property(nonatomic,strong) NSString *location;
@end

@implementation MMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [self createNavBarTitle:_navTitle];
    
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    
    //开启GPS
    if(CLLocationManager.locationServicesEnabled) {
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;//设定为最佳精度
        _locationManager.distanceFilter = 5.0f;//响应位置变化的最小距离(m)
        [_locationManager startUpdatingLocation];
    }
    
    self.mapView.showsUserLocation = YES;
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    
    newLocCoordinate = [newLocation coordinate];
	double lat = newLocCoordinate.latitude;
	double lng	= newLocCoordinate.longitude;
    
    MKUserLocation *userLocation = self.mapView.userLocation;
    userLocation.title = @"我的位置";
    [self.mapView addAnnotation:userLocation];
    
    
    self.location = STRING_FORMAT(@"%f,%f",lat,lng);
    
    MKCoordinateSpan span;
    span.latitudeDelta=0.02;
    span.longitudeDelta=0.02;
    MKCoordinateRegion region={newLocCoordinate,span};
    
    [self.mapView setRegion:region];
    
    
    if (self.location) {

        [manager stopUpdatingLocation];
        lbsAction = [[MBaiduLbsAction alloc] init];
        lbsAction.m_delegate = self;
        [lbsAction requestAction];
        [self showHUD];
    }
 
//    NSLog(@"-------------------------------%f \n\n",lat);
//    NSLog(@"-------------------------------%@ \n\n",self.location);
}
-(NSDictionary*)onRequestBaiduLbsAction{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:8];
    [dict setSafeObject:@"d1UKT0LyztD6n4jspbiMfCtT" forKey:@"ak"];
    [dict setSafeObject:@"json" forKey:@"output"];
    [dict setSafeObject:_navTitle forKey:@"query"];
    [dict setSafeObject:self.location forKey:@"location"];
    [dict setSafeObject:[NSNumber numberWithInt:1000] forKey:@"radius"];
    [dict setSafeObject:[NSNumber numberWithInt:0] forKey:@"page_num"];
    [dict setSafeObject:[NSNumber numberWithInt:10] forKey:@"page_size"];
    [dict setSafeObject:[NSNumber numberWithInt:1] forKey:@"scope"];
    return dict;
}

-(void)onResponseBaiduLbsActionSuccess:(NSMutableArray *)dataArray{

    [self hideHUD];
    
    self.dataArray = dataArray;
    
    for (int i = 0 ; i< [self.dataArray count]; i++) {
        MPlaceData *place = [self.dataArray safeObjectAtIndex:i];
        
        MPointAnnotation *item = [[MPointAnnotation alloc]initWithLocation:CLLocationCoordinate2DMake(place.mlat,place.mlng)];
        item.tag = i ;
        item.title = place.mname;
        item.subtitle = place.maddress;
        [self.mapView addAnnotation:item];
        
        [self.mapView setRegion:MKCoordinateRegionMake(item.coordinate, MKCoordinateSpanMake(0.02,0.02))];
        [self.mapView selectAnnotation:item animated:YES];
    }
    
    
}
-(void)onResponseBaiduLbsActionFail{
    [self hideHUD];
}
 
#pragma mark 标注
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    //判断是否为当前设备位置的annotation
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        //返回nil，就使用默认的标注视图
        return nil;
    }
    
    static NSString *identifier = @"Annotation";
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    if (annotationView == nil) {
        
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        
        //设置是否显示标题视图
        annotationView.canShowCallout = YES;
        
        //设置大头针的颜色
        annotationView.pinColor = MKPinAnnotationColorRed;
        //从天上落下的动画
        annotationView.animatesDrop = YES;
        
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
 
        annotationView.rightCalloutAccessoryView = rightBtn;
 
        
    }else {
        annotationView.annotation = annotation;
    }
    
    
    return annotationView;
    
}

 
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    if ([view.annotation isKindOfClass:[MPointAnnotation class]]) {
        
        MPointAnnotation *pointAnimation = (MPointAnnotation *)view.annotation;
        MPlaceData *place = [self.dataArray safeObjectAtIndex:pointAnimation.tag];
        NSString *phone = place.mtelephone;
        
        if ([phone isEqualToString:@""]) {
            [MActionUtility showAlert:@"暂无电话号码"];
            return ;
        }
        [MActionUtility showAlert:@"呼叫" message:phone delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
        
    }
    
}
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    
    if ([view isKindOfClass:[MKPinAnnotationView class]]) {
        
        [mapView setCenterCoordinate:view.annotation.coordinate animated:YES];
        
    }
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        
        NSString *phone = STRING_FORMAT(@"tel://%@",alertView.message);
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phone]];
        
             }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
