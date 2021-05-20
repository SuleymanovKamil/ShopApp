//
//  AddNewCategory.swift
//  ShopApp
//
//  Created by Камиль Сулейманов on 19.05.2021.
//

import SwiftUI
import Firebase

struct AddNewCategory: View {
    @State private var categoryName = ""
    
    var body: some View {
        VStack {
           
            Text("Добавить новую категорию товаров")
                .font(.title3)
                .bold()
                .padding(.top, 30)
            
            
                TextField("Название", text: $categoryName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
            
            Button(action: {
                    saveCategoryToFirebase(categoryName)
                categoryName = ""
                hideKeyboard()
                
            }, label: {
                Text("Сохранить")
                    .foregroundColor(Color("darkMode"))
                    .padding(10)
                    .padding(.horizontal, 30)
                    .background(Color.primary.cornerRadius(5))
            })

            Spacer()
        }
    }
    
    func saveCategoryToFirebase (_ name: String){
    
            let db = Firestore.firestore()
                db.collection("Categories").document(name).setData([
                    "name" : name,
                ]) { (err) in
                    if err != nil{
                        print(err!.localizedDescription)
                    }
                }
        }
}

struct AddNewCategory_Previews: PreviewProvider {
    static var previews: some View {
        AddNewCategory()
    }
}
