# YXWebBrowser

[![CI Status](<http://img.shields.io/travis/Sternapara/YXWebBrowser.svg?style=flat>)](https://travis-ci.org/Sternapara/YXWebBrowser)

[![Version](<https://img.shields.io/cocoapods/v/YXWebBrowser.svg?style=flat>)](http://cocoapods.org/pods/YXWebBrowser)

[![License](<https://img.shields.io/cocoapods/l/YXWebBrowser.svg?style=flat>)](http://cocoapods.org/pods/YXWebBrowser)

[![Platform](<https://img.shields.io/cocoapods/p/YXWebBrowser.svg?style=flat>)](http://cocoapods.org/pods/YXWebBrowser)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## How to Use

1. add `App Transport Security Settings` in `info.plist`, set `Allow Arbitrary Loads` to `YES`

2. add framework `WebKit`, link as `optional`

### Push as a Navigation ViewController
```Objective-C
YXWebBrowserViewController *webBrowser = [YXWebBrowserViewController webBrowserWithURLString:kHost];
[self.navigationController pushViewController:webBrowser animated:YES];
```

### Present as a Modal ViewController
```Objective-C
YXWebBrowserViewController *webBrowser = [YXWebBrowserViewController webBrowserWithURLString:kHost];
[self presentViewController:[webBrowser navigationControllerForModalPresent] animated:YES completion:nil];
```

## Installation

YXWebBrowser is available through [CocoaPods](<http://cocoapods.org>). To install

it, simply add the following line to your Podfile:

```ruby

pod 'YXWebBrowser', '~> 0.1.0'

```

## Author

Sternapara, yxuan426@163.com

## License

YXWebBrowser is available under the MIT license. See the LICENSE file for more info.