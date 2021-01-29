//
//  LVPDFDrawManager.h
//  CoreTextDemo
//
//  Created by Levi on 2021/1/8.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LVPDFDrawManager : NSObject

+ (instancetype)sharedInstance;

/**
 *  @brief 空心矩形
 *
 *  @param rect 空心矩形的frame
 */
- (void)drawEmptySquareWithCGRect:(CGRect)rect;
/**
 *  @brief 无边框有背景颜色的矩形
 *
 *  @param rect 矩形的frame
 */
- (void)drawSquareWithCGRect:(CGRect)rect;

/**
 *  @brief 文字，系统默认的中文字体是苹方，默认的英文字体是Helvetica，可以指定其他中文字体，要去字体册或者网上拷贝ttf文件进来项目还要在info.plist配置
 *
 *  @param printStr 绘制的文字
 *  @param rect 文字frame
 *  @param fontName 文字字体
 *  @param lineSpacing 文字行间距
 *  @param lineBreakMode 文字过长时的显示格式
 *  @param alignment 文字对齐方式
 */
- (void)printStr:(NSString *)printStr
          CGRect:(CGRect)rect
            Font:(CGFloat)font
    fontWithName:(NSString *)fontName
     lineSpacing:(CGFloat)lineSpacing
   lineBreakMode:(NSLineBreakMode)lineBreakMode
       alignment:(NSTextAlignment)alignment;
/**
 *  @brief 文字，默认宋体，系统默认行间距
 *
 *  @param printStr 绘制的文字
 *  @param rect 文字frame
 *  @param lineBreakMode 文字过长时的显示格式
 *  @param alignment 文字对齐方式
 */
- (void)printStr:(NSString *)printStr
          CGRect:(CGRect)rect
            Font:(CGFloat)font
   lineBreakMode:(NSLineBreakMode)lineBreakMode
       alignment:(NSTextAlignment)alignment;
/**
 *  @brief 文字，默认宋体
 *
 *  @param printStr 绘制的文字
 *  @param rect 文字frame
 *  @param lineSpacing 文字行间距
 *  @param lineBreakMode 文字过长时的显示格式
 *  @param alignment 文字对齐方式
 */
- (void)printStr:(NSString *)printStr
          CGRect:(CGRect)rect
            Font:(CGFloat)font
     lineSpacing:(CGFloat)lineSpacing
   lineBreakMode:(NSLineBreakMode)lineBreakMode
       alignment:(NSTextAlignment)alignment;

/**
 *  @brief 两点坐标相连画线,高度1像素
 *
 *  @param from 起始坐标
 *  @param to 结束坐标
 */
- (void)drawLineFromPoint:(CGPoint)from toPoint:(CGPoint)to;
/**
 *  @brief 两点坐标相连画虚线,高度2像素
 *
 *  @param from 起始坐标
 *  @param to 结束坐标
 */
- (void)drawDashLineFromPoint:(CGPoint)from toPoint:(CGPoint)to;

@end

NS_ASSUME_NONNULL_END
