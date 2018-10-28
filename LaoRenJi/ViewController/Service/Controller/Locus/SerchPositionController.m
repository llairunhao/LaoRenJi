//
//  SerchPositionController.m
//  LaoRenJi
//
//  Created by RunHao on 2018/10/27.
//  Copyright © 2018年 西汉科技. All rights reserved.
//

#import "SerchPositionController.h"
#import "XHNavigationSearchBar.h"
#import <AMapSearchKit/AMapSearchKit.h>

@interface SerchPositionController()<XHNavigationSearchBarDelegate,UITableViewDelegate, UITableViewDataSource, AMapSearchDelegate>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) UITextField *textField;

@property (nonatomic, strong) AMapSearchAPI *search;
@property (nonatomic, strong) NSArray<AMapPOI *> *pois;

@end

@implementation SerchPositionController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationBar removeFromSuperview];
    XHNavigationSearchBar *searchBar = [[XHNavigationSearchBar alloc] init];
    searchBar.cancelButtonHidden = false;
    searchBar.backButtonHidden = true;
    searchBar.delegate = self;
    self.textField = searchBar.textField;
    [self.safeNavigationBar addSubview:searchBar];
    
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    
    CGRect rect = self.view.bounds;
    rect.origin.y = [UIView topSafeAreaHeight];
    rect.size.height -= [UIView safeAreaHeight];
    UITableView *tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    tableView.rowHeight = 44.f;
    tableView.separatorInset = UIEdgeInsetsZero;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    tableView.tableFooterView = [[UIView alloc] init];
    _tableView = tableView;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:self.textField];
}

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
    self.selectHandler(self.pois[indexPath.row]);
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)searchDidCancel {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)textFieldDidChange: (NSNotification *)noti {
    [self searchText: self.textField.text];
}

- (void)searchText:(NSString *)text {
    AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
    request.keywords            = text;
    request.city                = @"深圳";
    request.types               = @"住宅";
    request.requireExtension    = YES;
    
    /*  搜索SDK 3.2.0 中新增加的功能，只搜索本城市的POI。*/
    request.cityLimit           = YES;
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
    NSLog(@"%@", response.pois);
    self.pois = response.pois;
    [self.tableView reloadData];
    //解析response获取POI信息，具体解析见 Demo
}

@end
