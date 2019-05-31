//
//  DetailView.m
//  SchoolBusSystem
//
//  Created by Jy on 2018/3/29.
//  Copyright © 2018年 jiaoyin. All rights reserved.
//

#import "DetailView.h"

@implementation DetailView

//绘制带箭头的矩形
-(void)drawArrowRectangle:(CGRect) frame
{
    // 获取当前图形，视图推入堆栈的图形，相当于你所要绘制图形的图纸
    CGContextRef ctx =UIGraphicsGetCurrentContext();
    // 创建一个新的空图形路径。
    CGContextBeginPath(ctx);
    //启始位置坐标x，y
    CGFloat origin_x = frame.origin.x;
    CGFloat origin_y = frame.origin.y;
    //第一条线的位置坐标
    CGFloat line_1_x = frame.size.width;
    CGFloat line_1_y = origin_y;
    //第二条线的位置坐标
    CGFloat line_2_x = line_1_x;
    CGFloat line_2_y = frame.size.height-10;
    //第三条线的位置坐标
    CGFloat line_3_x = origin_x;
    CGFloat line_3_y = line_2_y;
    //尖角的顶点位置坐标
    CGFloat line_4_x = line_1_x/2;
    CGFloat line_4_y = frame.size.height;
    //第五条线位置坐标
    CGFloat line_5_x = origin_x+line_1_x/2-10;
    CGFloat line_5_y = line_2_y;
    //第六条线位置坐标
    CGFloat line_6_x = origin_x+line_1_x/2 + 10;
    CGFloat line_6_y = line_3_y;
    //第七条线位置坐标
    CGFloat line_7_x = origin_x;
    CGFloat line_7_y = line_2_y;
    
    CGContextMoveToPoint(ctx, origin_x, origin_y);

    CGContextAddLineToPoint(ctx, line_1_x, line_1_y);
    CGContextAddLineToPoint(ctx, line_2_x, line_2_y);
    CGContextAddLineToPoint(ctx, line_3_x, line_3_y);
    CGContextAddLineToPoint(ctx, line_6_x, line_6_y);
    CGContextAddLineToPoint(ctx, line_4_x, line_4_y);
    CGContextAddLineToPoint(ctx, line_5_x, line_5_y);
    CGContextAddLineToPoint(ctx, line_7_x, line_7_y);
    
    CGContextClosePath(ctx);
    
    UIColor *costomColor = [UIColor whiteColor];
    CGContextSetFillColorWithColor(ctx, costomColor.CGColor);
    
    CGContextFillPath(ctx);
    
}

//重写绘图，调用刚才绘图的方法
-(void)drawRect:(CGRect)rect
{
//    CGRect frame = rect;
//    frame.size.height = frame.size.height;
//    rect = frame;
    //绘制带箭头的框框
//    [self drawArrowRectangle:rect];
    
    float w = rect.size.width;
    float h = rect.size.height - 10;
    
    // 获取文本
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 设置 边线宽度
    CGContextSetLineWidth(context, 0.2);
//    //边框颜色
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
//    //矩形填充颜色
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    
    
    /** 先介绍 CGContextAddArcToPoint 参数
     * CGContextRef : 为获取的文本
     * x1, y1 : 第一点
     * x2, y2 : 第二点
     * radius : 圆角弧度
     * 说明 : 两点连线 如同矢量线, 有方向性.
     */
    
    // [开始点] 坐标从左上角开始 (6, 0)
    CGContextMoveToPoint(context, 6, 0);
    // 设置 第一点 第二点 弧度. 详解 : [开始点]到[第一点], 确定一条直线 (6, 0) -> (w, 0); [第一点]到[第二点]确定一条直线(w, 0)->(w, 10)
    // 两条线连接与方向 为直角 设置弧度
    CGContextAddArcToPoint(context, w, 0, w, 10, 6); // 右上角圆弧设置完
    
    // 现在 [开始点] 坐标变为 (w, 10). 第一条线(w, 10) -> (w , h) ; 第二条线(w, h) -> (w - 10, h).
    CGContextAddArcToPoint(context, w , h , w - 10, h, 6); // 右下角圆弧设置完
    
    // 现在 [开始点] 坐标变为 (w - 10, h) . 由 (w - 10, h) -> (30, h) 向左画直线
    CGContextAddLineToPoint(context, w/2+10, h ); // 向左画线
    
    // 现在 [开始点] 坐标变为 (30, h). 由(30, h) -> (25, h + 8) 向左下画直线
    CGContextAddLineToPoint(context, w/2, h + 10); // 左下直线
    
    // 现在 [开始点] 坐标变为 (25, h + 8). 由 (25, h + 8)-> (20, h) 向左上画直线
    CGContextAddLineToPoint(context, w/2-10, h ); // 左上直线
    
    // 现在 [开始点] 坐标变为 (20, h ). 第一条线(20, h)-> (0, h) ; 第二条线(0, h)->(0, h - 10)
    CGContextAddArcToPoint(context, 0, h, 0, h - 10, 6); // 左下角圆弧设置完
    
    // 现在 [开始点] 坐标变为 (0, h - 10 ). 第一条线(0, h - 10)-> (0, 0) ; 第二条线(0, 0)->(6, 0)
    // 说明: 最开始设置的坐标点为(6, 0) 不为(0, 0). 就是为了最后可以连接上, 不然 画的线不能连接上 , 读者可自行试验
    CGContextAddArcToPoint(context, 0, 0, 6, 0, 6); // 左上角圆弧设置完
    
    CGContextDrawPath(context, kCGPathFillStroke); //根据坐标绘制路径
}

@end
