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
#import "UIButton+Landing.h"
#import "NSString+Valid.h"

@interface FenceViewController ()<MAMapViewDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, AMapSearchDelegate>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) UITextField *centerTF;
@property (nonatomic, weak) UITextField *radiusTF;

@property (nonatomic, strong) AMapSearchAPI *search;
@property (nonatomic, strong) NSArray<AMapPOI *> *pois;

@property (nonatomic, weak) MAMapView *mapView;
@property (nonatomic, strong) XHFence *fence;
@property (nonatomic, weak) FenceRadiusSlider *slider;
@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *address;
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
                weakSelf.address = regeocode.formattedAddress;
                [weakSelf draw];
            }
        }
    }];
    
    
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    
    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.titleLabel.font = [UIFont systemFontOfSize:16];
//    [button setTitle:@"搜索" forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(searchButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.navigationBar addRigthItem:button];
    
    CGRect rect = self.view.bounds;
    rect.origin.y = [UIView topSafeAreaHeight];
    rect.size.height -= [UIView safeAreaHeight];
    MAMapView *mapView = [[MAMapView alloc] initWithFrame:rect];
    [self.view addSubview:mapView];
    [mapView setCenterCoordinate:mapView.userLocation.coordinate];
    mapView.delegate = self;
    _mapView = mapView;
    
//    rect.size.height = 80;
//    rect.origin.y = CGRectGetHeight(self.view.bounds) - [UIView bottomSafeAreaHeight] - CGRectGetHeight(rect);
//    FenceRadiusSlider *slider = [[FenceRadiusSlider alloc] initWithFrame:rect];
//    slider.minValue = 20;
//    slider.maxValue = 5000;
//    _slider = slider;
//    UNSAFESELF;;
//    slider.handler = ^(NSInteger i) {
//        unsafeSelf.fence.radius = i;
//        [unsafeSelf draw];
//        [unsafeSelf updateFence];
//    };
//    [self.view addSubview:slider];
    
    [self showLoadingHUD];
    XHAPIResultHandler handler = ^(XHAPIResult * _Nonnull result, XHJSON * _Nonnull JSON) {
        [weakSelf hideAllHUD];
        if (result.isSuccess) {
            weakSelf.fence = [[XHFence alloc] initWithJSON:JSON];
            weakSelf.centerTF.text = weakSelf.fence.name;
            weakSelf.radiusTF.text = [@(weakSelf.fence.radius) stringValue];
//            weakSelf.slider.value = weakSelf.fence.radius;
//            if (weakSelf.fence.radius < weakSelf.slider.minValue) {
//                weakSelf.fence.radius = weakSelf.slider.minValue;
//            }else if (weakSelf.fence.radius > weakSelf.slider.maxValue) {
//                weakSelf.fence.radius = weakSelf.slider.maxValue;
//            }
            [weakSelf draw];
        }else {
            [weakSelf toast:result.message];
        }
    };
    [XHAPI getDeviceFenceByToken:[XHUser currentUser].token
                         handler:handler];
    
    [self setupHeaderView];
}



- (void)setupHeaderView {
    
    CGRect rect = self.view.bounds;
    rect.origin.y = [UIView topSafeAreaHeight];
    rect.size.height = 112;
    UIView *bgView = [[UIView alloc] initWithFrame:rect];
    bgView.backgroundColor = [UIColor C7];
    [self.view addSubview:bgView];
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor C3];
    label.text = @"中心：";
    CGSize size = [label sizeThatFits:CGSizeZero];
    rect.size = size;
    rect.size.height = 50;
    rect.origin.x = 4;
    rect.origin.y = [UIView topSafeAreaHeight] + 4;
    label.frame = rect;
    [self.view addSubview:label];
    
    label = [[UILabel alloc] init];
    label.textColor = [UIColor C3];
    label.text = @"半径：";
    rect.origin.y = CGRectGetMaxY(rect) + 4;
    label.frame = rect;
    [self.view addSubview:label];
    
    
    UIButton *button = [UIButton landingButtonWithTitle:@"选择" target:self action:@selector(buttonClick:)];
    button.tag = 0;
    size = [button sizeThatFits:CGSizeZero];
    rect.origin.y = [UIView topSafeAreaHeight] + 8;
    rect.origin.x = CGRectGetWidth(self.view.bounds) - 4 - 80;
    rect.size.width = 80;
    rect.size.height = 44;
    button.frame = rect;
    [self.view addSubview:button];
    
    button = [UIButton landingButtonWithTitle:@"设置" target:self action:@selector(buttonClick:)];
    size = [button sizeThatFits:CGSizeZero];
    rect.origin.y = CGRectGetMaxY(rect) + 8;
    button.frame = rect;
    [self.view addSubview:button];
    
    rect.origin.x = CGRectGetMaxX(label.frame);
    rect.size.width = CGRectGetMinX(button.frame) - CGRectGetMaxX(label.frame) - 10;
    rect.size.height = 50.f;
    rect.origin.y = [UIView topSafeAreaHeight] + 4;
    UITextField *textField = [[UITextField alloc] initWithFrame:rect];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:textField];
    [self.view addSubview:textField];
    self.centerTF = textField;
    

    
    
    rect.origin.y = CGRectGetMaxY(rect) + 4;
    rect.size.height = 50.f;
    rect.size.width -= 80.f;
    textField = [[UITextField alloc] initWithFrame:rect];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.delegate = self;
    textField.tag = 1;
    [self.view addSubview:textField];
    self.radiusTF = textField;
    
    label = [[UILabel alloc] init];
    label.textColor = [UIColor C3];
    label.text = @"米";
    rect.origin.x = CGRectGetMaxX(rect) + 4;
    rect.size.width = 20.f;
    label.frame = rect;
    [self.view addSubview:label];
    
    
    rect = textField.frame;
    rect.origin.y = CGRectGetMinY(rect) - 4;
    rect.size.height = CGFLOAT_MIN;
    rect.size.width = CGRectGetMaxX(button.frame) - CGRectGetMinX(rect);
    UITableView *tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    tableView.rowHeight = 44.f;
    tableView.separatorInset = UIEdgeInsetsZero;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    // tableView.tableFooterView = [[UIView alloc] init];
    _tableView = tableView;
 
    
}

- (void)updateFence {
    
    NSString *name = self.centerTF.text;
    NSInteger radius = [self.radiusTF.text integerValue];
    
    if (name.length == 0) {
        [self toast:@"请设置中心点"];
        return;
    }
    if (radius == 0) {
        [self toast:@"请设置正确半径"];
        return;
    }
    
    self.fence.radius = radius;
    self.fence.name = name;
    
    [self showLoadingHUD];
    
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
                          radius:radius
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
//    self.fence.longitude = coordinate.longitude;
//    self.fence.latitude = coordinate.latitude;
//    [self draw];
//    [self updateFence];
    if (self.centerTF.isEditing) {
        [self.centerTF resignFirstResponder];
    }else {
        [self hideTableView];
    }
    [self.radiusTF resignFirstResponder];
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


- (void)buttonClick: (UIButton *)button {
    [self updateFence];
    [self draw];
    [self.centerTF resignFirstResponder];
    [self.radiusTF resignFirstResponder];
}


- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField.tag == 0) {
        [self showTableView];
    }else {
        [self hideTableView];
    }
}


- (void)textFieldTextDidChange: (NSNotification *)noti {
    UITextField *textField = noti.object;
    [self searchText:textField.text];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField.tag == 0) {
        return true;
    }
    if (range.length == 1) {
        return true;
    }
    if (range.location == 0 && [string isEqualToString:@"0"]) {
        return false;
    }
    return [string isNumberOnly];
}

- (void)showTableView {
    CGRect rect = self.tableView.frame;
    rect.size.height = CGRectGetHeight(self.view.bounds) - [UIView bottomSafeAreaHeight] - CGRectGetMinY(rect);
    [UIView animateWithDuration:0.25 animations:^{
        self.tableView.frame = rect;
    }];
}

- (void)hideTableView {
    CGRect rect = self.tableView.frame;
    rect.size.height = CGFLOAT_MIN;
    [UIView animateWithDuration:0.25 animations:^{
        self.tableView.frame = rect;
    }];
}

#pragma mark-
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.pois.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    NSString *identifier =  @"sb";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = self.pois[indexPath.row].name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    AMapPOI *poi = self.pois[indexPath.row];
    self.fence.longitude = poi.location.longitude;
    self.fence.latitude = poi.location.latitude;
    self.address = poi.name;
    self.centerTF.text = poi.name;
    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(poi.location.latitude, poi.location.longitude)];
    [self draw];
    [self hideTableView];
    [self.centerTF resignFirstResponder];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.centerTF resignFirstResponder];
}


- (void)searchText:(NSString *)text {
    AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
    request.keywords            = text;
    request.city                = self.city;
    //    request.types               = @"住宅";
    request.requireExtension    = YES;
    
    /*  搜索SDK 3.2.0 中新增加的功能，只搜索本城市的POI。*/
    //    request.cityLimit           = YES;
    request.requireSubPOIs      = YES;
    
    [self.search AMapPOIKeywordsSearch:request];
}

/* POI 搜索回调. */
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    if (response.pois.count == 0)
    {
        return;
    }
    self.pois = response.pois;
    [self.tableView reloadData];
    //解析response获取POI信息，具体解析见 Demo
}



@end
