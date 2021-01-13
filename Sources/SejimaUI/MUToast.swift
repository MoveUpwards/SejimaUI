//
//  MUToast.swift
//  
//
//  Created by Loïc GRIFFIE on 02/08/2020.
//

#if !os(macOS)

import SwiftUI

struct MUToast: View {
    let title: String
    let message: String
    let cornerRadius: CGFloat
    let indicatorWidth: CGFloat
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .leading, vertical: .center)) {
            Rectangle()
                .foregroundColor(.blue)
            
            HStack {
                Group {
                    Rectangle()
                        .frame(width: max(indicatorWidth, cornerRadius))
                        .foregroundColor(.green)
                    
                    VStack(spacing: 8) {
                        MUHeader(title: title, subtitle: message)
                        
                        Spacer()
                        
                        HStack(spacing: 8) {
                            MUButton(configuration: .init(title: .init(text: "Cancel"))) {
                                
                            }
                            
                            Spacer()
                            
                            MUButton(configuration: .init(title: .init(text: "Save"))) {
                                
                            }
                        }
                    }.padding()
                }
            }
        }
        .mask(Rectangle().cornerRadius(radius: cornerRadius, corners: .allCorners))
    }
}

struct MUToast_Previews: PreviewProvider {
    static var previews: some View {
        MUToast(title: "Api erorr message",
                    message: "An error has occured. Please try again later. An error has occured. Please try again later.",
                    cornerRadius: 8,
                    indicatorWidth: 12)
            .frame(width: 300, height: 200)
            .previewLayout(.sizeThatFits)
    }
}

#endif
