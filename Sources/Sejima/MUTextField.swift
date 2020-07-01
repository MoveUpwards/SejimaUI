//
//  MUTextField.swift
//  
//
//  Created by Loïc GRIFFIE on 01/07/2020.
//

import SwiftUI

public struct MUTextField: View {
    public let title: String
    public let placeholder: String
    public let text: Binding<String>

    public init(with title: String, placeholder: String, text: Binding<String>) {
        self.title = title
        self.placeholder = placeholder
        self.text = text
    }

    public var body: some View {
        VStack(alignment: .leading) {

            Text(title.uppercased())
                .font(.caption)
                .fontWeight(.light)
                .foregroundColor(.black)
                .padding(.bottom, 8)

            Text(placeholder)
                .font(.caption)
                .fontWeight(.regular)
                .foregroundColor(.accentColor)

            Rectangle()
                .frame(height: 1)
                .foregroundColor(.black)
                .opacity(0.3)
        }.padding()
    }
}

struct MUTextFieldView_Previews: PreviewProvider {
    static var previews: some View {
        MUTextField(with: "Numéro de série", placeholder: "0001-0178", text: .constant(""))
    }
}
