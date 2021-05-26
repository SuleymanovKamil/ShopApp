//
//  EditTitles.swift
//  ShopApp
//
//  Created by Камиль Сулейманов on 21.05.2021.
//

import SwiftUI
import Firebase

struct EditTitles: View {
    @EnvironmentObject var store: Store
    @Environment(\.presentationMode) var presentation
 
    var body: some View {
        VStack {
                CustomTextField(title: "Заголовок для акций", text:  $store.topTitle)
            
            Button(action: {
                hideKeyboard()
                saveTitleToFirebase(oldName: "ВерхнийЗаголовок", newName: store.topTitle)
                presentation.wrappedValue.dismiss()
                
                
            }, label: {
                Text("Сохранить")
                    .foregroundColor(Color("darkMode"))
                    .padding(10)
                    .padding(.horizontal, 30)
                    .background(Color.primary.cornerRadius(5))
            })
        
                CustomTextField(title: "Заголовок для каталога", text:  $store.title)
                    .padding(.top, 30)
            
            Button(action: {
                hideKeyboard()
                saveTitleToFirebase(oldName: "Заголовок", newName: store.title)
                presentation.wrappedValue.dismiss()
                
            }, label: {
                Text("Сохранить")
                    .foregroundColor(Color("darkMode"))
                    .padding(10)
                    .padding(.horizontal, 30)
                    .background(Color.primary.cornerRadius(5))
            })

            Spacer()
        }
        .padding(.top, 30)
        .navigationTitle("Изменить заголовки")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func saveTitleToFirebase (oldName: String, newName: String){
            let db = Firestore.firestore()
                db.collection("Titles").document(oldName).updateData([
                    "name" : newName,
                ]) { (err) in
                    if err != nil{
                        print(err!.localizedDescription)
                    } else {
                        store.fetchTitles()
                    }
                    
                }
        }
 
}

struct EditTitles_Previews: PreviewProvider {
    static var previews: some View {
        EditTitles()
            .environmentObject(Store())
    }
}
