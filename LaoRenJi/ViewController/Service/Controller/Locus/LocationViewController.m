//
//  LocationViewController.m
//  LaoRenJi
//
//  Created by RunHao on 2018/10/27.
//  Copyright © 2018年 西汉科技. All rights reserved.
//

#import "LocationViewController.h"
#import <MAMapKit/MAMapKit.h>
#import "XHAPI+API.h"
#import "XHUser.h"

@interface LocationViewController ()<MAMapViewDelegate>

@property (nonatomic, weak) MAMapView *mapView;

@end

@implementation LocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"当前位置";
    CGRect rect = self.view.bounds;
    rect.origin.y = [UIView topSafeAreaHeight];
    rect.size.height -= [UIView safeAreaHeight];
    MAMapView *mapView = [[MAMapView alloc] initWithFrame:rect];
    [self.view addSubview:mapView];
    _mapView = mapView;
    mapView.delegate = self;
    [self refreshData];
    
}

- (void)refreshData {
    [self showLoadingHUD];
    WEAKSELF;
    XHAPIResultHandler handler =^(XHAPIResult * _Nonnull result, XHJSON * _Nonnull JSON) {
        [weakSelf hideAllHUD];
        if (!result.isSuccess) {
            [weakSelf toast:result.message];
            return;
        }
        NSArray<XHJSON *> *array = JSON.JSONArrayValue;
        if (array.count == 0) {
            [weakSelf toast:@"暂无数据"];
            return;
        }
  
    
        MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
        XHJSON *last = array.lastObject;
        CLLocationDegrees latitude = [last JSONForKey:@"latitude"].doubleValue;
        CLLocationDegrees longitude = [last JSONForKey:@"longitude"].doubleValue;
        pointAnnotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
        [weakSelf.mapView addAnnotation:pointAnnotation];
        [weakSelf.mapView setCenterCoordinate:pointAnnotation.coordinate];
      
    };
    [XHAPI listOfLocationsByToken:[XHUser currentUser].token
                        startTime:self.startDateString
                          endTime:self.endDateString
                          handler:handler];
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

- (NSDate *)endDate {
    return [NSDate date];
}

- (NSDate *)startDate {
    NSTimeInterval timeSP = [self.endDate timeIntervalSince1970] - 60 * 60 * 24 * 30;
    return [NSDate dateWithTimeIntervalSince1970:timeSP];
    
}

- (NSDateFormatter *)formatter {
    static NSDateFormatter *kFormatter;
    if (!kFormatter) {
        kFormatter = [[NSDateFormatter alloc] init];
        kFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    }
    return kFormatter;
}

- (NSString *)startDateString {
    return [self.formatter stringFromDate:self.startDate];
}

- (NSString *)endDateString {
    return [self.formatter stringFromDate:self.endDate];
}


@end
