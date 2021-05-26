//
//  EditItem.swift
//  ShopApp
//
//  Created by Камиль Сулейманов on 21.05.2021.
//

import SwiftUI
import Firebase

struct EditItem: View {
    var item: Item
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
    @State private var isPopular  = false
    
    
    @State private var convertedImage = ""
    @Environment(\.presentationMode) var presentation
    
    var body: some View {
      
        ScrollView {
            VStack {
                        VStack (spacing: 10){
                            
                            CustomTextField(title: "Название", text:  $itemName)
                        
                            
                            CustomTextField(title: "Цена", text:  $itemPrice)
                         
                            CustomTextField(title: "Категория", text:  $itemCategory)
                        
                            CustomTextField(title: "Количество", text:  $itemQuantity)
                        
                            CustomTextField(title: "Описание", text:  $itemDescription)
                        
                        
                            Toggle("В верхнем меню?", isOn: $isPopular)
                                .padding()
                            
                            Divider()
                            
                        Text("Изменить фото")
                            .font(.headline)
                            .bold()
                            
                          
                        }
                        .padding(.horizontal)
                
                            Image(uiImage: Utility.shared.base64ToImage(convertedImage) ?? #imageLiteral(resourceName: "placeholder"))
                                .resizable()
                                .scaledToFit()
                        
                        
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
                        
                        .onChange(of: itemImage, perform: { value in
                            if itemImage != nil  {
                                convertedImage =  Utility.shared.convertImageToBase64String(image: itemImage!)
                            }
                        })
                        
                Spacer()
                        Button(action: {
                            hideKeyboard()
                                saveCategoryToFirebase()
                            presentation.wrappedValue.dismiss()
                       
                            
                        }, label: {
                            Text("Сохранить")
                                .darkModeButton()
                                .padding(.top, 40)
                        })
                        .disabled(itemName == "" && itemPrice == "" && itemCategory == "" && convertedImage == "")
                       
                    }
            .padding(.top, 30)
            .navigationTitle("Редкатировать товар")
            .navigationBarTitleDisplayMode(.inline)
                    .onAppear{
                        itemName = item.name
                        itemPrice = "\(String(format: "%.0f", item.price))"
                        itemCategory = item.category.name
                        itemQuantity = "\(item.quantity ?? 1)"
                        itemDescription = item.description ?? ""
                        convertedImage = item.image ?? ""
                        isPopular = item.isPopular
                }
        }
        
        
    }
    
    func saveCategoryToFirebase (){
            let db = Firestore.firestore()
                db.collection("Items").document(itemName).updateData([
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

struct EditItem_Previews: PreviewProvider {
    static var previews: some View {
        EditItem(item: Store.manager.selectedItem!)
    }
}
