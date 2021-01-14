//
//  MUToast.swift
//  
//
//  Created by Loïc GRIFFIE on 02/08/2020.
//

#if !os(macOS)

import SwiftUI

public struct MUToast<Header: View, Content: View>: View {
    let header: () -> Header
    let content: () -> Content

    let indicatorColor: Color
    let indicatorWidth: CGFloat

    init(
        indicatorWidth: CGFloat = 0,
        indicatorColor: Color = .clear,
        @ViewBuilder header: @escaping () -> Header,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.header = header
        self.content = content
        self.indicatorWidth = indicatorWidth
        self.indicatorColor = indicatorColor
    }
    
    public var body: some View {
        HStack {
            VStack(alignment: .center, spacing: 16) {
                header()
                content()
            }
            .padding(.leading, indicatorWidth)
            .padding()
            .background(HStack(spacing: 0) {
                Rectangle()
                    .foregroundColor(indicatorColor)
                    .frame(width: indicatorWidth)
                Spacer()
            })
        }
    }
}

struct MUToast_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            MUToast(indicatorWidth: 20, indicatorColor: .green) {
                HStack(alignment: .top) {
                    MUHeader(configuration: .init(alignment: .leading, spacing: 0), title: "title", subtitle: "message")
                    Spacer()
                }
            } content: {
                HStack(spacing: 8) {
                    MUButton(configuration: .init(title: .init(text: "Cancel"), color: .pink)) { print("cancel") }
                    MUButton(configuration: .init(title: .init(text: "Save"), color: .purple)) { print("save") }
                }
            }
            .background(Color.blue)
            .mask(Rectangle().cornerRadius(radius: 8, corners: .allCorners))
            .padding()
            .previewLayout(.sizeThatFits)


            VStack(spacing: 16) {
                HStack(alignment: .top) {
                    MUHeader(configuration: .init(alignment: .leading, spacing: 0), title: "title", subtitle: "message")
                    Spacer()
                }

                HStack(spacing: 8) {
                    MUButton(configuration: .init(title: .init(text: "Cancel"), color: .pink)) { print("cancel") }
                    MUButton(configuration: .init(title: .init(text: "Save"), color: .purple)) { print("save") }
                }
            }
            .padding(.leading, 20)
            .padding()
            .background(
                HStack(spacing: 0) {
                    Rectangle()
                        .foregroundColor(.green)
                        .frame(width: 20)
                    Spacer()
                }
            )
            .frame(minWidth: 300)
            .background(Color.blue)
            .mask(Rectangle().cornerRadius(radius: 8, corners: .allCorners))
            .padding()
            .previewLayout(.sizeThatFits)
        }
    }
}

#endif
