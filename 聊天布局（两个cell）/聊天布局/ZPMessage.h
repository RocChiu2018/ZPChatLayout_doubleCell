//
//  ZPMessage.h
//  聊天布局
//
//  Created by apple on 16/6/1.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    messageTypeMe = 0,
    messageTypeOther = 1
}messageType;

@interface ZPMessage : NSObject

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, assign) messageType type;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) BOOL isHideTime;

+ (instancetype)messageWithDict:(NSDictionary *)dict;

@end
