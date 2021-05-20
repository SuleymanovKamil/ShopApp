//
//  Register.swift
//  laZina
//
//  Created by Камиль  Сулейманов on 12.12.2020.
//

import SwiftUI
import CoreLocation

struct Register: View {
    @EnvironmentObject var accountCreation : AccountCreationViewModel
    @State var manager = CLLocationManager()
    @EnvironmentObject var keyboard : KeyboardResponder
    
    var body: some View {
        
        ZStack {
            GeometryReader { geo in
            VStack(spacing: 10.0){
                    
                    Text("Создать аккаунт")
                        .font(.title)
                        .foregroundColor(.primary)
                        .fontWeight(.heavy)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top,35)
                    
                    HStack(spacing: 15){
                        
                        Image(systemName: "person.fill")
                            .foregroundColor(Color.primary)
                        
                        TextField("Имя", text: $accountCreation.name)
                            .foregroundColor(.black)
                    }
                    .padding(.vertical,6)
                    .padding(.horizontal)
                    .background(Color("darkMode"))
                    .cornerRadius(8)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 5, y: 5)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: -5, y: -5)
                 
                        HStack(spacing: 15){
                            
                            TextField("Адрес доставки", text: $accountCreation.location)
                                .foregroundColor(.black)
                            
                            Button(action: {manager.requestWhenInUseAuthorization()}, label: {
                                
                                Image(systemName: "mappin.circle.fill")
                                    .foregroundColor(Color.primary)
                            })
                        }
                        .padding(.vertical,6)
                        .padding(.horizontal)
                        .background(Color("darkMode"))
                        .cornerRadius(8)
                        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 5, y: 5)
                        .shadow(color: Color.black.opacity(0.05), radius: 5, x: -5, y: -5)
                        
                   
              
                    Button(action: {accountCreation.RegisterUser()}, label: {
                        
                        HStack{
                            
                            Spacer(minLength: 0)
                            
                            Text("Зарегистрироваться")
                            
                            Spacer(minLength: 0)
                            
                            Image(systemName: "arrow.right")
                        }
                        .foregroundColor(Color("darkMode"))
                        .padding(.vertical,12)
                        .padding(.horizontal)
                        .background(Color.primary)
                        .cornerRadius(8)
                        
                    })
                    
                    // disabling Button....
                    .opacity((accountCreation.name != "" && accountCreation.location != "") ? 1 : 0.6)
                    .disabled((accountCreation.name != "" && accountCreation.location != "") ? false : true)
                
                Spacer()
                }
            
                .padding(.horizontal)
                .onAppear(perform: {
                    manager.delegate = accountCreation
            })
            }
        }
       
    }
}

struct Register_Previews: PreviewProvider {
    static var previews: some View {
        Register()
            .environmentObject(AccountCreationViewModel())
    }
}
