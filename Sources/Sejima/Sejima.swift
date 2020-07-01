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
            MUTextField(with: "", placeholder: "", text: .constant("")),
            title: "MUTextField",
            category: .control
        )

        LibraryItem(
            MUHeader(title: "", subtitle: "", configuration: MUHeaderConfiguration()),
            title: "MUHeader",
            category: .control
        )

        LibraryItem(
            MUTag(action: {}, title: "", configuration: MUTagConfiguration()),
            title: "MUTag",
            category: .control
        )
    }
}
