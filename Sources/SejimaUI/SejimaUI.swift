//
//  LibraryContent.swift
//  SejimaUI
//
//  Created by Loïc GRIFFIE on 29/06/2020.
//

import SwiftUI

struct LibraryContent: LibraryContentProvider {
    @LibraryContentBuilder
    var views: [LibraryItem] {
        LibraryItem(
            MUTextField(configuration: MUTextFieldConfiguration(), title: "", placeholder: "", text: .constant("")),
            title: "MUTextField",
            category: .control
        )

        LibraryItem(
            MUHeader(configuration: MUHeaderConfiguration(), title: "", subtitle: ""),
            title: "MUHeader",
            category: .control
        )

        LibraryItem(
            MUTag(configuration: MUTagConfiguration(), action: {}),
            title: "MUTag",
            category: .control
        )

        LibraryItem(
            MUButton(configuration: .init(title: .init(), cornerRadius: 4, color: .green), action: {}),
            title: "MUButton",
            category: .control
        )

        LibraryItem(
            MUSegmentedPicker(configuration: MUSegmentedPickerConfiguration(), items:["ON", "OFF"], selection: .constant(0)),
            title: "MUSegmentedPicker",
            category: .control
        )

        LibraryItem(
            MUScrollGrid(.vertical, itemsCount: 0, spacing: nil, gridSize: .constant(.zero)) {},
            title: "MUScrollGrid",
            category: .control
        )

        LibraryItem(
            MUSpiderGraph(
                datas: [
                    SpiderGraphDataSet(values: [0], color: .green)
                ],
                padding: 8,
                mainColor: .accentColor,
                dividers: 4,
                maxValue: 1.0,
                dimensions: [
                    Text("Dimension 1").eraseToAnyView()
                ],
                dimensionsPadding: 8,
                capacity: 1,
                score: {
                    Text("56")
                }),
            title: "MUSpiderGraph",
            category: .control
        )
    }
}
