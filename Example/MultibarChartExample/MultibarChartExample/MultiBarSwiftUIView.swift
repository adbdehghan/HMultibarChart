//
//  MultiBarSwiftUIView.swift
//  MultibarChartExample
//
//  Created by Adib.
//

import SwiftUI
import UIKit
import MultiBarChart

public struct MultiBarSwiftUIView: UIViewRepresentable {
    // Data and configuration properties to be passed from SwiftUI
    public var items: [BarDataItem]
    public var maxVisibleItems: Int
    public var barMargin: CGFloat
    public var barCornerRadius: CGFloat
    public var colorPalette: [UIColor]
    public var defaultOtherColor: UIColor
    public var labelFont: UIFont
    public var labelTextColor: UIColor
    public var labelHeight: CGFloat
    public var barBottomToLabelTopPadding: CGFloat

    // Initializer to pass values from SwiftUI
    public init(items: [BarDataItem],
                maxVisibleItems: Int = 3,
                barMargin: CGFloat = 2.0,
                barCornerRadius: CGFloat = 2.0,
                colorPalette: [UIColor] = [.systemBlue, .systemGreen, .systemOrange, .systemRed, .systemPurple],
                defaultOtherColor: UIColor = .systemGray,
                labelFont: UIFont = UIFont.systemFont(ofSize: 10),
                labelTextColor: UIColor = .label, // Using .label from UIKit which adapts
                labelHeight: CGFloat = 20.0,
                barBottomToLabelTopPadding: CGFloat = 2.0) {
        self.items = items
        self.maxVisibleItems = maxVisibleItems
        self.barMargin = barMargin
        self.barCornerRadius = barCornerRadius
        self.colorPalette = colorPalette
        self.defaultOtherColor = defaultOtherColor
        self.labelFont = labelFont
        self.labelTextColor = labelTextColor
        self.labelHeight = labelHeight
        self.barBottomToLabelTopPadding = barBottomToLabelTopPadding
    }

    // Creates the MultiBarView instance
    public func makeUIView(context: Context) -> MultiBarView {
        let uiView = MultiBarView()        
        return uiView
    }

    // Updates the MultiBarView when SwiftUI state changes
    public func updateUIView(_ uiView: MultiBarView, context: Context) {
        // Pass all the dynamic properties to the UIKit view
        if uiView.items != items {
            uiView.items = items
        }
        
        uiView.maxVisibleItems = maxVisibleItems
        uiView.barMargin = barMargin
        uiView.barCornerRadius = barCornerRadius
        uiView.colorPalette = colorPalette
        uiView.defaultOtherColor = defaultOtherColor
        uiView.labelFont = labelFont
        uiView.labelTextColor = labelTextColor
        uiView.labelHeight = labelHeight
        uiView.barBottomToLabelTopPadding = barBottomToLabelTopPadding
    }
}

// Optional: Preview provider for SwiftUI Previews
struct MultiBarSwiftUIView_Previews: PreviewProvider {
    static var sampleData: [BarDataItem] = [
        BarDataItem(name: "BTC", count: 40, color: .orange),
        BarDataItem(name: "ETH", count: 30),
        BarDataItem(name: "ADA", count: 15),
        BarDataItem(name: "SOL", count: 10),
        BarDataItem(name: "DOT", count: 5),
        BarDataItem(name: "XRP", count: 3)
    ]

    static var previews: some View {
        VStack {
            Text("MultiBarChart")
                .font(.headline)
            
            MultiBarSwiftUIView(items: sampleData)
                .frame(height: 60)
                .padding()

            MultiBarSwiftUIView(
                items: [
                    BarDataItem(name: "Alpha", count: 60),
                    BarDataItem(name: "Beta", count: 25),
                    BarDataItem(name: "Gamma", count: 15, color: .purple)
                ],
                maxVisibleItems: 2,
                barMargin: 2,
                labelFont: .systemFont(ofSize: 12, weight: .bold),
                labelTextColor: .blue,
                labelHeight: 24
            )
            .frame(height: 60)
            .padding()
            .background(Color(uiColor: .systemGray6))
            .cornerRadius(10)
        }
        .padding()
    }
}
