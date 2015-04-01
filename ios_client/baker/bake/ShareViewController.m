//
//  ShareViewController.m
//  bake
//
//  Created by hiroberry on 3/30/15.
//  Copyright (c) 2015 hiroberry. All rights reserved.
//

#import "ShareViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface ShareViewController ()

@property NSString *quiche_type;

@end

@implementation ShareViewController

- (BOOL)isContentValid {
    // Do validation of contentText and/or NSExtensionContext attachments here
    return YES;
}

- (void)didSelectPost {
    // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
    
    // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.

    NSExtensionItem *inputItem = self.extensionContext.inputItems.firstObject;
    NSItemProvider *urlItemProvider = inputItem.attachments.firstObject;
    
    // URLを取り出す
    if ([urlItemProvider hasItemConformingToTypeIdentifier:(__bridge NSString *)kUTTypeURL]) {
        [urlItemProvider loadItemForTypeIdentifier:(__bridge NSString *)kUTTypeURL
                                           options:nil
                                 completionHandler:^(NSURL *url, NSError *error) {
                                     // kUTTypeURLの場合itemはNSURLクラスで渡される
                                     if (!error) {
                                         NSString *path = [url absoluteString];

                                         NSDictionary *param = @{
                                             @"url": path,
                                             @"quiche_type": @"main",
                                             @"user": @{
                                                 @"quiche_twitter_id": @"hiroberri"
                                             }
                                         };

                                         NSData *jsonData = nil;
                                         if([NSJSONSerialization isValidJSONObject:param]){
                                             jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
                                         }
                                         
                                         NSString *quiche_url = @"http://q.l0o0l.co/item/create";
                                         // リクエストの種類、ヘッダを設定する
                                         NSMutableURLRequest *request = [NSMutableURLRequest
                                                                         requestWithURL: [NSURL URLWithString: quiche_url]
                                                                         cachePolicy: NSURLRequestUseProtocolCachePolicy
                                                                         timeoutInterval: 10.0];

                                         [request setHTTPMethod: @"POST"];
                                         [request setValue: @"application/json"  forHTTPHeaderField: @"Accept"];
                                         [request setValue: @"application/json"  forHTTPHeaderField: @"Content-Type"];

                                         [request setValue: [NSString stringWithFormat: @"%lu", (unsigned long)[jsonData length]]  forHTTPHeaderField: @"Content-Length"];

                                         [request setHTTPBody: jsonData];

                                         // 共有セッションを取得し、サーバにリクエストを行う
                                         NSURLSession *session = [NSURLSession sharedSession];

                                         [[session dataTaskWithRequest: request  completionHandler: ^(NSData *data, NSURLResponse *response, NSError *error) {
                                             
                                             // レスポンスが成功か失敗かを見てそれぞれ処理を行う		
                                             if (response && ! error) {
                                                 NSString *responseString = [[NSString alloc] initWithData: data  encoding: NSUTF8StringEncoding];
                                                 NSLog(@"Succeeded: %@", responseString);
                                             }
                                             else {
                                                 NSLog(@"Failed: %@", error);
                                             }
                                             
                                         }] resume];
                                         
                                         [self.extensionContext completeRequestReturningItems:nil completionHandler:nil];
                                     }
                                 }];
     }
}

- (NSArray *)configurationItems {
    SLComposeSheetConfigurationItem *configurationItem = [[SLComposeSheetConfigurationItem alloc] init];

    configurationItem.title = @"Type";

    configurationItem.value = @"Quiche";

    configurationItem.tapHandler = ^(void){
        UIViewController *viewController = [[UIViewController alloc] init];
        [self pushConfigurationViewController:viewController];
    };

    return @[configurationItem];
}

@end
