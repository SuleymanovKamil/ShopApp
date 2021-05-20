//
//  MainView.swift
//  laZina
//
//  Created by Камиль  Сулейманов on 12.12.2020.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var accountCreation : AccountCreationViewModel
    @StateObject var keyboard = KeyboardResponder()
   
    var body: some View {
        
        VStack{
            ZStack{
                if accountCreation.pageNumber == 0{
                    Login()    
                }
                else if accountCreation.pageNumber == 1{
                    Register()
                        .transition(.move(edge: .trailing))
                        .environmentObject(keyboard)
                }
               
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)).opacity(0.05).ignoresSafeArea())
        }
        .onTapGesture {
            hideKeyboard()
        }
        .environmentObject(accountCreation)
        .alert(isPresented: $accountCreation.alert, content: {
            Alert(title: Text("Ошибка"), message: Text(accountCreation.alertMsg), dismissButton: .default(Text("Ok")))
        })
    }
    
}

