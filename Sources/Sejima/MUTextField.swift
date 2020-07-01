//
//  MUTextField.swift
//  
//
//  Created by Loïc GRIFFIE on 01/07/2020.
//

import SwiftUI

struct MUTextField: View {
    let title: String
    let placeholder: String

    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(title.uppercased())
                .font(.caption)
                .fontWeight(.light)
                .foregroundColor(.white)
                .padding(.bottom, 8)

            Text(placeholder)
                .font(.caption)
                .fontWeight(.regular)
                .foregroundColor(.accentColor)

            Rectangle()
                .frame(height: 1)
                .foregroundColor(.white)
                .opacity(0.3)
        }.padding()
    }
}

struct MUTextFieldView_Previews: PreviewProvider {
    static var previews: some View {
        MUTextField(title: "Numéro de série", placeholder: "0001-0178", text: .constant(""))
    }
}
