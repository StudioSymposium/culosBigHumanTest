//
//  ViewController.m
//  culosBigHumanTest
//
//  Created by Chris Culos on 1/4/16.
//  Copyright © 2016 Chris Culos. All rights reserved.
//

#import "ViewController.h"
#import "InstagramKit.h"
//
#import "ccBHImagesViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    
    NSURL *authURL = [[InstagramEngine sharedEngine] authorizationURL];
    [_authView loadRequest:[NSURLRequest requestWithURL:authURL]];
    
    _authView.delegate = self;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"Error: %@", error);
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSError *error;
    
    if ([[InstagramEngine sharedEngine] receivedValidAccessTokenFromURL:request.URL error:&error])
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ccBHImagesViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ccBHImagesView"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        NSLog(@"Authentication Required");
    }
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
