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
    @State private var imagePickerCamera = false
    @State private var photoLibrary: UIImagePickerController.SourceType = .photoLibrary
    @State private var camera: UIImagePickerController.SourceType = .camera
    @State private var isPopular = false
   
    @State private var convertedImage = ""
    
    var body: some View {
        
        ScrollView {
            VStack {
                
                VStack {
                    
                    CustomTextField(title: "Название", text: $itemName)
                    
                    CustomTextField(title: "Цена", text: $itemPrice)
                        .keyboardType(.numbersAndPunctuation)
                    
                    CustomTextField(title: "Категория товара", text: $itemCategory)
                
                    CustomTextField(title: "Количество на складе (не обязательно)", text: $itemQuantity)
                 
                    CustomTextField(title: "Описание (не обязательно)", text: $itemDescription)
                  
                    Toggle("Добавить в популярное?", isOn: $isPopular)
                        .padding()
                        .padding(.bottom, 40)
                    
                    Text("Добавить фото")
                        .font(.headline)
                        .padding(.bottom, 20)
                    
                }
                .padding(.horizontal)
                
                
                if itemImage != nil{
                    Image(uiImage: itemImage!)
                        .resizable()
                        .scaledToFit()
                }
                
                HStack{
                    Button(action: {
                        imagePicker.toggle()
                        hideKeyboard()
                    }, label: {
                        Text("Галерея")
                            .darkModeButton()
                    })
                    .fullScreenCover(isPresented: $imagePicker, content: {
                        ImagePickerView(selectedImage: $itemImage, sourceType: $photoLibrary)
                    })
                    .padding(.trailing, 20)
                  
                    
                    Button(action: {
                        imagePickerCamera.toggle()
                        hideKeyboard()
                    }, label: {
                        Text("Камера")
                            .darkModeButton()
                    })
                    .fullScreenCover(isPresented: $imagePickerCamera, content: {
                        ImagePickerView(selectedImage: $itemImage, sourceType: $camera)
                    })
                    
                }
                .padding(.bottom, 40)
                .onChange(of: itemImage, perform: { value in
                    if itemImage != nil  {
                        convertedImage =  Utility.shared.convertImageToBase64String(image: itemImage!)
                    }
                })
                
                Spacer()
                Button(action: {
                    saveCategoryToFirebase()
                    itemName = ""
                    hideKeyboard()
                    
                }, label: {
                    Text("Сохранить")
                        .darkModeButton()
                })
                .disabled(itemName == "" && itemPrice == "" && itemCategory == "" && convertedImage == "")
            }
            .padding(.top, 30)
            .navigationTitle("Добавить новый товар")
            .navigationBarTitleDisplayMode(.inline)
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

