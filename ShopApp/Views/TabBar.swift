//
//  TabBar.swift
//  laRibaFinance
//
//  Created by Камиль on 18.11.2020.
//

import SwiftUI

struct TabBar: View {
    var body: some View {
        TabView {
            MainscreenView()
                .navigationBarHidden(true)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)).opacity(0.05).ignoresSafeArea())
                .tabItem {
                    Image(systemName: "house")
                    Text("Главная")
                }
         
            BasketView()
                .navigationBarHidden(true)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)).opacity(0.05).ignoresSafeArea())
                .tabItem {
                    Image(systemName: "cart")
                    Text("Корзина")
                      
                }
                
           
            Text("Профиль")
                .navigationBarHidden(true)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)).opacity(0.05).ignoresSafeArea())
                .tabItem {
                    Image(systemName: "person")
                    Text("Профиль")
                        
                }

        }
        .accentColor(.primary)
    }
}


