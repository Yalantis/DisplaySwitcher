# Display Switcher
[![Platform](http://img.shields.io/badge/platform-iOS-blue.svg?style=flat)](http://cocoapods.org/?q=YALSideMenu) [![License](http://img.shields.io/badge/license-MIT-green.svg?style=flat)]() [![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

This component implements custom transition between two collection view layouts with custom animation duration.

[![Yalantis](https://raw.githubusercontent.com/Yalantis/PullToRefresh/develop/PullToRefreshDemo/Resources/badge_dark.png)](https://yalantis.com/?utm_source=github)

<img src="https://d13yacurqjgara.cloudfront.net/users/116693/screenshots/2276068/open-uri20151005-3-walc59" />

Check this <a href="https://dribbble.com/shots/2276068-Contact-Display-Switch">project on dribbble</a>.

Also, read how it was done in [our blog](…)

##Requirements
- iOS 8.0+ (for component), iOS 9.0+ (for example)
- Xcode 7
- Swift 2

##Installing with [CocoaPods](https://cocoapods.org)

```ruby
use_frameworks!
pod ‘DisplaySwitcher’, '~> 0.1.0'
```

##Installing with [Carthage](https://github.com/Carthage/Carthage)

```ruby
github "Yalantis/DisplaySwitcher" ~> 0.1.0
```

##Usage

At first, import DisplaySwitcher:
```swift
import DisplaySwitcher
```

Then create two layouts (layout for list mode and grid mode):
```swift
private lazy var listLayout = BaseLayout(staticCellHeight: listLayoutStaticCellHeight, nextLayoutStaticCellHeight: gridLayoutStaticCellHeight, layoutState: .ListLayoutState)

private lazy var gridLayout = BaseLayout(staticCellHeight: gridLayoutStaticCellHeight, nextLayoutStaticCellHeight: listLayoutStaticCellHeight, layoutState: .GridLayoutState)
```

Set current layout:
```swift
private var layoutState: CollectionViewLayoutState = .ListLayoutState
collectionView.collectionViewLayout = listLayout
```

Then override two UICollectionViewDataSource methods:
```swift
func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    // count of items
}

func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    // configure your custom cell
}
```

Also override one UICollectionViewDelegate method (for custom layout transition):
```swift
func collectionView(collectionView: UICollectionView, transitionLayoutForOldLayout fromLayout: UICollectionViewLayout, newLayout toLayout: UICollectionViewLayout) -> UICollectionViewTransitionLayout {
    let customTransitionLayout = TransitionLayout(currentLayout: fromLayout, nextLayout: toLayout)
    return customTransitionLayout
}
```
And in the end necessary create transition and start it (you can simply change animation duration for transition layout and for rotation button):
```swift
let transitionManager: TransitionManager
if layoutState == .ListLayoutState {
    layoutState = .GridLayoutState
    transitionManager = TransitionManager(duration: animationDuration, collectionView: collectionView!, destinationLayout: gridLayout, layoutState: layoutState)
} else {
    layoutState = .ListLayoutState
    transitionManager = TransitionManager(duration: animationDuration, collectionView: collectionView!, destinationLayout: listLayout, layoutState: layoutState)
}
transitionManager.startInteractiveTransition()
rotationButton.selected = layoutState == .ListLayoutState
rotationButton.animationDuration = animationDuration
```

Have fun! :)

#### Let us know!

We’d be really happy if you sent us links to your projects where you use our component. Just send an email to github@yalantis.com And do let us know if you have any questions or suggestion regarding the animation. 

P.S. We’re going to publish more awesomeness wrapped in code and a tutorial on how to make UI for iOS (Android) better than better. Stay tuned!

## License

The MIT License (MIT)

Copyright © 2016 Yalantis

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

