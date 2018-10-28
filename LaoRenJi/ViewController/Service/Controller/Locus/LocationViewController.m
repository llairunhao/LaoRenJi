//
//  LocationViewController.m
//  LaoRenJi
//
//  Created by RunHao on 2018/10/27.
//  Copyright © 2018年 西汉科技. All rights reserved.
//

#import "LocationViewController.h"
#import <MAMapKit/MAMapKit.h>

@interface LocationViewController ()
{
    __weak MAMapView *_mapView;
}
@end

@implementation LocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    CGRect rect = self.view.bounds;
    rect.origin.y = [UIView topSafeAreaHeight];
    rect.size.height -= [UIView safeAreaHeight];
    MAMapView *mapView = [[MAMapView alloc] initWithFrame:rect];
    [self.view addSubview:mapView];
    _mapView = mapView;
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
