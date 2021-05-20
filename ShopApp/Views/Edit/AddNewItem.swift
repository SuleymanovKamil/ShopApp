//
//  AddNewItem.swift
//  ShopApp
//
//  Created by Камиль Сулейманов on 20.05.2021.
//

import SwiftUI
import Firebase

struct AddNewItem: View {
    @State private var itemName = ""
    @State private var itemPrice = ""
    @State private var itemCategory = ""
    @State private var itemQuantity = ""
    @State private var itemDescription = ""
    @State private var itemImage: UIImage?
    @State private var imagePicker = false
    @State private var photoLibrary: UIImagePickerController.SourceType = .photoLibrary
    @State private var camera: UIImagePickerController.SourceType = .camera
    @State private var isPopular = false
    
    
    @State private var convertedImage = ""
    
    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    Group{
                    Text("Добавить новый товар")
                        .font(.title3)
                        .bold()
                        .padding(.top, 30)
          
                        TextField("Название", text: $itemName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.top)
                    
                    TextField("Цена", text: $itemPrice)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numbersAndPunctuation)
                    
                    TextField("Категория товара", text: $itemCategory)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    TextField("Количество на складе (не обязательно)", text: $itemQuantity)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    TextField("Описание (не обязательно)", text: $itemDescription)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                        
                        
                    Text("Добавить фото")
                        .font(.headline)
                        
                        Toggle("Добавить в популярное?", isOn: $isPopular)
                            .padding(.bottom, 40)
                    }
                    .padding(.horizontal)

                    
                    if itemImage != nil{
                        Image(uiImage: itemImage!)
                            .resizable()
                            .scaledToFit()
                    }
                    
                    HStack{
                        Button(action: {imagePicker.toggle()}, label: {
                            Text("Галерея")
                                .darkModeButton()
                        })
                        .fullScreenCover(isPresented: $imagePicker, content: {
                            ImagePickerView(selectedImage: $itemImage, sourceType: $photoLibrary)
                        })
                        
                        Button(action: {}, label: {
                            Text("Камера")
                                .darkModeButton()
                        })
                        .fullScreenCover(isPresented: $imagePicker, content: {
                            ImagePickerView(selectedImage: $itemImage, sourceType: $camera)
                        })

                    }
                   
                }
                .onChange(of: itemImage, perform: { value in
                    if itemImage != nil  {
                        convertedImage =  Utility.shared.convertImageToBase64String(image: itemImage!)
                    }
                })
            }
            
            Button(action: {
                    saveCategoryToFirebase()
                itemName = ""
                hideKeyboard()
                
            }, label: {
                Text("Сохранить")
                    .darkModeButton()
            })
        }
    }
    
    func saveCategoryToFirebase (){
            let db = Firestore.firestore()
                db.collection("Items").document(itemName).setData([
                    "name" : itemName,
                    "category" : itemCategory,
                    "price" : Double(itemPrice)!,
                    "quantity" : itemQuantity,
                    "description" : itemDescription,
                    "image" : convertedImage,
                    "isPopular" : isPopular
                    
                ]) { (err) in
                    if err != nil{
                        print(err!.localizedDescription)
                    }
                }
        }
}

struct AddNewItem_Previews: PreviewProvider {
    static var previews: some View {
        AddNewItem()
    }
}

