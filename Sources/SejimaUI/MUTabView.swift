//
//  MUTabView.swift
//  
//
//  Created by Damien Noël Dubuisson on 13/01/2021.
//

import SwiftUI

public struct MUTabView<Item: View>: View {
    private let items: [Item]

    public init(_ items: [Item]) {
        self.items = items
    }

    public var body: some View {
        VStack(alignment: .center, content: {
            HStack {
                ForEach(Array(items.enumerated()), id: \.offset) { index, element in
                    element
                }
            }
        })
    }
}

struct MUTabView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Spacer()
            MUTabView([
                MUTabItemView(action: { index in
                    print("MUTabItemView at \(index)")
                }, content: {
                    Group {
                        EmptyView()
                        Text("toto")
                    }
                }).toView(),
                MUTabItemView(action: { index in
                    print("MUTabItemView at \(index)")
                }, content: {
                    Group {
                        EmptyView()
                        Text("toto")
                    }
                }).toView()
            ])
            .background(Color.gray)
            .frame(height: 64.0)
        }
    }
}
