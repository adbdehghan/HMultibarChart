//
//  MultibarChart.swift
//  MultibarChart
//
//  Created by Adib.
//

import UIKit

// Model representing each bar data item
public struct BarDataItem: Equatable {
    public let name: String
    public let count: Double
    public var color: UIColor?
    
    
    public init(name: String, count: Double, color: UIColor? = nil) {
        self.name = name
        self.count = count
        self.color = color
    }
            
    public static func ==(lhs: BarDataItem, rhs: BarDataItem) -> Bool {
        return lhs.name == rhs.name && lhs.count == rhs.count && lhs.color == rhs.color
    }
}

public class MultiBarView: UIView {
    
    // MARK: - Public Configurable Properties
    
    /// The data items to display. Setting this will trigger a layout update.
    public var items: [BarDataItem] = [] {
        didSet {
            // Basic check to avoid unnecessary processing if data hasn't changed.
            if oldValue != items {
                prepareDataAndRequestLayout()
            }
        }
    }
    
    /// Maximum number of individual items to show before grouping extras into "Other".
    public var maxVisibleItems: Int = 3 {
        didSet { if oldValue != maxVisibleItems { prepareDataAndRequestLayout() } }
    }
    
    /// Margin between bars.
    public var barMargin: CGFloat = 6.0 {
        didSet { if oldValue != barMargin { requestLayoutUpdate() } }
    }
    
    /// Corner radius for the bars.
    public var barCornerRadius: CGFloat = 2.0 {
        didSet { if oldValue != barCornerRadius { requestLayoutUpdate() } }
    }
    
    /// A palette of colors to cycle through for items that don't have a pre-assigned color.
    public var colorPalette: [UIColor] = [.systemBlue, .systemGreen, .systemOrange, .systemRed, .systemPurple] {
        didSet { if oldValue != colorPalette { prepareDataAndRequestLayout() } }
    }
    
    /// Default color for the "Other" category bar.
    public var defaultOtherColor: UIColor = .systemGray {
        didSet { if oldValue != defaultOtherColor { prepareDataAndRequestLayout() } }
    }
    
    /// Font for the labels below the bars.
    public var labelFont: UIFont = UIFont.systemFont(ofSize: 10) { // Replace with your AppFont if needed
        didSet { if oldValue != labelFont { requestLayoutUpdate() } }
    }
    
    /// Text color for the labels.
    public var labelTextColor: UIColor = .label { // Using semantic color
        didSet { if oldValue != labelTextColor { requestLayoutUpdate() } }
    }
    
    /// Height allocated for the labels.
    public var labelHeight: CGFloat = 20.0 {
        didSet { if oldValue != labelHeight { requestLayoutUpdate() } }
    }
    
    /// Padding between the bottom of the bar and the top of its label.
    public var barBottomToLabelTopPadding: CGFloat = 2.0 {
        didSet { if oldValue != barBottomToLabelTopPadding { requestLayoutUpdate() } }
    }
    
    // MARK: - Private Properties
    private var processedItemsForDisplay: [BarDataItem] = []
    private var barSubviews: [UIView] = []
    private var labelSubviews: [UILabel] = []
    
    // MARK: - Initialization
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit() // Make commonInit private or internal
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit() // Make commonInit private or internal
    }
    
    
    private func commonInit() {
        // Initial setup, if any, that doesn't depend on frame or data
    }
    
    // MARK: - Data Handling and Layout Triggers
    
    /// Sets the data for the bar view.
    /// - Parameter newItems: An array of `BarDataItem` to display.
    public func setData(_ newItems: [BarDataItem]) {
        self.items = newItems // Triggers didSet observer
    }
    
    private func prepareDataAndRequestLayout() {
        // 1. Filter out zero/negative count items and sort by count descending
        let validAndSortedItems = items
            .filter { $0.count > 0 }
            .sorted { $0.count > $1.count }
        
        // 2. Determine items to display directly and those to group into "Other"
        let itemsToDisplayDirectly = Array(validAndSortedItems.prefix(maxVisibleItems))
        let remainingItemsToGroup = validAndSortedItems.dropFirst(maxVisibleItems)
        
        var finalItems = itemsToDisplayDirectly
        
        if !remainingItemsToGroup.isEmpty {
            let otherCount = remainingItemsToGroup.reduce(0) { $0 + $1.count }
            if otherCount > 0 {
                finalItems.append(BarDataItem(name: "Other", count: otherCount, color: defaultOtherColor))
            }
        }
        
        // 3. Assign colors if not already set (using palette)
        var colorPaletteIndex = 0
        self.processedItemsForDisplay = finalItems.map { item in
            var mutableItem = item
            if mutableItem.color == nil { // If no color is pre-assigned
                if item.name == "Other" {
                    mutableItem.color = defaultOtherColor
                } else if !colorPalette.isEmpty {
                    mutableItem.color = colorPalette[colorPaletteIndex % colorPalette.count]
                    colorPaletteIndex += 1
                } else {
                    mutableItem.color = UIColor.randomFallback() // Fallback if palette is empty
                }
            }
            return mutableItem
        }
        requestLayoutUpdate()
    }
    
    private func requestLayoutUpdate() {        
        setNeedsLayout()
    }
    
    // MARK: - Drawing and Layout
    public override func layoutSubviews() {
        super.layoutSubviews()
        renderBarsAndLabels()
    }
    
    private func renderBarsAndLabels() {
        
        barSubviews.forEach { $0.removeFromSuperview() }
        labelSubviews.forEach { $0.removeFromSuperview() }
        barSubviews.removeAll()
        labelSubviews.removeAll()
        
        guard !processedItemsForDisplay.isEmpty else { return }
        
        let totalValueForProportion = processedItemsForDisplay.reduce(0) { $0 + $1.count }
        guard totalValueForProportion > 0 else { return }
        
        let totalMarginWidth = barMargin * CGFloat(max(0, processedItemsForDisplay.count - 1))
        let availableWidthForBars = bounds.width - totalMarginWidth
        
        guard availableWidthForBars > 0 else { return } // Not enough space to draw
        
        var currentX: CGFloat = 0
        
        var calculatedBarWidths: [CGFloat] = processedItemsForDisplay.map { item in
            CGFloat(item.count / totalValueForProportion) * availableWidthForBars
        }
        
        // Optional: "Other" bar width adjustment logic.
        // This makes the "Other" bar no wider than the Nth item.
        
        if processedItemsForDisplay.count > maxVisibleItems && processedItemsForDisplay.last?.name == "Other" {
            if maxVisibleItems > 0 && calculatedBarWidths.count > maxVisibleItems {
                // Index of the last *actual* item (before "Other")
                let indexOfLastActualItem = maxVisibleItems - 1
                // Index of the "Other" item
                let indexOfOtherItem = maxVisibleItems
                
                if calculatedBarWidths.indices.contains(indexOfLastActualItem) && calculatedBarWidths.indices.contains(indexOfOtherItem) {
                    let widthOfLastActualItem = calculatedBarWidths[indexOfLastActualItem]
                    calculatedBarWidths[indexOfOtherItem] = min(calculatedBarWidths[indexOfOtherItem], widthOfLastActualItem)
                }
            }
        }
        
        
        for (index, item) in processedItemsForDisplay.enumerated() {
            let barWidth = calculatedBarWidths[index]
            guard barWidth >= 0.5 else { continue } // Don't draw bars that are too tiny to see
            
            // Create Bar View
            let barView = UIView()
            barView.backgroundColor = item.color ?? UIColor.randomFallback()
            barView.layer.cornerRadius = barCornerRadius
            barView.layer.masksToBounds = true
            
            let barHeight = bounds.height - labelHeight - barBottomToLabelTopPadding
            barView.frame = CGRect(x: currentX, y: 0, width: barWidth, height: max(0, barHeight))
            
            addSubview(barView)
            barSubviews.append(barView)
            
            // Create Label View
            if labelHeight > 0 {
                let label = UILabel()
                label.text = item.name
                label.font = labelFont
                label.textColor = labelTextColor
                label.textAlignment = .left 
                label.adjustsFontSizeToFitWidth = true
                label.minimumScaleFactor = 0.5 // Allow text to shrink
                
                label.frame = CGRect(x: currentX, y: bounds.height - labelHeight, width: barWidth, height: labelHeight)
                
                addSubview(label)
                labelSubviews.append(label)
            }
            
            currentX += barWidth
            if index < processedItemsForDisplay.count - 1 {
                currentX += barMargin
            }
        }
    }
}

// Extension for a fallback random color
extension UIColor {
    static func randomFallback() -> UIColor {
        return UIColor(
            red: .random(in: 0.2...0.8), // Avoid extremes to improve chance of visible text
            green: .random(in: 0.2...0.8),
            blue: .random(in: 0.2...0.8),
            alpha: 1.0
        )
    }
}
