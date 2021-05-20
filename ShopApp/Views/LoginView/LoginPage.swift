//
//  Login.swift
//  laZina
//
//  Created by Камиль  Сулейманов on 12.12.2020.
//

import SwiftUI
import AnyFormatKitSwiftUI

struct Login: View {
    @EnvironmentObject var accountCreation : AccountCreationViewModel

    var body: some View {
        VStack{
            
            Text("Войти или зарегистрироваться")
                .font(.title3)
                .foregroundColor(.primary)
                .fontWeight(.heavy)
                .lineLimit(2)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top,30)
            
                FormatTextField(
                    unformattedText:  $accountCreation.phoneNumber,
                    placeholder: "Введите номер телефона",
                    textPattern: "+ # (###) ###-##-##")
                    .keyboardType(.numberPad)
                    .padding(.vertical,6)
                    .padding(.horizontal)
                    .background(Color("darkMode"))
                    .cornerRadius(8)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 5, y: 5)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: -5, y: -5)
                    .padding(.top,30)
            
            Button(action: accountCreation.login, label: {
                HStack{
                    
                    Spacer()
                    
                    Text("Войти")
                    
                    Spacer()
                    
                    Image(systemName: "arrow.right")
                }
                .foregroundColor(Color("darkMode"))
                .padding(.vertical,12)
                .padding(.horizontal)
                .background(Color.primary)
                .cornerRadius(8)
            })
            .padding(.top)
            .disabled(accountCreation.phoneNumber.count != 12 ? false : true)
            .opacity(accountCreation.phoneNumber.count != 12 ? 1 : 0.6)
            
            Spacer()
        }
        .padding(.horizontal)
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
