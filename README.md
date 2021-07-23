![](https://upload-images.jianshu.io/upload_images/12618366-908a8fdeb32a6874.jpeg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

> 需求: 移动端绘制PDF页面, 获取数据进行填充, 然后通过隔空打印打印出来，以下内容只根据我所做具体内容进行讲解，如有不对，还请不吝指教

#一、创建PDF文件
创建PDF文件有两种方式, 一种是用UIKit的UIGraphics类里面的方法,第二种是用CoreGraphics,  是基于Quartz 2D的一个高级绘图引擎，。Core Graphics是对底层C语言的一个简单封装，而UIGraphics是对CoreGraphics的部分功能的进一层封装, 所以UIGraphics更加`苹果点`, 使用方便, 而CoreGraphics更底层, 更强大
##UIGraphics创建PDF
###1. 用UIGraphicsBeginPDFContextToFile方法创建
```
// 指定PDF文件保存路径
NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
NSString *pathPDF =  [documentPath stringByAppendingPathComponent:@"绘制.pdf"];
// 创建以指定路径为目标的PDF图形上下文，这里我们pathPDF路径下已经得到一个名叫绘制.pdf文件，不过没有内容, 如果原本就有个叫绘制的pdf文件, 这个文件会被覆盖
UIGraphicsBeginPDFContextToFile(pathPDF, CGRectZero, NULL);
// 在PDF上下文中标记新页面的开始，PDF文档是分页的，开启一页文档绘制调用这个方法一次，也可以用UIGraphicsBeginPDFPageWithInfo(CGRect bounds, NSDictionary * __nullable pageInfo)指定PDF的大小，方便绘制
UIGraphicsBeginPDFPage();

/*
* 绘制内容的代码，具体下面会说
*/

// 关闭PDF图形上下文并从当前上下文堆栈中弹出它, 不写这段代码, PDF文件打不开
UIGraphicsEndPDFContext();

```


###2. 用UIGraphicsBeginPDFContextToData方法创建
```
NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
NSString *pathPDF =  [documentPath stringByAppendingPathComponent:@"绘制.pdf"];
NSMutableData *data = [NSMutableData data];
UIGraphicsBeginPDFContextToData(data, CGRectZero, NULL);

UIGraphicsBeginPDFPage();

/*
* 绘制内容的代码，具体下面会说
*/

UIGraphicsEndPDFContext();

[data writeToFile:pathPDF atomically:YES];
```
两种方法创建PDF, 并在PDF上面绘制文本内容, 如果没有指定创建方法(`UIGraphicsBeginPDFPageWithInfo`或`UIGraphicsBeginPDFContextToData`)和开始页面的方法`UIGraphicsBeginPDFPageWithInfo`指定PDF页面的大小, 默认的大小是`CGSizeMake(612, 792)`. 其次, 调用一次`UIGraphicsBeginPDFPage`或`UIGraphicsBeginPDFPageWithInfo`就会开始新的一页.
经过我数次的试验, 如果要对原有的PDF进行再次绘制用UIGraphics是不行的, 假如第一种创建PDF代码的那个pathPDF路径下已有一个有内容的`绘制.pdf`, 但是当我调用UIGraphicsBeginPDFContextToFile方法的时候,这个PDF会被清空, 而第二种创建方法的data, 我传的是一个已有内容的PDF的data数据进去, 那个PDF的内容是可以读取到新的PDF上, 但是无法对其进行绘制, 具体我猜测是当前的上下文和那个PDF的上下文不一样, 应该要先push到那个PDF的上下文, 在进行绘制, 但是那个PDF的上下文我好像无法获取. 所以, 如果是对已有的PDF进行绘制只能用CoreGraphics.
##CoreGraphics
###1. 创建PDF
* ####通过url创建PDF文件
```
    NSString *docsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];

    NSString *pathPDF = [NSString stringWithFormat:@"%@/绘制.pdf",docsDirectory];

    const char *filename = [pathPDF UTF8String];

    CFStringRef path = CFStringCreateWithCString (NULL, filename, kCFStringEncodingUTF8);
    CFURLRef url = CFURLCreateWithFileSystemPath (NULL, path, kCFURLPOSIXPathStyle, 0);
    // 释放
    CFRelease(path);
    
    // 创建基于URL的PDF图形上下文
    CGContextRef pdfContext = CGPDFContextCreateWithURL(url, NULL, NULL);

    // 释放
    CFRelease(url);

    // 指定生成PDF的大小
    CGRect pageRect = CGRectMake(0, 0, 1240, 1754);
    
    // 使指定的图形上下文成为当前上下文
    UIGraphicsPushContext(pdfContext);
    
    // 在基于页面的图形上下文中启动新页面
    CGContextBeginPage(pdfContext, &pageRect);
    
    // 坐标系向上平移了pageRect.size.height, 具体原因下面会解释
    CGContextTranslateCTM(pdfContext, 0, pageRect.size.height);
    // y轴的缩放因子是-1, y乘缩放因子-1, x轴不变, y轴就是沿x轴翻转了过来
    CGContextScaleCTM(pdfContext, 1.0, -1.0);

    /*
    * 绘制内容的代码，具体下面会说
    */
    
    // 在PDF图形上下文中结束当前页
    CGPDFContextEndPage(pdfContext);
    // 从堆栈顶部移除当前图形上下文，恢复以前的上下文
    UIGraphicsPopContext();
    // 关闭pdf文档
    CGPDFContextClose(pdfContext);
    
    // 释放
    CGContextRelease(pdfContext);
```
首先, 上面的`pageRect`和`UIGraphics`创建PDF时指定的那个大小是一样的, 是相对大小. 这边测试从Word和Page导出的PDF文件大小分别是width = 595.27560000000005 height = 841.88980000000004, width = 595.27999999999997, height = 841.88999999999999
`打印出来纸张的大小虽然都是一样的, 但是PDF的大小不一定一样`

其次, `CGContextBeginPage`和`CGPDFContextEndPage`成对出现的, 不同于UIGraphics, 开启下一页绘制只需要`UIGraphicsBeginPDFPage`或`UIGraphicsBeginPDFPageWithInfo `, CoreGraphics开启新一页要同时写`CGContextBeginPage`和`CGPDFContextEndPage`

最后说下为什么绘制内容要平移后再翻转, `UIKit`的坐标原点是在屏幕左上角, y轴是向下递增, x轴是像右递增, 而`CoreGraphics`的坐标原点是在左下角的, 因为绘制的内容frame是`UIKit`的坐标系, 所以要将`CoreGraphics`转成`UIKit`的坐标系, 所以是向上移动再沿翻转, 如果不进行这个操作绘制出来的PDF会变成下面这样
![](https://upload-images.jianshu.io/upload_images/12618366-10d639196bf5ff2f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
* ####通过data写入的方式创建PDF文件
```
    NSMutableData *pdfData = [[NSMutableData alloc] init];
    CGDataConsumerRef dataConsumer = CGDataConsumerCreateWithCFData((CFMutableDataRef)pdfData);
    CGContextRef pdfContext = CGPDFContextCreate(dataConsumer, NULL, NULL);
    
    CGDataConsumerRelease(dataConsumer);
    
    CGRect pageRect = CGRectMake(0.0f, 0.0f, 1240, 1754);
    
    UIGraphicsPushContext(pdfContext);
    CGContextBeginPage(pdfContext, &pageRect);

    CGContextTranslateCTM(pdfContext, 0, pageRect.size.height);
    CGContextScaleCTM(pdfContext, 1.0, -1.0);
    
    /*
    * 绘制内容的代码，具体下面会说
    */

    CGContextEndPage(pdfContext);
    CGPDFContextClose(pdfContext);
    UIGraphicsPopContext();

    CGContextRelease(pdfContext);
    
    NSString *docsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];

    NSString *pathPDF = [NSString stringWithFormat:@"%@/绘制.pdf",docsDirectory];
    
    [pdfData writeToFile:pathPDF atomically:YES];
```
这个和第一种创建PDF不同在创建PDF上下文的方式不同, 而且最后要自己写入文件
###2. 绘制原有PDF文件
```
    NSString *docsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];

    NSString *pathPDF = [NSString stringWithFormat:@"%@/绘制.pdf",docsDirectory];

    NSString *pathName = [[NSBundle mainBundle] pathForResource:@"模板" ofType:@"pdf"];

    const char *filename = [pathPDF UTF8String];
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
    CGPDFPageRef page = CGPDFPageRetain(CGPDFDocumentGetPage(document, 1));
    
    // 获取原有PDF文件page页面的大小
    CGRect pageRect = CGPDFPageGetBoxRect(page, kCGPDFMediaBox);
    
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

    /*
    * 绘制内容的代码，具体下面会说
    */
    
    // 在PDF图形上下文中结束当前页
    CGPDFContextEndPage(pdfContext);
    // 从堆栈顶部移除当前图形上下文，恢复以前的上下文
    UIGraphicsPopContext();
    // 关闭pdf文档
    CGPDFContextClose(pdfContext);
    
    
    CGPDFDocumentRelease(document);
    CGContextRelease(pdfContext);
```
上面代码大概就是将模板.pdf的第一页内容绘制到绘制.pdf上, 如果还要在上面绘制, 可以将代码添加到绘制内容的代码的注释那里.
这里要注意的是`CGPDFPageGetBoxRect()`方法, 是获取传进去page页面的大小, 最好以这个大小去绘制内容, 假如有这么个需求, 就是给你一个试题的PDF, 要你在这个试题里面绘制内容, 比如填空, 但打印出来的时候只打印你的答案, 打印用的A4纸已经提前把试题打印上去了, 你再用着纸打印你的答案, 如果两个PDF不是一样大, 那么你打印出来的答案可能会落不到原本的空里面(PS:内容的frame是一次次试出来的)
只要用好`CGPDFDocumentRef`和`CGPDFPageRef`基本上可以进行很多操作, 又例如合并两个pdf, 核心代码如下
```
NSString *cacheDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];

// File paths
NSString *pdfPath1 = [[NSBundle mainBundle] pathForResource:@"合并1" ofType:@"pdf"];
NSString *pdfPath2 = [cacheDir stringByAppendingPathComponent:@"合并2.pdf"];
NSString *pdfPathOutput = [cacheDir stringByAppendingPathComponent:@"out.pdf"];

// File URLs - bridge casting for ARC
CFURLRef pdfURL1 = (__bridge_retained CFURLRef)[[NSURL alloc] initFileURLWithPath:(NSString *)pdfPath1];//(CFURLRef) NSURL
CFURLRef pdfURL2 = (__bridge_retained CFURLRef)[[NSURL alloc] initFileURLWithPath:(NSString *)pdfPath2];//(CFURLRef)
CFURLRef pdfURLOutput =(__bridge_retained CFURLRef) [[NSURL alloc] initFileURLWithPath:(NSString *)pdfPathOutput];//(CFURLRef)

// File references
CGPDFDocumentRef pdfRef1 = CGPDFDocumentCreateWithURL((CFURLRef) pdfURL1);
CGPDFDocumentRef pdfRef2 = CGPDFDocumentCreateWithURL((CFURLRef) pdfURL2);

// Number of pages
NSInteger numberOfPages1 = CGPDFDocumentGetNumberOfPages(pdfRef1);
NSInteger numberOfPages2 = CGPDFDocumentGetNumberOfPages(pdfRef2);

// Create the output context
CGContextRef writeContext = CGPDFContextCreateWithURL(pdfURLOutput, NULL, NULL);

// Loop variables
CGPDFPageRef page;
CGRect mediaBox;

// Read the first PDF and generate the output pages
NSLog(@"GENERATING PAGES FROM PDF 1 (%i)...", numberOfPages1);
// 将第一个PDF, 一页页CGContextDrawPDFPage到out.pdf上
for (int i=1; i<=numberOfPages1; i++) {
    page = CGPDFDocumentGetPage(pdfRef1, i);
    mediaBox = CGPDFPageGetBoxRect(page, kCGPDFMediaBox);
    CGContextBeginPage(writeContext, &mediaBox);
    CGContextDrawPDFPage(writeContext, page);
    CGContextEndPage(writeContext);
}

// Read the second PDF and generate the output pages
NSLog(@"GENERATING PAGES FROM PDF 2 (%i)...", numberOfPages2);
// 再将第二个PDF, 一页页CGContextDrawPDFPage到out.pdf上
for (int i=1; i<=numberOfPages2; i++) {
    page = CGPDFDocumentGetPage(pdfRef2, i);
    mediaBox = CGPDFPageGetBoxRect(page, kCGPDFMediaBox);
    CGContextBeginPage(writeContext, &mediaBox);
    CGContextDrawPDFPage(writeContext, page);
    CGContextEndPage(writeContext);      
}
NSLog(@"DONE!");

// Finalize the output file
CGPDFContextClose(writeContext);

// Release from memory
CFRelease(pdfURL1);
CFRelease(pdfURL2);
CFRelease(pdfURLOutput);
CGPDFDocumentRelease(pdfRef1);
CGPDFDocumentRelease(pdfRef2);
CGContextRelease(writeContext);
```

#二、绘制内容
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
字体这块最好用动态加载好一点,因为导入的ttf文件很大,这会导致我们的包变大,可以参考以下代码
```
- (void)asynchronouslySetFontName:(NSString *)fontName
{
	UIFont* aFont = [UIFont fontWithName:fontName size:12.];

/* 
判断字体是否已经存在, 进入应用后执行CTFontDescriptorMatchFontDescriptorsWithProgressHandler并kCTFontDescriptorMatchingDidFinish, 
即下载成功了, 未退出应用第二次进去这个方法就会进入下面的条件, 但如果关掉应用进程重新进入, 不会进入下面的条件还是会跑到CTFontDescriptorMatchFontDescriptorsWithProgressHandler回调里面, 
但不会再去下载, 直接回调的状态是kCTFontDescriptorMatchingDidBegin , kCTFontDescriptorMatchingDidFinishDownloading, 然后kCTFontDescriptorMatchingDidFinish,  
不会有准备下载和下载中的状态返回, 字体下载一次即使卸载应用也是存在的, 如果当前在下载一种字体,再调用CTFontDescriptorMatchFontDescriptorsWithProgressHandler, 
要等那种字体下载完了才会进入新调用方法的回调
*/
	if (aFont && ([aFont.fontName compare:fontName] == NSOrderedSame || [aFont.familyName compare:fontName] == NSOrderedSame)) {
		return;
	}
	
    // Create a dictionary with the font's PostScript name.
	NSMutableDictionary *attrs = [NSMutableDictionary dictionaryWithObjectsAndKeys:fontName, kCTFontNameAttribute, nil];
    
    // Create a new font descriptor reference from the attributes dictionary.
	CTFontDescriptorRef desc = CTFontDescriptorCreateWithAttributes((__bridge CFDictionaryRef)attrs);
    
    NSMutableArray *descs = [NSMutableArray arrayWithCapacity:0];
    [descs addObject:(__bridge id)desc];
    CFRelease(desc);
    
	__block BOOL errorDuringDownload = NO;
	
// 文档返回NO会结束下载进程, 但我试了好像没什么卵用, 一旦开始下载字体就停不下来
    CTFontDescriptorMatchFontDescriptorsWithProgressHandler( (__bridge CFArrayRef)descs, NULL,  ^(CTFontDescriptorMatchingState state, CFDictionaryRef progressParameter) {
        
		//NSLog( @"state %d - %@", state, progressParameter);
		// 进度, 100是完成
		double progressValue = [[(__bridge NSDictionary *)progressParameter objectForKey:(id)kCTFontDescriptorMatchingPercentage] doubleValue];
		
		if (state == kCTFontDescriptorMatchingDidBegin) {
			dispatch_async( dispatch_get_main_queue(), ^ {
				NSLog(@"Begin Matching");
			});
		} else if (state == kCTFontDescriptorMatchingDidFinish) {
			dispatch_async( dispatch_get_main_queue(), ^ {
				if (!errorDuringDownload) {
					NSLog(@"%@ downloaded", fontName);
				}
			});
		} else if (state == kCTFontDescriptorMatchingWillBeginDownloading) {
			dispatch_async( dispatch_get_main_queue(), ^ {
				NSLog(@"Begin Downloading");
			});
		} else if (state == kCTFontDescriptorMatchingDidFinishDownloading) {
			dispatch_async( dispatch_get_main_queue(), ^ {
				NSLog(@"Finish downloading");
			});
		} else if (state == kCTFontDescriptorMatchingDownloading) {
			dispatch_async( dispatch_get_main_queue(), ^ {
				NSLog(@"Downloading %.0f%% complete", progressValue);
			});
		} else if (state == kCTFontDescriptorMatchingDidFailWithError) {
            // An error has occurred.
            // Get the error message
            NSError *error = [(__bridge NSDictionary *)progressParameter objectForKey:(id)kCTFontDescriptorMatchingError];
            if (error != nil) {
                _errorMessage = [error description];
            } else {
                _errorMessage = @"ERROR MESSAGE IS NOT AVAILABLE!";
            }
            // Set our flag
            errorDuringDownload = YES;
            
            dispatch_async( dispatch_get_main_queue(), ^ {
				NSLog(@"Download error: %@", _errorMessage);
			});
		}
        
		return (bool)YES;
	});
    
}
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
#三、展示
```

/*
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
#四、隔空打印
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
https://www.coder.work/article/467182

