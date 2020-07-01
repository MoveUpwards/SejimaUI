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
            MUTextField(title: "", placeholder: "", text: .constant("")),
            title: "MUTextField",
            category: .control
        )
    }
}
