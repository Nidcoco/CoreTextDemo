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

    dispatch_async(dispatch_get_global_queue(0, 0), ^{

        NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];

        self.pathPDF =  [documentPath stringByAppendingPathComponent:@"绘制.pdf"];

        UIGraphicsBeginPDFContextToFile(self.pathPDF, CGRectZero, NULL);

        NSLog(@"pathPDF  =%@",self.pathPDF);

        UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 1240, 1754), nil);

    //    UIGraphicsBeginPDFPage();

        [[[LVRoadCasePrint alloc] init] drawInquestRecordAction:nil];

        UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 1240, 1754), nil);

        [[[LVRoadCasePrint alloc] init] drawSiteRecordAction:nil];


        UIGraphicsEndPDFContext();


        dispatch_async(dispatch_get_main_queue(), ^{

            NSURL *url = [NSURL fileURLWithPath:self.pathPDF];

            [self.webView loadRequest:[NSURLRequest requestWithURL:url]];

        });

    });
    
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
