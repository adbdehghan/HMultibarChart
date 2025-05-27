//
//  ContentView.swift
//  MultibarChartExample
//
//  Created by Adib.
//

import SwiftUI
import MultiBarChart
                     
struct ContentView: View {
    // Sample data - typically this would come from a ViewModel or @State
    @State private var cryptoData: [BarDataItem] = [
        BarDataItem(name: "BTC", count: 45, color: UIColor.orange), // Use UIColor
        BarDataItem(name: "ETH", count: 35, color: UIColor.systemBlue.withAlphaComponent(0.7)),
        BarDataItem(name: "ADA", count: 12),
        BarDataItem(name: "SOL", count: 8),
        BarDataItem(name: "XRP", count: 6),
        BarDataItem(name: "LTC", count: 2)
    ]

    @State private var maxItemsToShow: Int = 3
    @State private var currentBarMargin: CGFloat = 1.0
    @State private var chartHeight: CGFloat = 30.0

    // Example of a custom color palette
    private let customPalette: [UIColor] = [
        UIColor.systemTeal,
        UIColor.systemIndigo,
        UIColor.systemPink,
        UIColor.brown
    ]
    
    // Example of a custom font
    private let customLabelFont: UIFont = UIFont(name: "AvenirNext-Medium", size: 11) ?? .systemFont(ofSize: 11)


    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Crypto Portfolio Overview")
                        .font(.title2)
                        .padding(.horizontal)

                    MultiBarSwiftUIView(
                        items: cryptoData,
                        maxVisibleItems: maxItemsToShow,
                        barMargin: currentBarMargin,
                        colorPalette: customPalette,
                        labelFont: customLabelFont,
                        labelTextColor: UIColor.darkGray // Specify UIColor
                    )
                    .frame(height: chartHeight)
                    .padding(.horizontal)
                    .background(Color(UIColor.clear)) // Use Color(UIColor)
                    .cornerRadius(8)
                    .shadow(radius: 3)


                    Divider().padding(.horizontal)

                    VStack {
                        Text("Configuration").font(.headline)
                        Stepper("Max Visible Items: \(maxItemsToShow)", value: $maxItemsToShow, in: 1...5)
                        HStack {
                            Text("Bar Margin: \(String(format: "%.1f", currentBarMargin))")
                            Slider(value: $currentBarMargin, in: 2...10, step: 0.5)
                        }
                        HStack {
                            Text("Chart Height: \(String(format: "%.0f", chartHeight))")
                            Slider(value: $chartHeight, in: 30...200, step: 10)
                        }
                        
                        Button("Shuffle Data") {
                            shuffleCryptoData()
                        }
                        .padding(.top)
                        
                        Button("Add Item") {
                            addCryptoItem()
                        }
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground)) // Use Color(UIColor)
                    .cornerRadius(10)
                    .padding(.horizontal)

                    Spacer()
                }
            }
            .navigationTitle("Dashboard")
        }
    }

    func shuffleCryptoData() {
        // Create new BarDataItem instances to ensure SwiftUI sees a change
        // if only internal properties of reference types were hypothetically changed.
        // For struct arrays, direct shuffling is fine.
        cryptoData.shuffle()
        // To make counts dynamic:
        cryptoData = cryptoData.map { item in
            BarDataItem(name: item.name, count: Double.random(in: 5...50), color: item.color)
        }
    }
    
    func addCryptoItem() {
        let newItemName = "NEW\(Int.random(in: 1...100))"
        let newItem = BarDataItem(name: newItemName, count: Double.random(in: 5...30))
        cryptoData.append(newItem)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
