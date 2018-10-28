//
//  TraceViewController.m
//  LaoRenJi
//
//  Created by RunHao on 2018/10/27.
//  Copyright © 2018年 西汉科技. All rights reserved.
//

#import "TraceViewController.h"
#import <MAMapKit/MAMapKit.h>
#import "UIButton+Landing.h"
#import "XHAPI+API.h"
#import "XHUser.h"

@interface TraceViewController ()<MAMapViewDelegate>

@property (nonatomic, weak) MAMapView *mapView;
@property (nonatomic, weak) UILabel *timeLabel;
@property (nonatomic, weak) UIButton *prevButton;
@property (nonatomic, weak) UIButton *nextButton;


@property (nonatomic, readonly) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;

@property (nonatomic, readonly) NSString *startDateString;
@property (nonatomic, readonly) NSString *endDateString;
@property (nonatomic, readonly) NSDateFormatter *formatter;;
@end

@implementation TraceViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"轨迹";
    
    CGRect rect = self.view.bounds;
    rect.origin.y = [UIView topSafeAreaHeight];
    rect.size.height -= [UIView safeAreaHeight];
    MAMapView *mapView = [[MAMapView alloc] initWithFrame:rect];
    [self.view addSubview:mapView];
 //   mapView.showsUserLocation = false;
 //   mapView.userTrackingMode = MAUserTrackingModeFollow;
//    [mapView setCenterCoordinate:mapView.userLocation.coordinate];
    mapView.delegate = self;
    mapView.zoomLevel = 14;
    _mapView = mapView;
    
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:14];
    label.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    label.text = [NSString stringWithFormat:@"%@ ~ %@", self.startDateString, self.endDateString];
    label.textAlignment = NSTextAlignmentCenter;
    rect.size.height = 22;
    rect.size.width -= 24.f;
    rect.origin.x = 12.f;
    label.frame = rect;
    label.textColor = [UIColor whiteColor];
    [self.view addSubview:label];
    _timeLabel = label;
    
    rect = self.view.bounds;
    CGFloat buttonW = (CGRectGetWidth(self.view.bounds) - 24.f - 24.f - 12.f) / 2;
    UIButton *button = [UIButton landingButtonWithTitle:@"前一个小时" target:self action:@selector(buttonClick:)];
    [self.view addSubview:button];
    rect.origin.y = CGRectGetHeight(self.view.bounds) - 44.f - 12.f - [UIView bottomSafeAreaHeight];
    rect.origin.x = 12.f;
    rect.size.width = buttonW;
    rect.size.height = 44.f;
    button.frame = rect;
    _prevButton = button;
    
    button = [UIButton landingButtonWithTitle:@"后一个小时" target:self action:@selector(buttonClick:)];
    button.enabled = false;
    button.tag = 1;
    [self.view addSubview:button];
    rect.origin.x = CGRectGetMaxX(rect) + 12.f;
    button.frame = rect;
    _nextButton = button;
    
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
        CLLocationCoordinate2D commonPolylineCoords[array.count];
        
        for (NSInteger i = 0; i < array.count; i++) {
            commonPolylineCoords[i].latitude = [array[i] JSONForKey:@"latitude"].doubleValue;
            commonPolylineCoords[i].longitude =  [array[i] JSONForKey:@"longitude"].doubleValue;;
        }

        //构造折线对象
        MAPolyline *commonPolyline = [MAPolyline polylineWithCoordinates:commonPolylineCoords count:array.count];
        //在地图上添加折线对象
        [weakSelf.mapView addOverlay: commonPolyline];
    };
    [XHAPI listOfLocationsByToken:[XHUser currentUser].token
                        startTime:self.startDateString
                          endTime:self.endDateString
                          handler:handler];
}

- (NSDate *)endDate {
    if (!_endDate) {
        _endDate = [NSDate date];
    }
    return _endDate;
}

- (NSDate *)startDate {
    NSTimeInterval timeSP = [self.endDate timeIntervalSince1970] - 60 * 60;
    return [NSDate dateWithTimeIntervalSince1970:timeSP];
    
}

- (NSDateFormatter *)formatter {
    static NSDateFormatter *kFormatter;
    if (!kFormatter) {
        kFormatter = [[NSDateFormatter alloc] init];
        kFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
    }
    return kFormatter;
}

- (NSString *)startDateString {
    return [self.formatter stringFromDate:self.startDate];
}

- (NSString *)endDateString {
    return [self.formatter stringFromDate:self.endDate];
}

- (void)buttonClick: (UIButton *)button {
    if (button.tag == 0) {
        self.endDate = self.startDate;
        self.timeLabel.text = [NSString stringWithFormat:@"%@ ~ %@", self.startDateString, self.endDateString];
        _nextButton.enabled = true;
    }else {
        NSTimeInterval timeSP = [self.endDate timeIntervalSince1970] + 60 * 60;
        self.endDate = [NSDate dateWithTimeIntervalSince1970:timeSP];
        timeSP +=  60 * 60;
        button.enabled = timeSP < [[NSDate date] timeIntervalSince1970];
    }
    [self refreshData];
}

@end
