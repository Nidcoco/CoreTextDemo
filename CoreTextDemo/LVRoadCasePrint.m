//
//  LVRoadCasePrint.m
//  CoreTextDemo
//
//  Created by Levi on 2021/1/8.
//

/**
 * 字体高度单行等于字体的font+4，宽度通过sizeWithAttributes方法获取
 */

#define WIDTH 1240  ///< 页面的宽度

#define HEIGHT 1754 ///< 页面的高度

#define INIT_X 80    ///< 正文初始x值

#define INIT_Y 115    ///< 正文初始y值

#define TITLE_FONT 30.0f  ///< 标题字体大小

#define TITLE_Y 50.0f   ///< 标题Y值

#define TITLE_FONT_HEIGHT TITLE_FONT + 4.0f ///< 正文单行字体的高度

#define FONT 20.0f  ///< 正文字体大小

#define FONT_HEIGHT FONT + 4.0f ///< 正文单行字体的高度

#define TEXT_WIDTH(__X) [self getTextWidthWithText:__X]  ///< 文字宽度

///< 标题
#define TITLE_INQUESTRECORD @"勘验（检查）笔录"

#define TITLE_SCENERECORD @"现 场 笔 录"

///<  勘验笔录

#define SPACE 30.0f  ///< 行间距

#define LINE_SPACE 10.0f  ///< 下划线距离字体间距

#define TEXT_Y Y + FONT_HEIGHT + SPACE  ///< 每一行的文字的y值

#define LINE_Y Y + FONT_HEIGHT + LINE_SPACE ///< 下划线的y值

#define TEXT_CAUSE @"案由："

#define TEXT_INQUESTTIME @"勘验（检查）时间："

#define TEXT_TO @"至"

#define TEXT_INQUESTPLACE @"勘验（检查）场所："

#define TEXT_INQUESTWEATHER @"天气情况："

#define TEXT_PERSONNAME @"当事人（当事人代理人）姓名："

#define TEXT_SEX @"性别："

#define TEXT_AGE @"年龄："

#define TEXT_IDNUMBER @"身份证号："

#define TEXT_WORKUNIT @"工作单位："

#define TEXT_POST @"职务："

#define TEXT_ADDRESS @"住址："

#define TEXT_TELEPHONE @"联系电话："

#define TEXT_RECORDPERSON @"记录人："

#define TEXT_WORKUNIT_POST @"单位及职务："

#define TEXT_INQUEST_RESULT @"勘验（检查）情况及结果："

#define TEXT_INQUEST_AUTOGRAPH @"勘验（检查）人签名："

#define TEXT_INQUEST_PARTIES_AUTOGRAPH @"当事人或其代理人签名："

#define TEXT_INQUEST_INVITED_AUTOGRAPH @"被邀请人签名："

#define TEXT_INQUEST_RECORD_AUTOGRAPH @"记录人签名："

#define TEXT_REMARK @"备注："

#define TEXT_TIPS @"（本页填写不下的内容或需绘制勘验图的，可另附页。）"

#define ROW_TWO_LINE_WIDTH (WIDTH - 2 * X - TEXT_WIDTH(TEXT_INQUESTTIME) - TEXT_WIDTH(TEXT_TO)) / 2 ///< 第二行线的宽度

#define ROW_THREE_LINE_WIDTH (WIDTH - 2 * X - TEXT_WIDTH(TEXT_INQUESTPLACE) - TEXT_WIDTH(TEXT_INQUESTWEATHER)) / 2 ///< 第三行线的宽度

#define ROW_FOUR_LINE_WIDTH (WIDTH - 2 * X - TEXT_WIDTH(TEXT_PERSONNAME) - TEXT_WIDTH(TEXT_SEX) - TEXT_WIDTH(TEXT_AGE)) / 3 ///< 第四行线的宽度

#define ROW_FIVE_LINE_WIDTH (WIDTH - 2 * X - TEXT_WIDTH(TEXT_IDNUMBER) - TEXT_WIDTH(TEXT_WORKUNIT) - TEXT_WIDTH(TEXT_POST)) / 3 ///< 第五行线的宽度

#define ROW_SIX_LINE_WIDTH (WIDTH - 2 * X - TEXT_WIDTH(TEXT_ADDRESS) - TEXT_WIDTH(TEXT_TELEPHONE)) / 2 ///< 第六行线的宽度

#define ROW_SEVEN_LINE_WIDTH (WIDTH - 2 * X - TEXT_WIDTH(TEXT_RECORDPERSON) - TEXT_WIDTH(TEXT_WORKUNIT_POST)) / 2 ///< 第七行线的宽度

#define ROW_ELEVEN_LINE_WIDTH 180.0f ///< 第十一行线以下的宽度


///< 现场笔录，按照左边那列的文字将整块表分成4部分

#define LINESPACING 3.0f    ///< 多行文字行间距

#define TEXT_ENFORCEMENT_LOCATION @"执法\n地点"

#define TEXT_ENFORCEMENT_PERSON @"执法\n人员"

#define TEXT_ENFORCEMENT_TIME @"执法时间"

#define TEXT_ENFORCEMENT_NUMBER @"执法证号"

#define TEXT_RECORD_PERSON @"记录人"

#define TEXT_BASIC_INFORMATION @"现场\n人员\n基本\n情况"

#define TEXT_NAME @"姓 名"

#define TEXT_ID_NUMBER @"身份证号"

#define TEXT_WORK_UNIT_POST @"单位及职务"

#define TEXT_CONTACT_ADDRESS @"联系地址"

#define TEXT_CAR_NUMBER @"车（船）号"

#define TEXT_PROJECT_NAME @"项目名称"

#define TEXT_CASE_RELATIONSHIP @"与案件关系"

#define TEXT_PHONE @"联系电话"

#define TEXT_CAR_TYPE @"车（船）型"

#define TEXT_MAIN_CONTENT @"主要\n内容"

#define TEXT_FIND @"在检查中发现："

#define TEXT_CHECK @"上述笔录我已看过（或已向我宣读过），情况属实无误。"

#define TEXT_PARTIES_AUTOGRAPH @"当事人签名："

#define TEXT_TIME @"时间："

#define TEXT_TWO_ROW_HEIGHT 2 * FONT + 4 + LINESPACING  ///< 两行文字带行间距的高度

#define PART_ONE_ROW_HEIGHT 80.0f   ///< 第一行高

#define PART_TWO_LITTLEROW_HEIGHT 70.0f    ///< 第二行, 第二列, 第一小行行高

#define PART_ONE_COLUMNWIDTH 100.0f   ///< 第一列宽

#define PART_ONE_ROW_TWO_COLUMNWIDTH (WIDTH / 2 - X - PART_ONE_COLUMNWIDTH)   ///< 第一行第二列宽

#define PART_ONE_ROW_THREE_COLUMNWIDTH (WIDTH / 2 - X) / 2   ///< 第一行第三列宽

#define ONEROW_GET_Y(ROW_HEIGHT) (ROW_HEIGHT - FONT_HEIGHT) / 2  ///< 获取一行文字的Y值, ROW_HEIGHT为当行高度, 行内高度居中

#define TWOROW_GET_Y(ROW_HEIGHT) (ROW_HEIGHT - (TEXT_TWO_ROW_HEIGHT)) / 2   ///< 获取两行文字带行间距的Y值, ROW_HEIGHT为当行高度, 行内高度居中

#define BASIC_INFORMATION_HEIGHT 4 * FONT + 4 + 3 * LINESPACING ///< 现场人员基本情况文字高度

#define BASIC_INFORMATION_Y (5 * PART_TWO_LITTLEROW_HEIGHT - (BASIC_INFORMATION_HEIGHT)) / 2    ///< 现场人员基本情况所在行的Y值

#define PART_THREE_ROW_FOUR_COLUMNX 2 * PART_ONE_ROW_THREE_COLUMNWIDTH / 5 + WIDTH / 2  ///< 第三行第四列X值

#define PART_FOUR_ROW_HEIGHT (HEIGHT - 323 - PART_ONE_ROW_HEIGHT - 8 * PART_TWO_LITTLEROW_HEIGHT)   ///< 第四行的高度

#define PART_FOUR_TEXT_LEFT_OFFSET 20.0f    ///< 第四行第二列文字/下划线距离左边的距离

#define TEXT_CHECK_RIGHT_OFFSET 200.0f

#import "LVRoadCasePrint.h"



@implementation LVRoadCasePrint

- (void)drawInquestRecordAction:(NSDictionary *)data
{
    ///<  标题
    [[LVPDFDrawManager sharedInstance] printStr:TITLE_INQUESTRECORD CGRect:CGRectMake(0, TITLE_Y, WIDTH, TITLE_FONT_HEIGHT) Font:TITLE_FONT fontWithName:@"PingFangSC-Semibold" lineSpacing:0.0f lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentCenter];
    
    CGFloat X = INIT_X;
    CGFloat Y = INIT_Y;
    
    ///< 案由
    [[LVPDFDrawManager sharedInstance] printStr:TEXT_CAUSE CGRect:CGRectMake(X, Y, TEXT_WIDTH(TEXT_CAUSE), FONT_HEIGHT) Font:FONT lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentLeft];

    ///< 线
    [[LVPDFDrawManager sharedInstance] drawLineFromPoint:CGPointMake(X + TEXT_WIDTH(TEXT_CAUSE), LINE_Y) toPoint:CGPointMake(WIDTH - X, LINE_Y)];
    
    ///< 第二行的初始Y值
    Y = TEXT_Y;
    
    ///< 勘验时间
    [[LVPDFDrawManager sharedInstance] printStr:TEXT_INQUESTTIME CGRect:CGRectMake(X, Y, TEXT_WIDTH(TEXT_INQUESTTIME), FONT_HEIGHT) Font:FONT lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentLeft];

    ///< 线
    [[LVPDFDrawManager sharedInstance] drawLineFromPoint:CGPointMake(X + TEXT_WIDTH(TEXT_INQUESTTIME), LINE_Y) toPoint:CGPointMake(X + TEXT_WIDTH(TEXT_INQUESTTIME) + ROW_TWO_LINE_WIDTH, LINE_Y)];
    
    ///< 至
    [[LVPDFDrawManager sharedInstance] printStr:TEXT_TO CGRect:CGRectMake(X + TEXT_WIDTH(TEXT_INQUESTTIME) + ROW_TWO_LINE_WIDTH, Y, TEXT_WIDTH(TEXT_TO), FONT_HEIGHT) Font:FONT lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentCenter];
    
    ///< 线
    [[LVPDFDrawManager sharedInstance] drawLineFromPoint:CGPointMake(X + TEXT_WIDTH(TEXT_INQUESTTIME) + ROW_TWO_LINE_WIDTH + TEXT_WIDTH(TEXT_TO), LINE_Y) toPoint:CGPointMake(WIDTH - X, LINE_Y)];
    
    ///< 第三行的初始Y值
    Y = TEXT_Y;
    
    ///< 勘验场所
    [[LVPDFDrawManager sharedInstance] printStr:TEXT_INQUESTPLACE CGRect:CGRectMake(X, Y, TEXT_WIDTH(TEXT_INQUESTPLACE), FONT_HEIGHT) Font:FONT lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentLeft];

    ///< 线
    [[LVPDFDrawManager sharedInstance] drawLineFromPoint:CGPointMake(X + TEXT_WIDTH(TEXT_INQUESTPLACE), LINE_Y) toPoint:CGPointMake(X + TEXT_WIDTH(TEXT_INQUESTPLACE) + ROW_THREE_LINE_WIDTH, LINE_Y)];

    ///< 天气
    [[LVPDFDrawManager sharedInstance] printStr:TEXT_INQUESTWEATHER CGRect:CGRectMake(X + TEXT_WIDTH(TEXT_INQUESTPLACE) + ROW_THREE_LINE_WIDTH, Y, TEXT_WIDTH(TEXT_INQUESTWEATHER), FONT_HEIGHT) Font:FONT lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentCenter];

    ///< 线
    [[LVPDFDrawManager sharedInstance] drawLineFromPoint:CGPointMake(X + TEXT_WIDTH(TEXT_INQUESTPLACE) + ROW_THREE_LINE_WIDTH + TEXT_WIDTH(TEXT_INQUESTWEATHER), LINE_Y) toPoint:CGPointMake(WIDTH - X, LINE_Y)];
    
    ///< 第四行的初始Y值
    Y = TEXT_Y;
    
    ///< 当事人姓名
    [[LVPDFDrawManager sharedInstance] printStr:TEXT_PERSONNAME CGRect:CGRectMake(X, Y, TEXT_WIDTH(TEXT_PERSONNAME), FONT_HEIGHT) Font:FONT lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentLeft];
    
    ///< 线
    [[LVPDFDrawManager sharedInstance] drawLineFromPoint:CGPointMake(X + TEXT_WIDTH(TEXT_PERSONNAME), LINE_Y) toPoint:CGPointMake(X + TEXT_WIDTH(TEXT_PERSONNAME) + ROW_FOUR_LINE_WIDTH, LINE_Y)];
    
    ///< 性别
    [[LVPDFDrawManager sharedInstance] printStr:TEXT_SEX CGRect:CGRectMake(X + TEXT_WIDTH(TEXT_PERSONNAME) + ROW_FOUR_LINE_WIDTH, Y, TEXT_WIDTH(TEXT_SEX), FONT_HEIGHT) Font:FONT lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentCenter];
    
    ///< 线,用WIDTH减后面的宽度
    [[LVPDFDrawManager sharedInstance] drawLineFromPoint:CGPointMake(WIDTH - X - 2 * ROW_FOUR_LINE_WIDTH - TEXT_WIDTH(TEXT_AGE), LINE_Y) toPoint:CGPointMake(WIDTH - X - ROW_FOUR_LINE_WIDTH - TEXT_WIDTH(TEXT_AGE), LINE_Y)];
    
    ///< 年龄
    [[LVPDFDrawManager sharedInstance] printStr:TEXT_AGE CGRect:CGRectMake(WIDTH - X - ROW_FOUR_LINE_WIDTH - TEXT_WIDTH(TEXT_AGE), Y, TEXT_WIDTH(TEXT_AGE), FONT_HEIGHT) Font:FONT lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentCenter];
    
    ///< 线,用WIDTH减后面的宽度
    [[LVPDFDrawManager sharedInstance] drawLineFromPoint:CGPointMake(WIDTH - X - ROW_FOUR_LINE_WIDTH , LINE_Y) toPoint:CGPointMake(WIDTH - X, LINE_Y)];
    
    ///< 第五行的初始Y值
    Y = TEXT_Y;
    
    ///< 身份证号
    [[LVPDFDrawManager sharedInstance] printStr:TEXT_IDNUMBER CGRect:CGRectMake(X, Y, TEXT_WIDTH(TEXT_IDNUMBER), FONT_HEIGHT) Font:FONT lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentLeft];
    
    ///< 线
    [[LVPDFDrawManager sharedInstance] drawLineFromPoint:CGPointMake(X + TEXT_WIDTH(TEXT_IDNUMBER), LINE_Y) toPoint:CGPointMake(X + TEXT_WIDTH(TEXT_IDNUMBER) + ROW_FIVE_LINE_WIDTH, LINE_Y)];
    
    ///< 工作单位
    [[LVPDFDrawManager sharedInstance] printStr:TEXT_WORKUNIT CGRect:CGRectMake(X + TEXT_WIDTH(TEXT_IDNUMBER) + ROW_FIVE_LINE_WIDTH, Y, TEXT_WIDTH(TEXT_WORKUNIT), FONT_HEIGHT) Font:FONT lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentCenter];
    
    ///< 线,用WIDTH减后面的宽度
    [[LVPDFDrawManager sharedInstance] drawLineFromPoint:CGPointMake(WIDTH - X - 2 * ROW_FIVE_LINE_WIDTH - TEXT_WIDTH(TEXT_POST), LINE_Y) toPoint:CGPointMake(WIDTH - X - ROW_FIVE_LINE_WIDTH - TEXT_WIDTH(TEXT_POST), LINE_Y)];
    
    ///< 职务
    [[LVPDFDrawManager sharedInstance] printStr:TEXT_POST CGRect:CGRectMake(WIDTH - X - ROW_FIVE_LINE_WIDTH - TEXT_WIDTH(TEXT_POST), Y, TEXT_WIDTH(TEXT_POST), FONT_HEIGHT) Font:FONT lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentCenter];
    
    ///< 线,用WIDTH减后面的宽度
    [[LVPDFDrawManager sharedInstance] drawLineFromPoint:CGPointMake(WIDTH - X - ROW_FIVE_LINE_WIDTH , LINE_Y) toPoint:CGPointMake(WIDTH - X, LINE_Y)];
    
    ///< 第六行的初始Y值
    Y = TEXT_Y;
    
    ///< 住址
    [[LVPDFDrawManager sharedInstance] printStr:TEXT_ADDRESS CGRect:CGRectMake(X, Y, TEXT_WIDTH(TEXT_ADDRESS), FONT_HEIGHT) Font:FONT lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentLeft];

    ///< 线
    [[LVPDFDrawManager sharedInstance] drawLineFromPoint:CGPointMake(X + TEXT_WIDTH(TEXT_ADDRESS), LINE_Y) toPoint:CGPointMake(X + TEXT_WIDTH(TEXT_ADDRESS) + ROW_SIX_LINE_WIDTH, LINE_Y)];
    
    ///< 联系电话
    [[LVPDFDrawManager sharedInstance] printStr:TEXT_TELEPHONE CGRect:CGRectMake(X + TEXT_WIDTH(TEXT_ADDRESS) + ROW_SIX_LINE_WIDTH, Y, TEXT_WIDTH(TEXT_TELEPHONE), FONT_HEIGHT) Font:FONT lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentCenter];
    
    ///< 线
    [[LVPDFDrawManager sharedInstance] drawLineFromPoint:CGPointMake(X + TEXT_WIDTH(TEXT_ADDRESS) + ROW_SIX_LINE_WIDTH + TEXT_WIDTH(TEXT_TELEPHONE), LINE_Y) toPoint:CGPointMake(WIDTH - X, LINE_Y)];
    
    ///< 第七行的初始Y值
    Y = TEXT_Y;
    
    ///< 记录人
    [[LVPDFDrawManager sharedInstance] printStr:TEXT_RECORDPERSON CGRect:CGRectMake(X, Y, TEXT_WIDTH(TEXT_RECORDPERSON), FONT_HEIGHT) Font:FONT lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentLeft];

    ///< 线
    [[LVPDFDrawManager sharedInstance] drawLineFromPoint:CGPointMake(X + TEXT_WIDTH(TEXT_RECORDPERSON), LINE_Y) toPoint:CGPointMake(X + TEXT_WIDTH(TEXT_RECORDPERSON) + ROW_SEVEN_LINE_WIDTH, LINE_Y)];
    
    ///< 单位及职务
    [[LVPDFDrawManager sharedInstance] printStr:TEXT_WORKUNIT_POST CGRect:CGRectMake(X + TEXT_WIDTH(TEXT_RECORDPERSON) + ROW_SEVEN_LINE_WIDTH, Y, TEXT_WIDTH(TEXT_WORKUNIT_POST), FONT_HEIGHT) Font:FONT lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentCenter];
    
    ///< 线
    [[LVPDFDrawManager sharedInstance] drawLineFromPoint:CGPointMake(X + TEXT_WIDTH(TEXT_RECORDPERSON) + ROW_SEVEN_LINE_WIDTH + TEXT_WIDTH(TEXT_WORKUNIT_POST), LINE_Y) toPoint:CGPointMake(WIDTH - X, LINE_Y)];
    
    ///< 第八行的初始Y值
    Y = TEXT_Y;
    
    ///< 勘验记录
    [[LVPDFDrawManager sharedInstance] printStr:TEXT_INQUEST_RESULT CGRect:CGRectMake(X, Y, TEXT_WIDTH(TEXT_INQUEST_RESULT), FONT_HEIGHT) Font:FONT lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentLeft];
    
    ///< 第九行的初始Y值
    Y = TEXT_Y;
    
    ///< 线
    [[LVPDFDrawManager sharedInstance] drawLineFromPoint:CGPointMake(X, LINE_Y) toPoint:CGPointMake(WIDTH - X, LINE_Y)];
    
    ///< 第十行的初始Y值
    Y = TEXT_Y;
    
    ///< 线
    [[LVPDFDrawManager sharedInstance] drawLineFromPoint:CGPointMake(X, LINE_Y) toPoint:CGPointMake(WIDTH - X, LINE_Y)];
    
    ///< 第十一行的初始Y值
    Y = TEXT_Y;
    
    ///< 勘验签名
    [[LVPDFDrawManager sharedInstance] printStr:TEXT_INQUEST_AUTOGRAPH CGRect:CGRectMake(X, Y, TEXT_WIDTH(TEXT_INQUEST_AUTOGRAPH), FONT_HEIGHT) Font:FONT lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentLeft];
    
    ///< 线
    [[LVPDFDrawManager sharedInstance] drawLineFromPoint:CGPointMake(X + TEXT_WIDTH(TEXT_INQUEST_AUTOGRAPH), LINE_Y) toPoint:CGPointMake(X + TEXT_WIDTH(TEXT_INQUEST_AUTOGRAPH) + ROW_ELEVEN_LINE_WIDTH, LINE_Y)];
    
    ///< 、
    [[LVPDFDrawManager sharedInstance] printStr:@"、" CGRect:CGRectMake(X + TEXT_WIDTH(TEXT_INQUEST_AUTOGRAPH) + ROW_ELEVEN_LINE_WIDTH, Y, TEXT_WIDTH(@"、"), FONT_HEIGHT) Font:FONT lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentLeft];
    
    ///< 线
    [[LVPDFDrawManager sharedInstance] drawLineFromPoint:CGPointMake(X + TEXT_WIDTH(TEXT_INQUEST_AUTOGRAPH) + ROW_ELEVEN_LINE_WIDTH + TEXT_WIDTH(@"、"), LINE_Y) toPoint:CGPointMake(X + TEXT_WIDTH(TEXT_INQUEST_AUTOGRAPH) + 2 * ROW_ELEVEN_LINE_WIDTH + TEXT_WIDTH(@"、"), LINE_Y)];
    
    ///< 、
    [[LVPDFDrawManager sharedInstance] printStr:@"、" CGRect:CGRectMake(X + TEXT_WIDTH(TEXT_INQUEST_AUTOGRAPH) + 2 * ROW_ELEVEN_LINE_WIDTH + TEXT_WIDTH(@"、"), Y, TEXT_WIDTH(@"、"), FONT_HEIGHT) Font:FONT lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentLeft];
    
    ///< 线
    [[LVPDFDrawManager sharedInstance] drawLineFromPoint:CGPointMake(X + TEXT_WIDTH(TEXT_INQUEST_AUTOGRAPH) + 2 * ROW_ELEVEN_LINE_WIDTH + 2 * TEXT_WIDTH(@"、"), LINE_Y) toPoint:CGPointMake(X + TEXT_WIDTH(TEXT_INQUEST_AUTOGRAPH) + 3 * ROW_ELEVEN_LINE_WIDTH + 2 * TEXT_WIDTH(@"、"), LINE_Y)];
    
    ///< 第十二行的初始Y值
    Y = TEXT_Y;
    
    ///< 当事人签名
    [[LVPDFDrawManager sharedInstance] printStr:TEXT_INQUEST_PARTIES_AUTOGRAPH CGRect:CGRectMake(X, Y, TEXT_WIDTH(TEXT_INQUEST_PARTIES_AUTOGRAPH), FONT_HEIGHT) Font:FONT lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentLeft];
    
    ///< 线
    [[LVPDFDrawManager sharedInstance] drawLineFromPoint:CGPointMake(X + TEXT_WIDTH(TEXT_INQUEST_PARTIES_AUTOGRAPH), LINE_Y) toPoint:CGPointMake(X + TEXT_WIDTH(TEXT_INQUEST_PARTIES_AUTOGRAPH) + ROW_ELEVEN_LINE_WIDTH, LINE_Y)];
    
    ///< 第十三行的初始Y值
    Y = TEXT_Y;
    
    ///< 被邀请人签名
    [[LVPDFDrawManager sharedInstance] printStr:TEXT_INQUEST_INVITED_AUTOGRAPH CGRect:CGRectMake(X, Y, TEXT_WIDTH(TEXT_INQUEST_INVITED_AUTOGRAPH), FONT_HEIGHT) Font:FONT lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentLeft];
    
    ///< 线
    [[LVPDFDrawManager sharedInstance] drawLineFromPoint:CGPointMake(X + TEXT_WIDTH(TEXT_INQUEST_INVITED_AUTOGRAPH), LINE_Y) toPoint:CGPointMake(X + TEXT_WIDTH(TEXT_INQUEST_INVITED_AUTOGRAPH) + ROW_ELEVEN_LINE_WIDTH, LINE_Y)];
    
    ///< 线
    [[LVPDFDrawManager sharedInstance] drawLineFromPoint:CGPointMake(WIDTH - X - ROW_ELEVEN_LINE_WIDTH, LINE_Y) toPoint:CGPointMake(WIDTH - X, LINE_Y)];
    
    ///< 记录人签名
    [[LVPDFDrawManager sharedInstance] printStr:TEXT_INQUEST_RECORD_AUTOGRAPH CGRect:CGRectMake(WIDTH - X - ROW_ELEVEN_LINE_WIDTH - TEXT_WIDTH(TEXT_INQUEST_RECORD_AUTOGRAPH), Y, TEXT_WIDTH(TEXT_INQUEST_RECORD_AUTOGRAPH), FONT_HEIGHT) Font:FONT lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentLeft];
    
    ///< 第十四行的初始Y值
    Y = TEXT_Y;
    [[LVPDFDrawManager sharedInstance] printStr:TEXT_REMARK CGRect:CGRectMake(X, Y, TEXT_WIDTH(TEXT_REMARK), FONT_HEIGHT) Font:FONT lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentLeft];
    
    ///< 第十五行的初始Y值
    Y = TEXT_Y;
    
    ///< 提示
    [[LVPDFDrawManager sharedInstance] printStr:TEXT_TIPS CGRect:CGRectMake(X, Y, TEXT_WIDTH(TEXT_TIPS), FONT_HEIGHT) Font:FONT lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentLeft];
    
    
}

- (void)drawSiteRecordAction:(NSDictionary *)data
{
    [[LVPDFDrawManager sharedInstance] printStr:TITLE_SCENERECORD CGRect:CGRectMake(0, TITLE_Y, WIDTH, TITLE_FONT_HEIGHT) Font:TITLE_FONT fontWithName:@"PingFangSC-Semibold" lineSpacing:0.0f lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentCenter];
    
    CGFloat X = INIT_X;
    
    CGFloat Y = INIT_Y;
    
    ///< 最外层的矩形
    [[LVPDFDrawManager sharedInstance] drawEmptySquareWithCGRect:CGRectMake(X, Y, WIDTH - 2 * X, HEIGHT - 323)];

    ///< 执法地点
    [[LVPDFDrawManager sharedInstance] printStr:TEXT_ENFORCEMENT_LOCATION CGRect:CGRectMake(X, Y + TWOROW_GET_Y(PART_ONE_ROW_HEIGHT), PART_ONE_COLUMNWIDTH, TEXT_TWO_ROW_HEIGHT) Font:FONT lineSpacing:LINESPACING lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentCenter];
    
    ///< 第一行底线
    [[LVPDFDrawManager sharedInstance] drawLineFromPoint:CGPointMake(X, Y + PART_ONE_ROW_HEIGHT) toPoint:CGPointMake(WIDTH - X, Y + PART_ONE_ROW_HEIGHT)];
    
    ///< 第一列右线
    [[LVPDFDrawManager sharedInstance] drawLineFromPoint:CGPointMake(X + PART_ONE_COLUMNWIDTH, Y) toPoint:CGPointMake(X + PART_ONE_COLUMNWIDTH, Y + HEIGHT - 323)];
    
    ///< 第四行底线
    [[LVPDFDrawManager sharedInstance] drawLineFromPoint:CGPointMake(X, Y + 3 * PART_TWO_LITTLEROW_HEIGHT + PART_ONE_ROW_HEIGHT) toPoint:CGPointMake(WIDTH - X, Y + 3 * PART_TWO_LITTLEROW_HEIGHT + PART_ONE_ROW_HEIGHT)];
    
    ///< 第一行,第二列的右线
    [[LVPDFDrawManager sharedInstance] drawLineFromPoint:CGPointMake(WIDTH/2, Y) toPoint:CGPointMake(WIDTH/2, Y + PART_ONE_ROW_HEIGHT + 3 * PART_TWO_LITTLEROW_HEIGHT)];
    
    ///< 执法时间
    [[LVPDFDrawManager sharedInstance] printStr:TEXT_ENFORCEMENT_TIME CGRect:CGRectMake(WIDTH/2, Y + ONEROW_GET_Y(PART_ONE_ROW_HEIGHT), PART_ONE_ROW_THREE_COLUMNWIDTH, FONT_HEIGHT) Font:FONT lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentCenter];
    
    ///< 第一行,第三列的右线
    [[LVPDFDrawManager sharedInstance] drawLineFromPoint:CGPointMake(WIDTH / 2 + PART_ONE_ROW_THREE_COLUMNWIDTH, Y) toPoint:CGPointMake(WIDTH / 2 + PART_ONE_ROW_THREE_COLUMNWIDTH, Y + PART_ONE_ROW_HEIGHT + 3 * PART_TWO_LITTLEROW_HEIGHT)];

    ///< 第二行的初始Y值
    Y += PART_ONE_ROW_HEIGHT;
    
    ///< 执法人员
    [[LVPDFDrawManager sharedInstance] printStr:TEXT_ENFORCEMENT_PERSON CGRect:CGRectMake(X, Y + TWOROW_GET_Y(3 * PART_TWO_LITTLEROW_HEIGHT), PART_ONE_COLUMNWIDTH, 3 * PART_TWO_LITTLEROW_HEIGHT) Font:FONT lineSpacing:LINESPACING lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentCenter];

    ///< 第二行,第二列右线
    [[LVPDFDrawManager sharedInstance] drawLineFromPoint:CGPointMake((WIDTH - PART_ONE_ROW_TWO_COLUMNWIDTH) / 2, Y) toPoint:CGPointMake((WIDTH - PART_ONE_ROW_TWO_COLUMNWIDTH) / 2, Y + 8 * PART_TWO_LITTLEROW_HEIGHT)];
    
    ///< 第二行,第二列,第一小行底线
    [[LVPDFDrawManager sharedInstance] drawLineFromPoint:CGPointMake(X + PART_ONE_COLUMNWIDTH, Y + PART_TWO_LITTLEROW_HEIGHT) toPoint:CGPointMake(X + PART_ONE_COLUMNWIDTH + PART_ONE_ROW_TWO_COLUMNWIDTH / 2, Y + PART_TWO_LITTLEROW_HEIGHT)];
    
    ///< 第二行,第二列,第二小行底线
    [[LVPDFDrawManager sharedInstance] drawLineFromPoint:CGPointMake(X + PART_ONE_COLUMNWIDTH, Y + 2 * PART_TWO_LITTLEROW_HEIGHT) toPoint:CGPointMake(X + PART_ONE_COLUMNWIDTH + PART_ONE_ROW_TWO_COLUMNWIDTH / 2, Y + 2 * PART_TWO_LITTLEROW_HEIGHT)];
    
    ///< 执法证号
    [[LVPDFDrawManager sharedInstance] printStr:TEXT_ENFORCEMENT_NUMBER CGRect:CGRectMake((WIDTH - PART_ONE_ROW_TWO_COLUMNWIDTH) / 2, Y + ONEROW_GET_Y(3 * PART_TWO_LITTLEROW_HEIGHT), PART_ONE_ROW_TWO_COLUMNWIDTH / 2, 3 * PART_TWO_LITTLEROW_HEIGHT) Font:FONT lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentCenter];
    
    ///< 第二行,第四列,第一小行底线
    [[LVPDFDrawManager sharedInstance] drawLineFromPoint:CGPointMake(WIDTH/2, Y + PART_TWO_LITTLEROW_HEIGHT) toPoint:CGPointMake(WIDTH/2 + PART_ONE_ROW_THREE_COLUMNWIDTH, Y + PART_TWO_LITTLEROW_HEIGHT)];

    ///< 第二行,第四列,第二小行底线
    [[LVPDFDrawManager sharedInstance] drawLineFromPoint:CGPointMake(WIDTH/2, Y + 2 * PART_TWO_LITTLEROW_HEIGHT) toPoint:CGPointMake(WIDTH/2 + PART_ONE_ROW_THREE_COLUMNWIDTH, Y + 2 * PART_TWO_LITTLEROW_HEIGHT)];
    
    ///< 第二行,第五列右线
    [[LVPDFDrawManager sharedInstance] drawLineFromPoint:CGPointMake(WIDTH - X - PART_ONE_ROW_THREE_COLUMNWIDTH / 2, Y) toPoint:CGPointMake(WIDTH - X - PART_ONE_ROW_THREE_COLUMNWIDTH / 2, Y + 3 * PART_TWO_LITTLEROW_HEIGHT)];
    
    ///< 记录人
    [[LVPDFDrawManager sharedInstance] printStr:TEXT_RECORD_PERSON CGRect:CGRectMake(WIDTH/2 + PART_ONE_ROW_THREE_COLUMNWIDTH, Y + ONEROW_GET_Y(3 * PART_TWO_LITTLEROW_HEIGHT), PART_ONE_ROW_THREE_COLUMNWIDTH / 2, FONT_HEIGHT) Font:FONT lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentCenter];

    ///< 第三行的初始Y值
    Y += 3 * PART_TWO_LITTLEROW_HEIGHT;
    
    ///< 第三行底线
    [[LVPDFDrawManager sharedInstance] drawLineFromPoint:CGPointMake(X, Y + 5 * PART_TWO_LITTLEROW_HEIGHT) toPoint:CGPointMake(WIDTH - X, Y + 5 * PART_TWO_LITTLEROW_HEIGHT)];
    
    ///< 现场人员基本情况
    [[LVPDFDrawManager sharedInstance] printStr:TEXT_BASIC_INFORMATION CGRect:CGRectMake(X, Y + BASIC_INFORMATION_Y, PART_ONE_COLUMNWIDTH, BASIC_INFORMATION_HEIGHT) Font:FONT lineSpacing:LINESPACING lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentCenter];

    ///< 第三行,小行底线
    for (NSInteger i = 1; i < 5; i ++) {
        [[LVPDFDrawManager sharedInstance] drawLineFromPoint:CGPointMake(X + PART_ONE_COLUMNWIDTH, Y + i * PART_TWO_LITTLEROW_HEIGHT) toPoint:CGPointMake(WIDTH - X, Y + i * PART_TWO_LITTLEROW_HEIGHT)];
    }
    
    ///< 姓名
    [[LVPDFDrawManager sharedInstance] printStr:TEXT_NAME CGRect:CGRectMake(X + PART_ONE_COLUMNWIDTH, Y + ONEROW_GET_Y(PART_TWO_LITTLEROW_HEIGHT), PART_ONE_ROW_TWO_COLUMNWIDTH / 2, FONT_HEIGHT) Font:FONT lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentCenter];
    
    ///< 身份证号
    [[LVPDFDrawManager sharedInstance] printStr:TEXT_ID_NUMBER CGRect:CGRectMake(X + PART_ONE_COLUMNWIDTH, Y + ONEROW_GET_Y(PART_TWO_LITTLEROW_HEIGHT) + PART_TWO_LITTLEROW_HEIGHT, PART_ONE_ROW_TWO_COLUMNWIDTH / 2, FONT_HEIGHT) Font:FONT lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentCenter];
    
    ///< 单位及职务
    [[LVPDFDrawManager sharedInstance] printStr:TEXT_WORK_UNIT_POST CGRect:CGRectMake(X + PART_ONE_COLUMNWIDTH, Y + ONEROW_GET_Y(PART_TWO_LITTLEROW_HEIGHT) + 2 * PART_TWO_LITTLEROW_HEIGHT, PART_ONE_ROW_TWO_COLUMNWIDTH / 2, FONT_HEIGHT) Font:FONT lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentCenter];
    
    ///< 联系地址
    [[LVPDFDrawManager sharedInstance] printStr:TEXT_CONTACT_ADDRESS CGRect:CGRectMake(X + PART_ONE_COLUMNWIDTH, Y + ONEROW_GET_Y(PART_TWO_LITTLEROW_HEIGHT) + 3 * PART_TWO_LITTLEROW_HEIGHT, PART_ONE_ROW_TWO_COLUMNWIDTH / 2, FONT_HEIGHT) Font:FONT lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentCenter];
    
    ///< 车号
    [[LVPDFDrawManager sharedInstance] printStr:TEXT_CAR_NUMBER CGRect:CGRectMake(X + PART_ONE_COLUMNWIDTH, Y + ONEROW_GET_Y(PART_TWO_LITTLEROW_HEIGHT) + 4 * PART_TWO_LITTLEROW_HEIGHT, PART_ONE_ROW_TWO_COLUMNWIDTH / 2, FONT_HEIGHT) Font:FONT lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentCenter];
    
    ///< 第三行第三列上三行右线
    [[LVPDFDrawManager sharedInstance] drawLineFromPoint:CGPointMake(PART_THREE_ROW_FOUR_COLUMNX, Y) toPoint:CGPointMake(PART_THREE_ROW_FOUR_COLUMNX, Y + 3 * PART_TWO_LITTLEROW_HEIGHT)];
    
    ///< 第三行第四列上三行右线
    [[LVPDFDrawManager sharedInstance] drawLineFromPoint:CGPointMake(WIDTH - X - PART_ONE_ROW_THREE_COLUMNWIDTH, Y) toPoint:CGPointMake(WIDTH - X - PART_ONE_ROW_THREE_COLUMNWIDTH, Y + 3 * PART_TWO_LITTLEROW_HEIGHT)];
   
    ///< 第三行第三列第五小行右线
    [[LVPDFDrawManager sharedInstance] drawLineFromPoint:CGPointMake(PART_THREE_ROW_FOUR_COLUMNX, Y + 4 * PART_TWO_LITTLEROW_HEIGHT) toPoint:CGPointMake(PART_THREE_ROW_FOUR_COLUMNX, Y + 5 * PART_TWO_LITTLEROW_HEIGHT)];
    
    ///< 第三行第四列上第五小行右线
    [[LVPDFDrawManager sharedInstance] drawLineFromPoint:CGPointMake(WIDTH - X - PART_ONE_ROW_THREE_COLUMNWIDTH, Y + 4 * PART_TWO_LITTLEROW_HEIGHT) toPoint:CGPointMake(WIDTH - X - PART_ONE_ROW_THREE_COLUMNWIDTH, Y + 5 * PART_TWO_LITTLEROW_HEIGHT)];

    ///< 项目名称
    [[LVPDFDrawManager sharedInstance] printStr:TEXT_PROJECT_NAME CGRect:CGRectMake(PART_THREE_ROW_FOUR_COLUMNX, Y + ONEROW_GET_Y(PART_TWO_LITTLEROW_HEIGHT), 3 * PART_ONE_ROW_THREE_COLUMNWIDTH / 5, PART_TWO_LITTLEROW_HEIGHT) Font:FONT lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentCenter];
    
    ///< 与案件关系
    [[LVPDFDrawManager sharedInstance] printStr:TEXT_CASE_RELATIONSHIP CGRect:CGRectMake(PART_THREE_ROW_FOUR_COLUMNX, Y + ONEROW_GET_Y(PART_TWO_LITTLEROW_HEIGHT) + PART_TWO_LITTLEROW_HEIGHT, 3 * PART_ONE_ROW_THREE_COLUMNWIDTH / 5, PART_TWO_LITTLEROW_HEIGHT) Font:FONT lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentCenter];
    
    ///< 联系电话
    [[LVPDFDrawManager sharedInstance] printStr:TEXT_PHONE CGRect:CGRectMake(PART_THREE_ROW_FOUR_COLUMNX, Y + ONEROW_GET_Y(PART_TWO_LITTLEROW_HEIGHT) + 2 * PART_TWO_LITTLEROW_HEIGHT, 3 * PART_ONE_ROW_THREE_COLUMNWIDTH / 5, PART_TWO_LITTLEROW_HEIGHT) Font:FONT lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentCenter];
    
    ///< 车（船）型
    [[LVPDFDrawManager sharedInstance] printStr:TEXT_CAR_TYPE CGRect:CGRectMake(PART_THREE_ROW_FOUR_COLUMNX, Y + ONEROW_GET_Y(PART_TWO_LITTLEROW_HEIGHT) + 4 * PART_TWO_LITTLEROW_HEIGHT, 3 * PART_ONE_ROW_THREE_COLUMNWIDTH / 5, PART_TWO_LITTLEROW_HEIGHT) Font:FONT lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentCenter];
    
    ///< 第四行的初始Y值
    Y += 5 * PART_TWO_LITTLEROW_HEIGHT;
    
    ///< 主要内容
    [[LVPDFDrawManager sharedInstance] printStr:TEXT_MAIN_CONTENT CGRect:CGRectMake(X, Y + TWOROW_GET_Y(PART_FOUR_ROW_HEIGHT), PART_ONE_COLUMNWIDTH, TEXT_TWO_ROW_HEIGHT) Font:FONT lineSpacing:LINESPACING lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentCenter];
    
    ///< 第四行第二列文字的初始Y值
    Y += PART_FOUR_TEXT_LEFT_OFFSET;
    
    ///< 在检查中发现
//    [[LVPDFDrawManager sharedInstance] printStr:TEXT_FIND CGRect:CGRectMake(X + PART_ONE_COLUMNWIDTH + PART_FOUR_TEXT_LEFT_OFFSET, Y, TEXT_WIDTH(TEXT_FIND), FONT_HEIGHT) Font:FONT lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentLeft];
    
    ///< 线
    [[LVPDFDrawManager sharedInstance] drawLineFromPoint:CGPointMake(X + PART_ONE_COLUMNWIDTH + PART_FOUR_TEXT_LEFT_OFFSET + TEXT_WIDTH(TEXT_FIND), LINE_Y) toPoint:CGPointMake(WIDTH - X - PART_FOUR_TEXT_LEFT_OFFSET, LINE_Y)];
    
    ///< 4条线
    for (NSInteger i = 0; i < 4 ; i ++) {
        Y = TEXT_Y;
        
        [[LVPDFDrawManager sharedInstance] drawLineFromPoint:CGPointMake(X + PART_ONE_COLUMNWIDTH + PART_FOUR_TEXT_LEFT_OFFSET, LINE_Y) toPoint:CGPointMake(WIDTH - X - PART_FOUR_TEXT_LEFT_OFFSET, LINE_Y)];
    }
    
    ///< 第四行第二列第六行文字的初始Y值
    Y = TEXT_Y;
    
    ///< 上述笔录
    [[LVPDFDrawManager sharedInstance] printStr:TEXT_CHECK CGRect:CGRectMake(X + PART_ONE_COLUMNWIDTH + PART_FOUR_TEXT_LEFT_OFFSET, Y, WIDTH - 2 * X - TEXT_CHECK_RIGHT_OFFSET - PART_ONE_COLUMNWIDTH - PART_FOUR_TEXT_LEFT_OFFSET, FONT_HEIGHT) Font:FONT lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentRight];
    
    ///< 第四行第二列第七行文字的初始Y值
    Y = TEXT_Y;

    ///< 当事人签名
    [[LVPDFDrawManager sharedInstance] printStr:TEXT_PARTIES_AUTOGRAPH CGRect:CGRectMake(X + PART_ONE_COLUMNWIDTH + PART_FOUR_TEXT_LEFT_OFFSET, Y, WIDTH - 2 * X - TEXT_CHECK_RIGHT_OFFSET - PART_ONE_COLUMNWIDTH - PART_FOUR_TEXT_LEFT_OFFSET, FONT_HEIGHT) Font:FONT lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentRight];
    
    ///< 第四行第二列第八行文字的初始Y值
    Y = TEXT_Y;

    ///< 时间
    [[LVPDFDrawManager sharedInstance] printStr:TEXT_TIME CGRect:CGRectMake(X + PART_ONE_COLUMNWIDTH + PART_FOUR_TEXT_LEFT_OFFSET, Y, WIDTH - 2 * X - TEXT_CHECK_RIGHT_OFFSET - PART_ONE_COLUMNWIDTH - PART_FOUR_TEXT_LEFT_OFFSET, FONT_HEIGHT) Font:FONT lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentRight];
    
    Y = INIT_Y + PART_ONE_ROW_HEIGHT + 8 * PART_TWO_LITTLEROW_HEIGHT + PART_FOUR_TEXT_LEFT_OFFSET;
    
    NSString *string = @"在检查中发现：靓仔驾驶粤A100866小型轿车于行至北二环高速公路往深圳入匝道，由于驾驶不当发生交通事故损坏公路路产，无人员伤亡";
    [[LVPDFDrawManager sharedInstance] printStr:string CGRect:CGRectMake(X + PART_ONE_COLUMNWIDTH + PART_FOUR_TEXT_LEFT_OFFSET, Y, WIDTH - 2 * PART_FOUR_TEXT_LEFT_OFFSET - 2 * X - PART_ONE_COLUMNWIDTH, HEIGHT) Font:FONT lineSpacing:SPACE lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentLeft];}

///< 获取字体大小18的宽度
- (CGFloat)getTextWidthWithText:(NSString *)text
{
    return [text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"STSong" size:FONT], NSFontAttributeName, nil]].width;
}


@end
