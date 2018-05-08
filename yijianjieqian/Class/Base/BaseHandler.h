//
//  BaseHandler.h
//  yijianjieqian
//
//  Created by zhph on 2018/3/21.
//  Copyright © 2018年 正和普惠. All rights reserved.
//

#import <Foundation/Foundation.h>

/*成功的回调*/
typedef void(^ Success)(id Obj);
/*失败的回调*/
typedef void(^ Failed)(id Obj);

@interface BaseHandler : NSObject

/*成功之后 结束请求刷新*/
-(void)dismissTableRefresh:(UITableView*)tableView;

/*失败之后的 结束刷新*/
-(void)dismissTableRefresh:(UITableView*)tableView AlertTitle:(NSString*)title;

@end
