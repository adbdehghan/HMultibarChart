# MultiBarChart

A simple, customizable multi-bar chart view for iOS, built with UIKit. Display multiple data series as proportionally sized horizontal bars, with support for an "Other" category for smaller items.

![Swift Version](https://img.shields.io/badge/Swift-5.7%2B-orange.svg)
![Platform](https://img.shields.io/badge/Platform-iOS%2013%2B-blue.svg)
![SPM Compatible](https://img.shields.io/badge/SPM-Compatible-brightgreen.svg)
## Features

* Display multiple data items as a segmented bar.
* Automatically groups smaller items into an "Other" category.
* Customizable number of visible items before grouping.
* Customizable colors for bars (per item or via a palette).
* Adjustable margins, corner radius, and label properties.
* Easy to integrate using Swift Package Manager.

## Requirements

* iOS 13.0+
* Xcode 13.0+
* Swift 5.7+

## Installation

`MultiBarChart` is available via the Swift Package Manager.

1.  In Xcode, open your project and navigate to **File > Add Packages...**
2.  Enter the repository URL for this package: `[Your GitHub Repository URL for MultiBarChart]`
3.  Choose "Up to Next Major Version" for the version rule.
4.  Click "Add Package".
5.  Select the `MultiBarChart` library to add to your app's target.

## Usage

1.  **Import** the module in your Swift file:
    ```swift
    import MultiBarChart
    ```

2.  **Create and configure** an instance of `MultiBarView`:
    ```swift
    let multiBarView = MultiBarView()

    // Configure properties (see "Customization" below)
    multiBarView.maxVisibleItems = 3
    multiBarView.barMargin = 5.0
    multiBarView.colorPalette = [.systemBlue, .systemGreen, .systemRed]
    // ... other properties

    // Add to your view hierarchy and set up layout
    view.addSubview(multiBarView)
    multiBarView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
        multiBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
        multiBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        multiBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
        multiBarView.heightAnchor.constraint(equalToConstant: 80) // Example height
    ])
    ```

3.  **Provide data**: The data is an array of `BarDataItem` objects.
    ```swift
    let data: [BarDataItem] = [
        BarDataItem(name: "Category A", count: 50, color: .purple),
        BarDataItem(name: "Category B", count: 30), // Will use colorPalette
        BarDataItem(name: "Category C", count: 15),
        BarDataItem(name: "Category D", count: 5)  // Might go into "Other"
    ]
    multiBarView.setData(data)
    // or
    // multiBarView.items = data
    ```

### `BarDataItem`

The `BarDataItem` struct represents each segment in the bar:
```swift
public struct BarDataItem {
    public let name: String      // Name displayed in the label
    public let count: Double     // Value used to determine bar width
    public var color: UIColor?   // Optional specific color for this bar
    
    public init(name: String, count: Double, color: UIColor? = nil)
}
```

## Customization Properties

You can customize the appearance and behavior of `MultiBarView` using these public properties:

* `items: [BarDataItem]`: The data items to display.
* `maxVisibleItems: Int`: Max items before grouping into "Other". (Default: `3`)
* `barMargin: CGFloat`: Margin between bars. (Default: `6.0`)
* `barCornerRadius: CGFloat`: Corner radius for the bars. (Default: `2.0`)
* `colorPalette: [UIColor]`: Colors for items without a specific color. (Default: A system color palette)
* `defaultOtherColor: UIColor`: Color for the "Other" category. (Default: `.systemGray`)
* `labelFont: UIFont`: Font for the labels. (Default: `UIFont.systemFont(ofSize: 10)`)
* `labelTextColor: UIColor`: Text color for labels. (Default: `.label`)
* `labelHeight: CGFloat`: Height allocated for labels. (Default: `20.0`)
* `barBottomToLabelTopPadding: CGFloat`: Padding between bar and label. (Default: `2.0`)

## Contributing

Contributions are welcome! Please feel free to submit a pull request or open an issue.

## License

This project is licensed under the MIT License - see the `LICENSE.md` file for details.

```
MIT License

Copyright (c) [2025] [Adib]

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
