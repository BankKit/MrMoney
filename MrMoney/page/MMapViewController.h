//
//  MMapViewController.h
//  MrMoney
//
//  Created by xingyong on 14-3-5.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MBaseViewController.h"
#import <MapKit/MapKit.h>
#import "MBaiduLbsAction.h"

@interface MMapViewController : MBaseViewController<MKMapViewDelegate,CLLocationManagerDelegate,MBaiduLbsActionDelegate>{
    
    CLLocationCoordinate2D  newLocCoordinate;
    MBaiduLbsAction *lbsAction;
   
}
@property (nonatomic,weak) IBOutlet MKMapView* mapView;
@property(nonatomic,copy)NSString *navTitle;
@property (nonatomic,strong)CLLocationManager *locationManager;
@end
