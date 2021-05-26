//
//  RequestTextField.swift
//  LaRibaApp
//
//  Created by Камиль Сулейманов on 04.03.2021.
//

import SwiftUI

struct CustomTextField: View {
    var title: String
    @Binding var text: String

    
    var body: some View {
        ZStack (alignment: Alignment(horizontal: .leading, vertical: .top)){
            Text(title)
                .font(text.isEmpty  && title == text ? .headline : .caption2)
                .foregroundColor(title == text ? .black :  .primary)
                .offset(y: text.isEmpty && title == text ? 0 : -20)
                .zIndex(1)
            
            
            VStack (spacing: 1){
                TextField("", text: $text)
                .accentColor(.black)
                    .foregroundColor(title == text ? .black : .primary)
                
                Capsule()
                    .frame(height: 1)
                    .foregroundColor(Color.primary.opacity(0.5))
                   
            }
            
           
        }
        .autocapitalization(.sentences)
        .padding()
       
    }
}


