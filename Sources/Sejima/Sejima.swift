//
//  LibraryContent.swift
//  Sejima
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
            MUScrollGrid(.vertical, itemsCount: 0) {},
            title: "MUScrollGrid",
            category: .control
        )
    }
}
