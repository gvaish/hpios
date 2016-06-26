### High Performance iOS Apps

This repository contains the code for the app accompanying the book - High Performance iOS Apps.

### Have a suggestion or want to report a bug?

Use [Issues](https://github.com/gvaish/hpios/issues)


### Building the app

You will need Cocoapods 1.0.0 or later to install the dependencies.

```
$ git clone https://github.com/gvaish/hpios.git
$ cd high-performance-ios-apps/src
$ pod install
$ open HighPerformance.xcworkspace
```

Enjoy!

### Related Links

* iTunes App Store: http://apple.co/28WvC7N
* Print: http://amzn.to/24NEg9f
* Digital: http://amzn.to/28Yl9He

### ToC of the Book

1. Performance in Mobile Apps: The aspects of an app that we want to optimize, and the parameters that we want to measure.
1. Memory Management: Memory management model, object reference types and best practices for design patterns that impact memory consumption.
1. Energy: Minimizing energy consumption.
1. Concurrent Programming: GCD, Threads, Operation Queues. And did I say GCD?
1. Application Lifecycle: Lifecycle events and how to use them effectively for better resource management.
1. User Interface: Optimizing your views - `UILabel`, `UIButton`, `UITableView`, `UICollectionView`, `UIImageView`, custom views. Composite Views. Direct Drawing.
1. Network: HTTP vs HTTPS, DNS lookgup and latencies. Data formats - JSON, Protobuf et al. Data compression. And more.
1. Data Sharing: Deep Linking, Pasteboards, Document Interaction. App Extensions.
1. Security: Access, Network security, local storage, data sharing. And their impact on performance.
1. Testing and Release: Unit testing, Functional testing, Performance testing. Dependency Injection, Isolation and Mocking. Continuous Integration.
1. Tools: Accessibility Inspector, Instruments, Xcode View Debugger, Charles proxy. And a bonus tool in the book.
1. Instrumentation and Analytics: Planning, Implementation, Deployment. Instrumentation vs Analytics. Real User Monitoring (RUM).
1. iOS 9: Universal Links, Search. Updates in `UIKit` framework. Safari Services framework. New extensions - content blocker, spotlight index. Whole new ecosystem of app thining - slicing, on-demand resources, bitcode.


