//
//  ViewController.m
//  CoreTextDemo
//
//  Created by Levi on 2021/1/5.
//

#import "ViewController.h"
#import "LVRoadCasePrint.h"

#define kScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define kScreenHeight ([UIScreen mainScreen].bounds.size.height)
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define kNavStatusBarHeight (IS_IPAD ? 70 : ([[UIApplication sharedApplication] statusBarFrame].size.height + 44))

@interface ViewController ()

@property (nonatomic, strong) UILabel *label;

@property (nonatomic,strong)UIWebView *webView;
@property (nonatomic, copy) NSString *pathPDF;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, kNavStatusBarHeight, kScreenWidth, kScreenHeight - kNavStatusBarHeight)];

    self.webView.scalesPageToFit = YES;

    [self.view addSubview:self.webView];

    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(selectRightAction:)];

    self.navigationItem.rightBarButtonItem = rightBarItem;

    [self printAlreadyWithCoreGraphics];
    
    NSURL *url1 = [NSURL fileURLWithPath:self.pathPDF];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url1]];

}

- (void)urlPrintWithUIGraphics
{
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];

    self.pathPDF =  [documentPath stringByAppendingPathComponent:@"绘制.pdf"];

    UIGraphicsBeginPDFContextToFile(self.pathPDF, CGRectZero, NULL);


    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 1240, 1754), nil);

    UIGraphicsBeginPDFPage();

    [[[LVRoadCasePrint alloc] init] drawInquestRecordAction:nil];

    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 1240, 1754), nil);

    [[[LVRoadCasePrint alloc] init] drawSiteRecordAction:nil];


    UIGraphicsEndPDFContext();

}

- (void)dataPrintWithUIGraphics
{
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];

    self.pathPDF =  [documentPath stringByAppendingPathComponent:@"绘制.pdf"];
    
    NSMutableData *data = [NSMutableData data];
    UIGraphicsBeginPDFContextToData(data, CGRectZero, NULL);
    
    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 1240, 1754), nil);

    [[[LVRoadCasePrint alloc] init] drawInquestRecordAction:nil];

    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 1240, 1754), nil);

    [[[LVRoadCasePrint alloc] init] drawSiteRecordAction:nil];

    UIGraphicsEndPDFContext();
    
    
    [data writeToFile:self.pathPDF atomically:YES];
}

- (void)urlPrintWithCoreGraphics
{
    NSString *docsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];

    self.pathPDF = [NSString stringWithFormat:@"%@/绘制.pdf",docsDirectory];

    const char *filename = [self.pathPDF UTF8String];
    
    CFStringRef path = CFStringCreateWithCString (NULL, filename, kCFStringEncodingUTF8);
    CFURLRef url = CFURLCreateWithFileSystemPath (NULL, path, kCFURLPOSIXPathStyle, 0);
    // 释放
    CFRelease(path);
    
    // 创建基于URL的PDF图形上下文
    CGContextRef pdfContext = CGPDFContextCreateWithURL(url, NULL, NULL);
    // 释放
    CFRelease(url);

    CGRect pageRect = CGRectMake(0, 0, 1240, 1754);
    
    // 使指定的图形上下文成为当前上下文
    UIGraphicsPushContext(pdfContext);
    
    // 在基于页面的图形上下文中启动新页面
    CGContextBeginPage(pdfContext, &pageRect);
    
    // 坐标系向上平移了pageRect.size.height, 具体原因下面会解释
    CGContextTranslateCTM(pdfContext, 0, pageRect.size.height);
    // y轴的缩放因子是-1, y乘缩放因子-1, x轴不变, y轴就是沿x轴翻转了过来
    CGContextScaleCTM(pdfContext, 1.0, -1.0);
    
    // 绘制内容的代码，具体下面会说
    [[[LVRoadCasePrint alloc] init] drawInquestRecordAction:nil];
    
    // 在PDF图形上下文中结束当前页
    CGPDFContextEndPage(pdfContext);
    // 从堆栈顶部移除当前图形上下文，恢复以前的上下文
    UIGraphicsPopContext();
    // 关闭pdf文档
    CGPDFContextClose(pdfContext);
    
    // 释放
    CGContextRelease(pdfContext);
}

- (void)dataPrintWithCoreGraphics
{
    
    NSMutableData *pdfData = [[NSMutableData alloc] init];
    CGDataConsumerRef dataConsumer = CGDataConsumerCreateWithCFData((CFMutableDataRef)pdfData);
    CGContextRef pdfContext = CGPDFContextCreate(dataConsumer, NULL, NULL);
    
    CGDataConsumerRelease(dataConsumer);
    
    CGRect pageRect = CGRectMake(0.0f, 0.0f, 1240, 1754);
    
    UIGraphicsPushContext(pdfContext);
    CGContextBeginPage(pdfContext, &pageRect);

    CGContextTranslateCTM(pdfContext, 0, pageRect.size.height);
    CGContextScaleCTM(pdfContext, 1.0, -1.0);
    
    [[[LVRoadCasePrint alloc] init] drawSiteRecordAction:nil];

    CGContextEndPage(pdfContext);
    CGPDFContextClose(pdfContext);
    UIGraphicsPopContext();

    CGContextRelease(pdfContext);
    
    NSString *docsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];

    self.pathPDF = [NSString stringWithFormat:@"%@/绘制.pdf",docsDirectory];
    
    [pdfData writeToFile:self.pathPDF atomically:YES];
}

// 模板两个字的位置变了, 是因为两个pdf的大小不一样
- (void)printAlreadyWithCoreGraphics
{
    NSString *docsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];

    self.pathPDF = [NSString stringWithFormat:@"%@/绘制.pdf",docsDirectory];

    NSString *pathName = [[NSBundle mainBundle] pathForResource:@"模板" ofType:@"pdf"];

    const char *filename = [self.pathPDF UTF8String];
    const char *bgFilename = [pathName UTF8String];

    CFStringRef path = CFStringCreateWithCString (NULL, filename, kCFStringEncodingUTF8);
    CFURLRef url = CFURLCreateWithFileSystemPath (NULL, path, kCFURLPOSIXPathStyle, 0);
    CFRelease(path);
    
    CFStringRef bgPath = CFStringCreateWithCString (NULL, bgFilename, kCFStringEncodingUTF8);
    CFURLRef bgUrl = CFURLCreateWithFileSystemPath (NULL, bgPath, kCFURLPOSIXPathStyle, 0);
    CFRelease(bgPath);

    // 创建基于URL的PDF图形上下文
    CGContextRef pdfContext = CGPDFContextCreateWithURL(url, NULL, NULL);
    CFRelease(url);

    // 使用URL指定的数据创建核心图形PDF文档。获取模板这个PDF文件
    CGPDFDocumentRef document = CGPDFDocumentCreateWithURL(bgUrl);
    // document也可以用data创建
//    NSData *pdfData = [NSData dataWithContentsOfFile:pathName];
//    CFDataRef myPDFData = (__bridge CFDataRef) pdfData;
//    CGDataProviderRef provider = CGDataProviderCreateWithCFData(myPDFData);
//    CGPDFDocumentRef document = CGPDFDocumentCreateWithProvider(provider);
//    CGDataProviderRelease(provider);
    
    CFRelease(bgUrl);
    
    // 返回核心图形PDF文档中的页面。获取这个文档的第一页
    CGPDFPageRef page = CGPDFDocumentGetPage(document, 1);
    
    //获取page页面的大小
//    CGRect pageRect = CGPDFPageGetBoxRect(page, kCGPDFMediaBox);
    CGRect pageRect = CGRectMake(0.0f, 0.0f, 1240, 1754);
    
    // 使指定的图形上下文成为当前上下文
    UIGraphicsPushContext(pdfContext);
    
    // 在基于页面的图形上下文中启动新页面
    CGContextBeginPage(pdfContext, &pageRect);
    
    // 将PDF页面的内容绘制到当前图形上下文中
    CGContextDrawPDFPage(pdfContext, page);
    
    // 坐标系向上平移了pageRect.size.height, 具体原因下面会解释
    CGContextTranslateCTM(pdfContext, 0, pageRect.size.height);
    // y轴的缩放因子是-1, y乘缩放因子-1, x轴不变, y轴就是沿x轴翻转了过来
    CGContextScaleCTM(pdfContext, 1.0, -1.0);
    [[[LVRoadCasePrint alloc] init] drawSiteRecordAction:nil];
    // 在PDF图形上下文中结束当前页
    CGPDFContextEndPage(pdfContext);
    
    // 第二页
    CGContextBeginPage(pdfContext, &pageRect);
    CGContextTranslateCTM(pdfContext, 0, pageRect.size.height);
    CGContextScaleCTM(pdfContext, 1.0, -1.0);
    [[[LVRoadCasePrint alloc] init] drawInquestRecordAction:nil];
    CGPDFContextEndPage(pdfContext);
    
    
    // 从堆栈顶部移除当前图形上下文，恢复以前的上下文
    UIGraphicsPopContext();
    // 关闭pdf文档
    CGPDFContextClose(pdfContext);
    
    
    CGPDFDocumentRelease(document);
    CGContextRelease(pdfContext);
    
}


// 隔空打印
- (void)selectRightAction:(id)sender
{
    // 打印PDF canPrintURL不知道为什么返回false，就用canPrintData判断
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
}




@end
