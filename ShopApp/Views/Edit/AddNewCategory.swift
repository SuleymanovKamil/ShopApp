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
        VStack (spacing: 20){
           
            CustomTextField(title: "Добавить новую категорию товаров", text: $categoryName)
            
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
            .disabled(categoryName == "")

            Spacer()
        }
        .padding(.top, 30)
        .navigationTitle("Редактор категорий")
        .navigationBarTitleDisplayMode(.inline)
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
