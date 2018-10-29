//
//  XHLiveEvent.h
//  LaoRenJi
//
//  Created by RunHao on 2018/10/13.
//  Copyright © 2018年 西汉科技. All rights reserved.
//

#import <pgDybLiveMulti/pgDybLiveMulti.h>

NS_ASSUME_NONNULL_BEGIN

@protocol XHLiveEventDelegate <NSObject>

-(void)OnEvent:(NSString*)sAction
          data:(NSString*)sData
        render:(NSString*)sRender;

@end

@interface XHLiveEvent : pgLibLiveEvent

@property (nonatomic, weak)id<XHLiveEventDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
