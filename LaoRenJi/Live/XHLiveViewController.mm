//
//  XHLiveViewController.m
//  LaoRenJi
//
//  Created by RunHao on 2018/10/13.
//  Copyright © 2018年 西汉科技. All rights reserved.
//

#import "XHLiveViewController.h"
#import "pgDybLiveMulti/pgLibLive.h"
#import "XHLiveEvent.h"

@interface XHLiveViewController ()
{
    pgLibLive *_live;
    XHLiveEvent *_liveEvent;
}
@end

@implementation XHLiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _liveEvent = [[XHLiveEvent alloc] init];
    _live = [[pgLibLive alloc] init:_liveEvent];
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
