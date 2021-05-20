//
//  AccountView.swift
//  ShopApp
//
//  Created by Камиль Сулейманов on 14.05.2021.
//

import SwiftUI
import Firebase

struct AccountView: View {
    @AppStorage("log_Status") var status = false
    @StateObject var accountCreation = AccountCreationViewModel()
    @EnvironmentObject var store: Store
    @State var showAlert = false
    
    var body: some View {
        
        
        if status {
            VStack {
                NavbarTrailingButton
                    .alert(isPresented: $showAlert, content: {
                        Alert(title: Text("Выйти из аккаунта"), message: Text("Вы уверены?"), primaryButton: .destructive(Text("Да")) {
                            withAnimation{
                                accountCreation.status = false
                                accountCreation.pageNumber = 0
                                
                                let firebaseAuth = Auth.auth()
                                do {
                                    try firebaseAuth.signOut()
                                } catch let signOutError as NSError {
                                    print ("Error signing out: %@", signOutError)
                                }
                            }
                        },
                        secondaryButton: .cancel(Text("Отмена")))
                    })
            }
        } else {
            LoginView()
                .environmentObject(accountCreation)
            
            if accountCreation.isLoading{
                LoadingScreen()
            }
        }
    }
    var NavbarTrailingButton: some View {
            Button(action: {
                withAnimation{
                    showAlert.toggle()
                }
            }, label: {
                Image(systemName: "escape")
                    .font(.title2)
                    .foregroundColor(.primary)
            })
           
        
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
            .environmentObject(AccountCreationViewModel())
            .environmentObject(Store())
    }
}
