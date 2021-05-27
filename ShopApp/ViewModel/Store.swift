//
//  Store.swift
//  ShopApp
//
//  Created by Камиль Сулейманов on 09.05.2021.
//

import SwiftUI
import Firebase

class Store: ObservableObject {
    let db = Firestore.firestore()
    
    static var manager = Store()
    //titles
    @Published var topTitle = String()
    @Published var title = String()

    @Published var userProfile = User(id: "", userName: "", location: "", token: "")
    @Published var categories: [Category] = []
    @AppStorage("log_Status") var status = false
    @Published var search = ""
    @Published var selectedItem: Item?
    @Published var popularsItems: [Item] = []
    @Published var currentItems: [Item] = []
    @Published var searchItems: [String] = []
    @Published var orders: [Order] = []
    @Published var allOrders: [Order] = []
    @Published var currentCategory =  String()
    @Published var isCurrentUserAdmin = false
    
    @Published var deliveryAddress = String()
    //basket
    @Published var basket: [BasketItem] = []
  
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
    
    func fetchCurrenUser(){
        db.collection("Users").whereField("id", isEqualTo: currentUser ?? currentDevice).getDocuments { (snap, err) in
            guard let itemData = snap else{return}
            if err != nil {
                print((err?.localizedDescription)!)
                return
            } else {
                for i in itemData.documents {
                    let id = i.get("id") as! String
                    let location = i.get("location") as! String
                    let userName = i.get("userName") as! String
                    let token = i.get("token") as! String

                    self.userProfile = User(id: id, userName: userName, location: location, token: token)
                }
            }
        }
    }
    
    
    func fetchAdmins(){
        db.collection("Admin").addSnapshotListener { [self] (snap, err) in
            if err != nil {
                print((err?.localizedDescription)!)
                return
            } else {
                for i in snap!.documentChanges {
                    let id = i.document.documentID
                 
                    if currentUser == id {
                       isCurrentUserAdmin = true
                        print("you log in as admin")
                        
                    } else {
                      
                    }
                }
                if isCurrentUserAdmin {
                   fetchAdminOrderHistory()
                } else {
                    fetchUserOrderHistory()
                }
            }
        }
    }
    
    func fetchTitles(){
        db.collection("Titles").getDocuments { (snap, err) in
          DispatchQueue.main.async {
            if err != nil {
                print((err?.localizedDescription)!)
                return
            } else {
                if let snap = snap{
                    self.topTitle = snap.documentChanges[0].document.get("name") as! String
                self.title = snap.documentChanges[1].document.get("name") as! String
                }
                }
            }
          }
    }
    
    
    func fetchCategories(){
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
                self.currentCategory = self.categories.reversed().first!.name
                self.fetchItems()
            }
          }
        }
    }
    
    func fetchPopularItems(){
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
                    let isPopular = doc.get("isPopular") as! Bool
                    
                    return Item(name: name, price: price, category: Category(name: category), quantity: quantity, description: description, image: image, isPopular: isPopular)
                })
            }
        }
    }
    
    func fetchItems(){
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
                    let isPopular = doc.get("isPopular") as! Bool
                    
                    return Item(name: name, price: price, category: Category(name: category), quantity: quantity, description: description, image: image, isPopular: isPopular)
                })
            }
        }
    }
    
    func fetchBasketFromFirebase (){
     
        db.collection("Basket").whereField("owner", isEqualTo: currentUser ?? currentDevice).addSnapshotListener { [unowned self] (snap, error) in
     
            
            guard let itemData = snap else{return}
            if error != nil {
                print(error!)
            }
            else {
                for i in itemData.documents{
                    let items = i.get("items") as! [[String: Any]]
                    for i in 0..<items.count{
                    let itemName = items[i]["name"] as! String
                    let quantity1 = items[i]["quantity"] as! Int
                        fetchItem(name: itemName) { item1 in
                            
                            let name = item1!.name
                            let price =  item1!.price
                            let category = item1!.category
                            let quantity =  item1?.quantity ?? 0
                            let description =  item1?.description ?? ""
                            let image =  item1!.image
                            let isPopular = item1!.isPopular
                            if  !basket.contains(where: { $0.item.name == name}) {
                                basket.append(BasketItem(item: Item(name: name, price: price, category: category, quantity: quantity, description: description, image: image, isPopular: isPopular), quantity: quantity1))
                            }
                        }
                    }
                }
            }
        }
        
        func fetchItem(name: String, completion: @escaping (_ item: Item?)-> Void) {
        
            db.collection("Items").whereField("name", isEqualTo: name).getDocuments { (snap, error) in
                if error != nil {
                    print(error!)
                }
                else {
                    for i in snap!.documentChanges {
                      let dict =  i.document.data() as NSDictionary
                   
                        let name = dict.value(forKey: "name") as! String
                        let price =  dict.value(forKey: "price") as! Double
                        let category = dict.value(forKey: "category") as! String
                        let quantity =  dict.value(forKey: "quantity") as? Int
                        let description =  dict.value(forKey: "description") as? String
                        let image = dict.value(forKey: "image") as? String
                        let isPopular = dict.value(forKey: "isPopular") as! Bool
                        
                        completion(Item(name: name, price: price, category: Category(name: category), quantity: quantity, description: description, image: image, isPopular: isPopular))
                    }
                }
            }
        }
    }
    
    func saveBasketToFirebase (){
        let db = Firestore.firestore()
        var items : [[String: Any]] = []
 
        for i in basket {
            items.append([
                "name": i.item.name,
                "quantity" : i.quantity,
            ])
        }
            db.collection("Basket").document(currentUser ?? currentDevice).setData([
                "owner" : currentUser ?? currentDevice,
                "items": items,
                
            ]) { (err) in
                if err != nil{
                    print(err!.localizedDescription)
                } else {
                    print("success to save item in firebase basket")
                }
            }
    }
    
    func saveOrderToFirebase (){
        let db = Firestore.firestore()
        var items : [[String: Any]] = []
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale(identifier: "ru")
        for i in basket {
            items.append([
                "name": i.item.name,
                "quantity" : i.quantity,
            ])
        }
        db.collection("Orders").document("\(Date())").setData([
            "Owner" : currentUser ?? currentDevice,
            "OrderNumber" : 1,
            "Date" : "\(dateFormatter.string(from: date))",
            "Items": items,
            "TotalSum" : " \(String(format: "%.0f", totalSum))₽",
            "DeliveryAddress" : userProfile.location ?? ""
        ]) { (err) in
            if err != nil{
                print(err!.localizedDescription)
            }
        }
    }
    
    func startSearch(){
       
        db.collection("Items").getDocuments { snap, error in
            
            guard let itemData = snap else{return}
            if error != nil {
                print(error!)
            } else {
                self.searchItems = itemData.documents.compactMap({ (doc) -> String in
                    return doc.get("name") as! String
                })
                
            }
        }
    }
   
    func fetchUserOrderHistory(){
        var orderItems : [[String: Int]] = []
        db.collection("Orders").whereField("Owner", isEqualTo: currentUser ?? currentDevice).addSnapshotListener { [unowned self] (snap, error) in
     
            guard let itemData = snap else{return}
            if error != nil {
                print(error!)
            }
            else {
                for i in itemData.documents{
                    let date = i.get("Date") as! String
           
                    let orderNumber = i.get("OrderNumber") as! Int
                    let totalSum = i.get("TotalSum") as! String
                    let deliveryAddress = i.get("DeliveryAddress") as! String
                    let items = i.get("Items") as! [[String: Any]]
                    for i in 0..<items.count{
                    let itemName = items[i]["name"] as! String
                        let quantity = items[i]["quantity"] as! Int
                            orderItems.append([itemName : quantity])
                           
                        }
                        if  !orders.contains(Order(date: "\(date))", item: orderItems, orderNumber: orderNumber, totalSum: totalSum, deliveryAddress: deliveryAddress)) {
                            orders.append(Order(date: "\(date))", item: orderItems, orderNumber: orderNumber, totalSum: totalSum, deliveryAddress: deliveryAddress))
                        }
                }
                print("Fetch order history")
            }
        }
    }
   
    func fetchAdminOrderHistory(){
     
        db.collection("Orders").addSnapshotListener { [unowned self] (snap, error) in
            var orderItems : [[String: Int]] = []
            guard let itemData = snap else{return}
            if error != nil {
                print(error!)
            }
            else {
                for i in itemData.documents{
                    let date = i.get("Date") as! String
           
                    let orderNumber = i.get("OrderNumber") as! Int
                    let totalSum = i.get("TotalSum") as! String
                    let deliveryAddress = i.get("DeliveryAddress") as! String
                    let items = i.get("Items") as! [[String: Any]]
                    for i in 0..<items.count{
                    let itemName = items[i]["name"] as! String
                    let quantity = items[i]["quantity"] as! Int
                        orderItems.append([itemName : quantity])
                       
                    }
                    if  !allOrders.contains(Order(date: "\(date))", item: orderItems, orderNumber: orderNumber, totalSum: totalSum, deliveryAddress: deliveryAddress)) {
                        allOrders.append(Order(date: "\(date))", item: orderItems, orderNumber: orderNumber, totalSum: totalSum, deliveryAddress: deliveryAddress))
                    }
                }
                print("Fetch all order history \(allOrders.count)")
            }
        }
    }
    
}


