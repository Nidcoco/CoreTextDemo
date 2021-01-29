//
//  LVRoadCasePrint.h
//  CoreTextDemo
//
//  Created by Levi on 2021/1/8.
//

#import <Foundation/Foundation.h>
#import "LVPDFDrawManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface LVRoadCasePrint : NSObject

/**
 *  @brief  勘验笔录
 *
 *  @param data 数据
 */
- (void)drawInquestRecordAction:(NSDictionary * _Nullable)data;

/**
 *  @brief  现场笔录
 *
 *  @param data 数据
 */
- (void)drawSiteRecordAction:(NSDictionary * _Nullable)data;


@end

NS_ASSUME_NONNULL_END
