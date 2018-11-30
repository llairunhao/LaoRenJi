//
//  ChatViewController.m
//  LaoRenJi
//
//  Created by 菲凡数据科技-iOS开发 on 2018/10/22.
//  Copyright © 2018 西汉科技. All rights reserved.
//

#import "ChatViewController.h"
#import "UIButton+Landing.h"
#import "XHAPI+API.h"
#import "XHUser.h"
#import "AudioMananger.h"
#import "ChatHUD.h"
#import "XHChat.h"
#import "ChatCell.h"
#import "DBManager+Chat.h"

@interface ChatViewController ()<AudioManangerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) AudioMananger *manager;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) ChatHUD *HUD;
@property (nonatomic, strong) NSString *playUrlString;
@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, strong) NSMutableArray<XHChat *> *chats;

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    self.title = @"留言";
    
    CGRect rect = self.view.bounds;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setBackgroundImage:[UIImage imageNamed:@"RoundedRectangle7"] forState:UIControlStateNormal];
    [button setTitle:@"按住说话" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(stopRecord) forControlEvents:UIControlEventTouchUpInside];
    [button addTarget:self action:@selector(startRecord) forControlEvents:UIControlEventTouchDown];
    [button addTarget:self action:@selector(willCancelRecord) forControlEvents:UIControlEventTouchDragExit];
    [button addTarget:self action:@selector(resumeRecord) forControlEvents:UIControlEventTouchDragEnter];
    [button addTarget:self action:@selector(didCancelRecord) forControlEvents:UIControlEventTouchUpOutside];
    
    CGSize size = [button sizeThatFits:CGSizeZero];
    size.width = MIN(size.width, CGRectGetWidth(self.view.bounds) - 24.f);
    rect.origin.y = CGRectGetHeight(rect) - size.height * 2 - 8.f - 12.f - [UIView bottomSafeAreaHeight];
    rect.origin.x = (CGRectGetWidth(rect) - size.width ) / 2;
    rect.size = size;
    button.frame = rect;
    [self.view addSubview:button];
    

    
    rect = self.view.bounds;
    rect.origin.y = [UIView topSafeAreaHeight];
    rect.size.height = CGRectGetMinY(button.frame) - 12.f - [UIView topSafeAreaHeight];
    UITableView *tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    tableView.rowHeight = 60.f;
    tableView.separatorInset = UIEdgeInsetsZero;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    tableView.tableFooterView = [[UIView alloc] init];
    _tableView = tableView;
    
    self.manager = [[AudioMananger alloc] init];
    self.manager.delegate = self;
    
    [self showLoadingHUD];
    [self refreshData];
    
    rect = button.frame;
    button = [UIButton landingButtonWithTitle:@"清空" target:self action:@selector(clearButtonClick:)];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    rect.origin.y = CGRectGetMaxY(rect) + 8.f;
    button.frame = rect;
    [self.view addSubview:button];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recvNewMessageNoti:) name:XHNewMessageNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (ChatHUD *)HUD {
    if (!_HUD) {
        _HUD = [[ChatHUD alloc] init];
        _HUD.imageView.image = [UIImage imageNamed:@"chat_hud_volume1"];
        _HUD.label.text = @"手指上滑，取消录音";
        
        CGSize size = [_HUD sizeThatFits:CGSizeZero];
        CGRect rect = CGRectZero;
        rect.origin.x = (CGRectGetWidth(self.view.bounds) - size.width) / 2;
        rect.origin.y = (CGRectGetHeight(self.view.bounds) - size.height) / 2;
        rect.size = size;
        _HUD.frame = rect;
        [self.view addSubview:_HUD];
    }
    return _HUD;
}

- (void)recvNewMessageNoti: (NSNotification *)noti {
    [self refreshData];
}

- (void)refreshData {
    WEAKSELF;
    [XHAPI listOfAudiosByToken:[XHUser currentUser].token handler:^(XHAPIResult * _Nonnull result, XHJSON * _Nonnull JSON) {
        [weakSelf hideAllHUD];
        if (result.isSuccess) {
            NSInteger chatId = [DBManager sharedInstance].lastChatId;
            NSArray *jsons = JSON.JSONArrayValue;
            NSMutableArray *array = [NSMutableArray arrayWithCapacity:jsons.count];
            for (XHJSON *json in jsons) {
                XHChat *chat = [[XHChat alloc] initWithJSON:json];
                if (chatId >= chat.chatId) {
                    continue;
                }
                [array addObject:chat];
            }
            if (array.count > 0) {
                [[DBManager sharedInstance] saveChats:array];
            }
            [weakSelf reloadData];
        }else {
            [weakSelf toast:result.message];
        }
    }];
}

- (void)reloadData {
    _chats = [[[DBManager sharedInstance] listOfChats] mutableCopy];
    [self.tableView reloadData];
}

#pragma mark-
- (void)startRecord {
   _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
    dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, 0.25 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    WEAKSELF;
    dispatch_source_set_event_handler(_timer, ^{
        [weakSelf update];
    });
    dispatch_resume(_timer);
    self.HUD.hidden = false;
    [self resumeRecord];
    [self.manager startRecord];
}

- (void)stopRecord {
    self.HUD.hidden = true;
    [self stopTimer];
    [self.manager stopRecord];
}

- (void)willCancelRecord{
    _HUD.label.text = @"松开手指，取消录音";
    _HUD.label.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.6];
}

- (void)resumeRecord {
    _HUD.label.text = @"手指上滑，取消录音";
    _HUD.label.backgroundColor = [UIColor clearColor];
}

- (void)didCancelRecord {
    self.HUD.hidden = true;
    [self stopTimer];
    [self.manager cancelRecord];
}


- (void)playRecord {
    [self.manager playAudioFromUrlString:self.playUrlString];
}

- (void)update {
    dispatch_async(dispatch_get_main_queue(), ^{
        float peak = self.manager.currentPeakPower;
        NSString *imageName;
        if (peak < -42) {
            imageName = @"chat_hud_volume1";
        }else if (peak <= -35) {
            imageName = @"chat_hud_volume2";
        }else if (peak <= -28) {
            imageName = @"chat_hud_volume3";
        }else if (peak <= -21) {
            imageName = @"chat_hud_volume4";
        }else if (peak <= -14) {
            imageName = @"chat_hud_volume5";
        }else if (peak <= -7) {
            imageName = @"chat_hud_volume6";
        }else {
            imageName = @"chat_hud_volume7";
        }
        self.HUD.imageView.image = [UIImage imageNamed:imageName];
    });
}

- (void)stopTimer {
    if (_timer) {
        dispatch_source_cancel(_timer);
        _timer = nil;
    }
}

- (void)clearButtonClick: (UIButton *)button {
    [self destructiveAlertWithTitle:@"清空留言？" message:nil confirmHandler:^(UIAlertAction * _Nonnull action) {
        if (self.chats.count > 0) {
            XHChat *chat = self.chats.firstObject;
            [[DBManager sharedInstance] synchronizeLastChatId:chat.chatId];
        }
        [[DBManager sharedInstance] removeAllChats];
        [self.chats removeAllObjects];
        [self.tableView reloadData];
    }];
}

#pragma mark- AudioManangerDelegate
- (void)recordingDidFinish:(NSString *)amrPath {
    NSData *data = [NSData dataWithContentsOfFile:amrPath];
    WEAKSELF;
    XHAPIResultHandler handler = ^(XHAPIResult * _Nonnull result, XHJSON * _Nonnull JSON) {
        if (result.isSuccess && weakSelf) {
            XHChat *chat = [[XHChat alloc] init];
            chat.videoUrlString = JSON.stringValue;
            chat.fromNickname = @"我";
            chat.status = 1;
            chat.fromAccount = [XHUser currentUser].account;
            chat.date = [NSDate date];
            [weakSelf.chats insertObject:chat atIndex:0];
            [weakSelf.tableView reloadData];
            [[DBManager sharedInstance] saveChat:chat];
        }else {
            [weakSelf toast:result.message];
        }
    };
    [XHAPI uploadAudioData:data suffix:@".amr" token:[XHUser currentUser].token handler:handler];
}


- (void)downloadRecordFileFromUrlString:(NSString *)urlString toFilePath:(NSString *)filePath {
    WEAKSELF;
    [XHAPI downloadFileFromUrlString:urlString toFilePath:filePath handler:^(XHAPIResult * _Nonnull result, XHJSON * _Nonnull JSON) {
        if (result.isSuccess) {
            [weakSelf.manager playAudioFromUrlString:urlString];
        }else {
            [weakSelf toast:result.message];
        }
    }];
}

- (void)failedToPlayFileUrlString:(NSString *)urlString error:(NSError *)error {
    [self toast:error.localizedDescription];
}

#pragma mark-
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.chats.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ChatCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bind"];
    if (!cell) {
        cell = [[ChatCell alloc] initWithReuseIdentifier:@"bind"];
    }
    XHChat *chat = self.chats[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@：", chat.fromNickname];
    cell.detailTextLabel.text = chat.dateString;
    cell.redPoint.hidden = chat.status == 1;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    XHChat *chat = self.chats[indexPath.row];
    if ([self.manager playAudioFromUrlString:chat.videoUrlString]) {
        if (chat.chatId > 0 && chat.status == 0) {
            [XHAPI updateAudioReadStateById:chat.chatId handler:nil];
            [[DBManager sharedInstance] updateChatStatusById:chat.chatId];
        }
        chat.status = 1;
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }

    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return true;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WEAKSELF;
    UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [weakSelf.chats removeObjectAtIndex:indexPath.row];
        [weakSelf.tableView reloadData];
        [[DBManager sharedInstance] saveChats:weakSelf.chats];
    }];
    return @[action];
}

@end
