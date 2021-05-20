//
//  Store.swift
//  ShopApp
//
//  Created by Камиль Сулейманов on 09.05.2021.
//

import SwiftUI
import Firebase

class Store: ObservableObject {
    
    static var manager = Store()
    @Published var userProfile: User!
    
    @AppStorage("log_Status") var status = false
    @Published var search = ""
    @Published var selectedItem = Item(name: "Американо", price: 110, category: Category(name: "coffee"), quantity: nil, description: nil, image: "coffee1")
    @Published var popularsItems: [Item] = []
    @Published var currentItems: [Item] = []
    @Published var categories: [Category] = []
    @Published var currentCategory = "Кофе"
    @Published var isCurrentUserAdmin = false
    
    @Published var showItemDetail = false
    
    //basket
    @Published var basket: [BasketItem] = [BasketItem(item: Item(name: "Американо", price: 110, category: Category(name: "coffee"), quantity: nil, description: nil, image: "coffee1"), quantity: 2)
    ]
  
    var totalSum: Double {
        var sum = 0.0
        for i in basket {
            sum += Double(i.quantity) * i.item.price
        }
        return sum
    }

//    func saveItemsToFirebase (){
//
//        let db = Firestore.firestore()
//
//        for i in admins {
//            db.collection("Admin").document(i).setData([
//                "phone" : i,
//
//
//            ]) { [unowned self] (err) in
//
//
//
//                if err != nil{
//                    print(err?.localizedDescription)
//                }
//
//
//            }
//        }
//    }
    
    
    func fetchAdmins(){
        let db = Firestore.firestore()
        db.collection("Admin").addSnapshotListener { (snap, err) in
          DispatchQueue.main.async {
            if err != nil {
                print((err?.localizedDescription)!)
                return
            } else {
                for i in snap!.documentChanges {
                    let id = i.document.documentID
                 
                    if currentUser == id {
                        self.isCurrentUserAdmin = true
                        print("you log in as admin")
                    } 
                }
            }
          }
        }
    }
    
    
    func fetchCategories(){
        let db = Firestore.firestore()
        db.collection("Categories").addSnapshotListener { (snap, err) in
          DispatchQueue.main.async {
            if err != nil {
                print((err?.localizedDescription)!)
                return
            } else {
                for i in snap!.documentChanges {
                  
                    let name = i.document.documentID
                    
                    if !self.categories.contains(Category(name: name)){
                    self.categories.append(Category(name: name))
                    }
                }
            }
          }
        }
    }
    
    func fetchPopularItems(){
        let db = Firestore.firestore()
        db.collection("Items").whereField("isPopular", isEqualTo: true).addSnapshotListener { (snap, error) in
            
            guard let itemData = snap else{return}
            if error != nil {
                print(error!)
            }
            else {
                self.popularsItems = itemData.documents.compactMap({ (doc) -> Item in
                    
                    let name = doc.get("name") as! String
                    let price =  doc.get("price") as! Double
                    let category = doc.get("category") as! String
                    let quantity =  doc.get("quantity") as? Int
                    let description =  doc.get("description") as? String
                    let image =  doc.get("image") as? String
                    
                    return Item(name: name, price: price, category: Category(name: category), quantity: quantity, description: description, image: image)
                })
            }
        
        }
    }
    
    
    func fetchItems(){
        let db = Firestore.firestore()
        db.collection("Items").whereField("category", isEqualTo: currentCategory).addSnapshotListener { (snap, error) in
            
            guard let itemData = snap else{return}
            if error != nil {
                print(error!)
            }
            else {
                self.currentItems = itemData.documents.compactMap({ (doc) -> Item in
                    
                    let name = doc.get("name") as! String
                    let price =  doc.get("price") as! Double
                    let category = doc.get("category") as! String
                    let quantity =  doc.get("quantity") as? Int
                    let description =  doc.get("description") as? String
                    let image =  doc.get("image") as? String
                    
                    return Item(name: name, price: price, category: Category(name: category), quantity: quantity, description: description, image: image)
                })
            }
        
        }
    }
}


