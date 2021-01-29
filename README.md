![](https://upload-images.jianshu.io/upload_images/12618366-908a8fdeb32a6874.jpeg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

> 需求: 移动端绘制PDF页面, 获取数据进行填充, 然后通过隔空打印打印出来，以下内容只根据我所做具体内容进行讲解，如有不对，还请不吝指教

# 一、基础步骤
* 指定PDF文件保存路径
* 创建以指定路径为目标的PDF文件，开启PDF图形上下文
* 开启绘制，绘制内容
* 关闭PDF图形上下文
* 展示
```
// 指定PDF文件保存路径
NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
NSString *pathPDF =  [documentPath stringByAppendingPathComponent:@"绘制.pdf"];
// 创建以指定路径为目标的PDF图形上下文，这里我们pathPDF路径下已经得到一个名叫绘制.pdf文件，不过没有内容
UIGraphicsBeginPDFContextToFile(pathPDF, CGRectZero, NULL);
// 在PDF上下文中标记新页面的开始，PDF文档是分页的，开启一页文档绘制调用这个方法一次，也可以用UIGraphicsBeginPDFPageWithInfo(CGRect bounds, NSDictionary * __nullable pageInfo)指定PDF的大小，方便绘制
UIGraphicsBeginPDFPage();

/*
* 绘制内容的代码，具体下面会说
*/

// 关闭PDF图形上下文并从当前上下文堆栈中弹出它
UIGraphicsEndPDFContext();

/*
* 到这里绘制.pdf那个文件上面是有内容的 ，如果要展示到App内可以有以下几种方式
* PDF文档预览的几种方式
* UIWebView 
* QLPreviewController
* UIDocumentInteractionController
* CGContexDrawPDFPage
* 具体怎么使用可以移步https://www.jianshu.com/p/95168c23fb39
*/
// 将绘制好的PDF文件展示到UIWebView
UIWebView *webView  = [[UIWebView alloc]initWithFrame:self.view.bounds];
webView.scalesPageToFit = YES;
NSURL *url = [NSURL fileURLWithPath:pathPDF];  
[self.webView loadRequest:[NSURLRequest requestWithURL:url]];
[self.view addSubview webView];

```

![效果图](https://upload-images.jianshu.io/upload_images/12618366-17285412b4f16927.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

# 二、绘制内容
主要是文字，下划线，外边框的绘制

* 导入第三方字体
系统默认的中文字体是苹方，不是Helvetica，默认的英文字体才是Helvetica，有些文章说默认字体字体是Helvetica，我打开Mac自带的字体册看到Helvetica根本不支持中文。使用其他字体可以去字体册找，右键去Finder位置找到ttc或者ttf的文件，导入工程，导入的时候要勾选`Add to targets`，还要在info.plist文件里面配置的。具体如下图
![](https://upload-images.jianshu.io/upload_images/12618366-d512d838fd00554f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
![](https://upload-images.jianshu.io/upload_images/12618366-c8f732783d2be76f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

  字体册有些有的，有些有但是无法前往Finder里面找到文件，可能是版权问题。
注意：如果发现字体没什么变化，可能是fontName搞错了，`fontName不是ttc/ttf文件名`，比如Songti.ttc的文件，一个文件包含了三种字体，也就是三个fontName：STSong（华文宋体）、STSongti-SC（宋体-简）、STSongti-TC（宋体-繁）,如果实在字体册里面，可以看PostScript名称，实在不知道可以xib或者storyboard里面找个label看下Font属性里面的Custom的Family里面找，或者用代码直接打印出来所有fontName。


![](https://upload-images.jianshu.io/upload_images/12618366-dd329daf919f4cae.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
![](https://upload-images.jianshu.io/upload_images/12618366-ee1e8ce17ecd7f82.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

```
// 打印
 NSArray *fontFamilys = [UIFont familyNames];
 for (NSString *familyName in fontFamilys) {
     NSLog(@"family name : %@",familyName);
     NSArray *fontNames = [UIFont fontNamesForFamilyName:familyName];
     for (NSString *fontName in fontNames) {
         NSLog(@"font name : %@",fontName);
     }
 }
```

```
// 使用
UIFont *font = [UIFont fontWithName:@"STSong" size:FONT];
```


* 绘制文字
由于我这边绘制的内容绘制的文字只要分为三种，一种是标题的黑体加粗苹方，一种是正文的宋体，还有一种是表格里面宋体，由于宽度有限，会换行，行间距要指定大小，所以进行了如下封装
```
/**
 *  @brief 文字，系统默认的中文字体是苹方，默认的英文字体是Helvetica，可以指定其他中文字体
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
```

```
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
```


* 绘制横线
```
/**
 *  @brief 两点坐标相连画线,高度1像素
 *
 *  @param from 起始坐标
 *  @param to 结束坐标
 */
- (void)drawLineFromPoint:(CGPoint)from toPoint:(CGPoint)to;
```

```
- (void)drawLineFromPoint:(CGPoint)from toPoint:(CGPoint)to
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextSetLineWidth(context, 1.0);
    CGContextMoveToPoint(context, from.x, from.y);
    CGContextAddLineToPoint(context, to.x, to.y);
    CGContextStrokePath(context);
}
```

* 绘制外边框
```
/**
 *  @brief 空心矩形
 *
 *  @param rect 空心矩形的frame
 */
- (void)drawEmptySquareWithCGRect:(CGRect)rect;
```

```
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
```
> 之后的具体代码就是不断的绘制文字，下滑线的过程，具体可以看下面的Demo

# 三、隔空打印
* 安装打印机模拟器
当然也可以用真的打印机，为了方便开发，可以安装一个[打印机模拟器](https://developer.apple.com/download/more/?name=for%20Xcode)，拉下去找一下，Hardware那个，点开点右边下载即可
![](https://upload-images.jianshu.io/upload_images/12618366-ea491b17107f3073.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
之后直接打开Printer Simulator就行了，不用用蓝牙连接什么的，iPhone或iPad弹出的苹果的打印页面会看到这个打印机模拟器，选择他们进行打印就可以模拟打印这个过程，当然他不会真的凭空变出一直纸给你
![](https://upload-images.jianshu.io/upload_images/12618366-a1f7e8de02f2c332.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

* UIPrintInteractionController

打印界面弹窗，用于管理iOS中文档，图像和其他可打印内容的类。就是隔空打印，就是用这个类搞掂的。
1. 可打印的内容
```
an array of ready-to-print images and PDF documents: 一组图片文件和PDF文件。
a single image or PDF document： 一张图片或是一个PDF文件。、
an instance of any of the built-in print formatter classes: 打印格式化者的实例。（简单文本，html文档，某些View显示的内容）。
a custom page renderer： 自定义页渲染者。
```
简单的说就是可以打印web页面，PDF，图片等等
2. UIPrintInteractionController 的属性、方法
```
@property(nullable, nonatomic, strong) UIPrintInfo *printInfo;      // 打印任务的信息，其中包括输出类型, 打印方向, 打印文件名称等等
@property(nullable, nonatomic, weak)   id<UIPrintInteractionControllerDelegate> delegate;  // 代理
@property(nonatomic) BOOL showsPageRange // 显示页码，废弃了，现在默认都显示
@property(nonatomic) BOOL showsNumberOfCopies // 打印弹窗是否显示打印份数，默认是

/*
* 以下四个属性都是用来指定打印的内容
*/
@property(nullable, nonatomic, strong) UIPrintPageRenderer *printPageRenderer;  // 根据内容的种类来布置页面内容的对象，直译
@property(nullable, nonatomic, strong) UIPrintFormatter    *printFormatter;     // 当UIKit请求时可绘制可打印内容页面的对象，直译
@property(nullable, nonatomic, copy) id printingItem;             // 单个准备打印 NSData, NSURL, UIImage 对象
@property(nullable, nonatomic, copy) NSArray *printingItems;      // 一组准备打印的 NSData, NSURL, UIImage对象

/*
* 确定可印刷性
*/
@property(class, nonatomic, readonly, getter=isPrintingAvailable) BOOL printingAvailable;   // 设备是否支持打印
+ (BOOL)canPrintURL:(NSURL *)url;      // NSURL对象引用的文件是否可以打印
+ (BOOL)canPrintData:(NSData *)data;  // NSData对象是否可以打印

/*
* 弹出弹窗界面的方法
*/
- (BOOL)presentAnimated:(BOOL)animated completionHandler:(nullable UIPrintInteractionCompletionHandler)completion;  // 官方虽然说这是iPhone用的方法，但我iPad调用这个方法也会弹窗
- (BOOL)presentFromRect:(CGRect)rect inView:(UIView *)view animated:(BOOL)animated completionHandler:(nullable UIPrintInteractionCompletionHandler)completion;    // iPad，在控制器上直接传self.view.frame, self.view即可
- (BOOL)presentFromBarButtonItem:(UIBarButtonItem *)item animated:(BOOL)animated completionHandler:(nullable UIPrintInteractionCompletionHandler)completion;      // iPad
- (void)dismissAnimated:(BOOL)animated;  // 退出打印选项表或弹出框

```
3. UIPrintInfo的属性
```
@property(nonatomic, copy) NSString *jobName;           // 打印文件名称，默认工程名字
@property(nonatomic) UIPrintInfoOutputType outputType;        // 可打印内容的种类，默认 UIPrintInfoOutputGeneral
@property(nonatomic) UIPrintInfoOrientation orientation;       // 打印内容的方向（纵向或横向），默认UIPrintInfoOrientationPortrait
@property(nonatomic) UIPrintInfoDuplex duplex;            // 用于打印作业的双面模式
```
![所有API](https://upload-images.jianshu.io/upload_images/12618366-445cf48a2003353f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


4. 默认弹窗界面
![iPad](https://upload-images.jianshu.io/upload_images/12618366-347b860c95bfd376.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
![iPhone](https://upload-images.jianshu.io/upload_images/12618366-150a84a208f2a3d2.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
Select Printer选择打印机里面有好几个都是模拟器生成的
![](https://upload-images.jianshu.io/upload_images/12618366-80f6d81433ef717e.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


5. 代码实现
只是打印PDF的代码
```
    UIPrintInteractionController *pic = [UIPrintInteractionController sharedPrintController];
    NSData *myPDFData = [NSData dataWithContentsOfFile:self.pathPDF];
    if (pic && [UIPrintInteractionController canPrintData:myPDFData]) {
        UIPrintInfo *printInfo = [UIPrintInfo printInfo];
        printInfo.outputType = UIPrintInfoOutputGeneral;
        printInfo.jobName = @"绘制.pdf";
        printInfo.duplex = UIPrintInfoDuplexLongEdge;

        pic.printInfo = printInfo;
        pic.printingItem = myPDFData;
        
        void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) = ^(UIPrintInteractionController *pic, BOOL completed, NSError *error) {
            if (!completed && error) NSLog(@"FAILED! due to error in domain %@ with error code %ld",error.domain, (long)error.code);
        };

        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//            [pic presentFromRect:self.view.frame inView:self.view animated:YES completionHandler:completionHandler];
            [pic presentFromBarButtonItem:sender animated:YES completionHandler:completionHandler];
        } else {
            //直接打印
            [pic presentAnimated:YES completionHandler:completionHandler];
        }
    }
```

[Demo地址](https://github.com/li199508/CoreTextDemo.git "Title")
> 参考: 
https://www.jianshu.com/p/7cff5d89f3ac
https://www.jianshu.com/p/95168c23fb39
https://github.com/billzbh/PNCPDFTable

