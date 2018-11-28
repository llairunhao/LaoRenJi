//
//  FenceViewController.m
//  LaoRenJi
//
//  Created by RunHao on 2018/10/27.
//  Copyright © 2018年 西汉科技. All rights reserved.
//

#import "FenceViewController.h"
#import <MAMapKit/MAMapKit.h>
#import "SerchPositionController.h"
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import "FenceRadiusSlider.h"
#import "XHFence.h"
#import "XHAPI+API.h"
#import "XHUser.h"
#import "XHDevice.h"

@interface FenceViewController ()<MAMapViewDelegate>

@property (nonatomic, weak) MAMapView *mapView;
@property (nonatomic, strong) XHFence *fence;
@property (nonatomic, weak) FenceRadiusSlider *slider;
@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, copy) NSString *city;

@end

@implementation FenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"围栏";
    self.locationManager = [[AMapLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.locationTimeout = 2;
    self.locationManager.reGeocodeTimeout = 2;
    
    WEAKSELF;
    [self.locationManager requestLocationWithReGeocode:true completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        if (!error) {
            weakSelf.city = regeocode.city;
            if (weakSelf.fence.latitude == 0 && weakSelf.fence.latitude == 0) {
                weakSelf.fence.latitude = location.coordinate.latitude;
                weakSelf.fence.longitude = location.coordinate.longitude;
                [weakSelf draw];
            }
        }
    }];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    [button setTitle:@"搜索" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(searchButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBar addRigthItem:button];
    
    CGRect rect = self.view.bounds;
    rect.origin.y = [UIView topSafeAreaHeight];
    rect.size.height -= [UIView safeAreaHeight];
    MAMapView *mapView = [[MAMapView alloc] initWithFrame:rect];
    [self.view addSubview:mapView];
   // mapView.showsUserLocation = true;
   // mapView.userTrackingMode = MAUserTrackingModeFollow;
    [mapView setCenterCoordinate:mapView.userLocation.coordinate];
    mapView.delegate = self;
    _mapView = mapView;
    
    rect.size.height = 80;
    rect.origin.y = CGRectGetHeight(self.view.bounds) - [UIView bottomSafeAreaHeight] - CGRectGetHeight(rect);
    FenceRadiusSlider *slider = [[FenceRadiusSlider alloc] initWithFrame:rect];
    slider.minValue = 20;
    slider.maxValue = 5000;
    _slider = slider;
    UNSAFESELF;;
    slider.handler = ^(NSInteger i) {
        unsafeSelf.fence.radius = i;
        [unsafeSelf draw];
        [unsafeSelf updateFence];
    };
    [self.view addSubview:slider];
    
    [self showLoadingHUD];
    XHAPIResultHandler handler = ^(XHAPIResult * _Nonnull result, XHJSON * _Nonnull JSON) {
        [weakSelf hideAllHUD];
        if (result.isSuccess) {
            weakSelf.fence = [[XHFence alloc] initWithJSON:JSON];
            weakSelf.slider.value = weakSelf.fence.radius;
            if (weakSelf.fence.radius < weakSelf.slider.minValue) {
                weakSelf.fence.radius = weakSelf.slider.minValue;
            }else if (weakSelf.fence.radius > weakSelf.slider.maxValue) {
                weakSelf.fence.radius = weakSelf.slider.maxValue;
            }
            [weakSelf draw];
        }else {
            [weakSelf toast:result.message];
        }
    };
    [XHAPI getDeviceFenceByToken:[XHUser currentUser].token
                         handler:handler];
}

- (void)updateFence {
    [self showLoadingHUD];
    NSString *name = [NSString stringWithFormat:@"%@的围栏", [XHUser currentUser].currentDevice.name];
    WEAKSELF;
    
    XHAPIResultHandler handler =^(XHAPIResult * _Nonnull result, XHJSON * _Nonnull JSON) {
        [weakSelf hideAllHUD];
        if (result.isSuccess) {
            [weakSelf toast:@"设置成功"];
        }else {
            [weakSelf toast:result.message];
        }
    };
    [XHAPI setDeviceFenceByToken:[XHUser currentUser].token
                       longitude:self.fence.longitude
                         latitude:self.fence.latitude
                          radius:self.fence.radius
                            name:name
                         handler:handler];
}

- (XHFence *)fence {
    if (!_fence) {
        _fence = [[XHFence alloc] init];
    }
    return _fence;
}

- (void)draw {

    if (!self.fence.isValid) {
        return;
    }
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(_fence.latitude, _fence.longitude);
    [self.mapView removeOverlays:self.mapView.overlays];
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    pointAnnotation.coordinate = coordinate;
    [self.mapView setCenterCoordinate:pointAnnotation.coordinate];

    MACircle *circle = [MACircle circleWithCenterCoordinate:pointAnnotation.coordinate radius:_fence.radius];
    [self.mapView addOverlay: circle];
    self.mapView.zoomLevel = 14;
    [self.mapView addAnnotation:pointAnnotation];
}


- (void)mapView:(MAMapView *)mapView didSingleTappedAtCoordinate:(CLLocationCoordinate2D)coordinate {
    self.fence.longitude = coordinate.longitude;
    self.fence.latitude = coordinate.latitude;
    [self draw];
    [self updateFence];
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        annotationView.highlighted = true;
        annotationView.canShowCallout= YES;       //设置气泡可以弹出，默认为NO
        annotationView.animatesDrop = YES;        //设置标注动画显示，默认为NO
        annotationView.draggable = YES;        //设置标注可以拖动，默认为NO
        annotationView.pinColor = MAPinAnnotationColorPurple;
        return annotationView;
    }
    return nil;
}

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MACircle class]])
    {
        MACircleRenderer *circleRenderer = [[MACircleRenderer alloc] initWithCircle:overlay];
        circleRenderer.lineWidth    = 1.f;
        circleRenderer.strokeColor  = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.8];
        circleRenderer.fillColor    = [[UIColor EC1] colorWithAlphaComponent:0.8];
        return circleRenderer;
    }

    return nil;
}


- (void)searchButtonClick: (UIButton *)button {
    SerchPositionController *searchController = [[SerchPositionController alloc] init];
    searchController.city = self.city;
    UNSAFESELF;
    searchController.selectHandler = ^(AMapPOI * _Nonnull poi) {
        unsafeSelf.fence.longitude = poi.location.longitude;
        unsafeSelf.fence.latitude = poi.location.latitude;
        [unsafeSelf draw];
        [unsafeSelf updateFence];
    };
    [self presentViewController:searchController animated:true completion:nil];
}

@end
