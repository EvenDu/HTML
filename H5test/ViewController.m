//
//  ViewController.m
//  H5test
//
//  Created by liuzhen on 2018/11/24.
//  Copyright © 2018 liuzhen. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WKWebView.h>
#import <WebKit/WKFrameInfo.h>
#import <JavaScriptCore/JavaScriptCore.h>

@interface ViewController () <WKNavigationDelegate,WKUIDelegate>


@property (strong, nonatomic) WKWebView *webView;

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
//    webview.backgroundColor = [UIColor redColor];
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    [self.view addSubview:self.webView];
    
////    NSString*homeDir =NSHomeDirectory();
//    NSString *folderPath = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
//    NSURL *url = [NSURL fileURLWithPath:folderPath];
////    NSURL *url = [NSURL URLWithString:@"http://sec.rockeyliu.com/?name=liuzhen"];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url] ;
//    [webview loadRequest:request];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html" inDirectory:@"H5"];
    
    NSURL *fileURL = [NSURL fileURLWithPath:path];
    
    [self.webView loadFileURL:fileURL allowingReadAccessToURL:fileURL];
    
}

#pragma Mark -- WKNavigationDelegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation

{
//    JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
//    NSString *textJS = @"payInfo('这里是JS中alert弹出的message')";
//    [context evaluateScript:textJS];
    NSString *str = [NSString stringWithFormat:@"testB('%@')",@"RockeyLiu"];
    
    NSArray *jsonArray = @[
                           @{@"BrandName":@"Mac Pro",@"Modul":@"$100.00",@"Quantity":@"0.00",@"Datecode":@"0.00",@"Detail":@"15寸"},
                           @{@"BrandName":@"iPhone",@"Modul":@"$100.00",@"Quantity":@"0.00",@"Datecode":@"0.00",@"Detail":@"XS MAX"},
                           @{@"BrandName":@"iPad",@"Modul":@"$100.00",@"Quantity":@"0.00",@"Datecode":@"0.00",@"Detail":@"10.9寸"},
                           ];
    
    NSError * error = nil;
    
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:jsonArray options:kNilOptions error:&error];
    NSString * jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *str1 = [NSString stringWithFormat:@"testJSON('%@')",jsonStr];
    
    [webView evaluateJavaScript:str completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        NSLog(@"%@-----%@", result, error);
    }];
    
    [webView evaluateJavaScript:str1 completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        NSLog(@"%@-----%@", result, error);
    }];
    
}

#pragma Mark -- WKUIDelegate
//接收到警告面板
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();//此处的completionHandler()就是调用JS方法时，`evaluateJavaScript`方法中的completionHandler
    }];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}





@end

