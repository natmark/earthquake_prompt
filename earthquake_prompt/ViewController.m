//
//  ViewController.m
//  earthquake_prompt
//
//  Created by SATO on 2014/10/02.
//  Copyright (c) 2014年 AtsuyaSato. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self getData];
    
}
#pragma mark データ取得
- (void)getData{
    
    UITextView* textView = [[UITextView alloc]init];
    textView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-100);
    textView.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    [self.view addSubview:textView];
 
    
    // Create the url-request.
    NSURL *url = [NSURL URLWithString:@"http://www.jma.go.jp/jp/quake/quake_local_index.html"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    // Set the method(HTTP-GET)
    [request setHTTPMethod:@"GET"];
    
    // Send the url-request.
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if (data) {
                                   NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                   
                                   // </td></tr>で分割
                                   NSArray* values = [result componentsSeparatedByString:@"</td></tr>"];
                                   
                                   NSString* string1 = [[NSString alloc]init];
                                   // カンマ区切りで分割した文字列を、一つ一つ処理したい場合は、次のような感じになります。
                                   for (NSInteger i =0; i < values.count-1; i++)
                                   {
                                       // 配列の要素は文字列型なので、NSString 型へ受けて扱うことができます。
                                       NSString* value = [values objectAtIndex:i];

                                       string1 = [NSString stringWithFormat:@"%@%@\n\n",string1,value];
                                   }
                                   
                                
                                    //<tr><td nowrap>で分割
                                   NSArray* values2 = [string1 componentsSeparatedByString:@"<tr><td nowrap>"];
                                   
                                   
                                  // カンマ区切りで分割した文字列を、一つ一つ処理したい場合は、次のような感じになります。
                                   NSString* string2 = [[NSString alloc]init];
                                   for (NSInteger i =1; i < values2.count; i++)
                                   {
                                       // 配列の要素は文字列型なので、NSString 型へ受けて扱うことができます。
                                       NSString* value = [values2 objectAtIndex:i];
                                       
                                       //正規表現"[0-9]+" 1文字以上0-9の連続
                                       NSString *pattern   = @"<a href=./[0-9]+-[0-9]+.html>";
                                       
                                       // 正規表現検索を実行
                                       NSRegularExpression *regex =
                                       [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:nil];
                                       NSTextCheckingResult *match =
                                       [regex firstMatchInString:value options:0 range:NSMakeRange(0, value.length)];
                                       
                                       // マッチした場合
                                       if(match.numberOfRanges) {
                                           
                                           //マッチした文字列
                                           NSString *resultAll = [value substringWithRange:[match rangeAtIndex:0]];
                                           
                                           //文字列置換
                                           value = [value stringByReplacingOccurrencesOfString:resultAll withString:@""];
                                       }
                                       //文字列置換
                                       value = [value stringByReplacingOccurrencesOfString:@"</a>" withString:@""];
                                       
                                       
                                       //文字列追加
                                       string2 = [NSString stringWithFormat:@"%@%@\n",string2,value];
                                       
                                       //======</td><td nowrap>で分割======//
                                       //=========[0]情報発表日時　[1]発生日時	[2]震央地名 [3]マグニチュード [4]最大震度を取得可能=========//
                                       
                                       //=================================//
                                   }
                                   
                                   
                                   textView.text = string2;
                                   
                            } else {
                                //エラー処理
                                   NSLog(@"error: %@", error);
                                textView.text =  [NSString stringWithFormat:@"error: %@", error];
                                                                    
                                   
                               }
                           }];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
