//
//  LVPDFDrawManager.m
//  CoreTextDemo
//
//  Created by Levi on 2021/1/8.
//

#import "LVPDFDrawManager.h"


@implementation LVPDFDrawManager

+ (instancetype)sharedInstance
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)drawEmptySquareWithCGRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat components[] = {10,5};
    CGContextSetLineDash(context, 0, components, 0);
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextSetLineWidth(context, 1.0);
    CGContextAddRect(context, rect);
    CGContextStrokePath(context);
}

- (void)drawSquareWithCGRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(context, 193.0/255.0, 193.0/255.0,193.0/255.0, 1.0);
    CGContextFillRect(context, rect);
    CGContextStrokePath(context);
}

- (void)printStr:(NSString *)printStr
          CGRect:(CGRect)rect
            Font:(CGFloat)font
    fontWithName:(NSString *)fontName
     lineSpacing:(CGFloat)lineSpacing
   lineBreakMode:(NSLineBreakMode)lineBreakMode
       alignment:(NSTextAlignment)alignment
{
    UIFont *Font = [UIFont fontWithName:fontName size:font];
    NSMutableParagraphStyle* paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = lineBreakMode;
    paragraphStyle.alignment = alignment;
    if (lineSpacing > 0) {
        paragraphStyle.lineSpacing = lineSpacing;
    }    NSDictionary *attribute = @{
                               NSFontAttributeName:Font,
                               NSParagraphStyleAttributeName:paragraphStyle
                               };
    [printStr drawWithRect:rect options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil];
}

- (void)printStr:(NSString *)printStr
          CGRect:(CGRect)rect
            Font:(CGFloat)font
   lineBreakMode:(NSLineBreakMode)lineBreakMode
       alignment:(NSTextAlignment)alignment
{
    [self printStr:printStr CGRect:rect Font:font fontWithName:@"STSong" lineSpacing:0.0f lineBreakMode:lineBreakMode alignment:alignment];

}


- (void)printStr:(NSString *)printStr
          CGRect:(CGRect)rect
            Font:(CGFloat)font
     lineSpacing:(CGFloat)lineSpacing
   lineBreakMode:(NSLineBreakMode)lineBreakMode
       alignment:(NSTextAlignment)alignment
{
    [self printStr:printStr CGRect:rect Font:font fontWithName:@"STSong" lineSpacing:lineSpacing lineBreakMode:lineBreakMode alignment:alignment];
}

- (void)drawLineFromPoint:(CGPoint)from toPoint:(CGPoint)to
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextSetLineWidth(context, 1.0);
    CGContextMoveToPoint(context, from.x, from.y);
    CGContextAddLineToPoint(context, to.x, to.y);
    CGContextStrokePath(context);
}


- (void)drawDashLineFromPoint:(CGPoint)from toPoint:(CGPoint)to
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    CGContextSetLineWidth(context, 2.0);
    CGFloat components[] = {10,5};
    CGContextSetLineDash(context, 0, components, 2);
    CGContextMoveToPoint(context, from.x, from.y);
    CGContextAddLineToPoint(context, to.x, to.y);
    CGContextStrokePath(context);
}


@end
