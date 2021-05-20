//
//  AccountCreationViewModel.swift
//  laZina
//
//  Created by Камиль  Сулейманов on 12.12.2020.
//


import SwiftUI
import Firebase
import CoreLocation

// Getting user Location....

class AccountCreationViewModel: NSObject,ObservableObject,CLLocationManagerDelegate{
    
    // User Details...
    @Published var name = ""
    @Published var location = ""

    
    // User check
    @Published var userProfile: User!
   
    // Login Details...
    @Published var phoneNumber = "79280453012"
    
    // refrence For View Changing
    // ie Login To Register to Image Uplaod
    @Published var pageNumber = 0
    
    // Images....
    @Published var images = Array(repeating: Data(count: 0), count: 2)
    @Published var picker = false
    
    // AlertView Details...
    @Published var alert = false
    @Published var alertMsg = ""
    
    // Loading Screen...
    @Published var isLoading = false
    
    // OTP Credentials...
    @Published var CODE = "123456"
    
    // Status...
    @AppStorage("log_Status") var status = false
    @AppStorage("gender") var userGender = "Пол     "
 
   
    
    
    func login(){
        
        
        // Getting OTP...
        // Disabling App Verification...
        // Undo it while testing with live Phone....
        Auth.auth().settings?.isAppVerificationDisabledForTesting = true
        
        isLoading.toggle()
        
        PhoneAuthProvider.provider().verifyPhoneNumber("+" + phoneNumber, uiDelegate: nil) { (CODE, err) in
            
            self.isLoading.toggle()
            
            if err != nil{
                self.alertMsg = err!.localizedDescription
                self.alert.toggle()
                return
            }
            
            self.CODE = CODE!
            
            // Alert TextFields...
            
            let alertView = UIAlertController(title: "Проверка", message: "Введите код из СМС", preferredStyle: .alert)
            
            let cancel = UIAlertAction(title: "Отмена", style: .destructive, handler: nil)
            
            let ok = UIAlertAction(title: "Да", style: .default) { (_) in
                
                // Verifying OTP
                if let otp = alertView.textFields![0].text{
                    
                    let credential = PhoneAuthProvider.provider().credential(withVerificationID: self.CODE, verificationCode: otp)
                    
                    self.isLoading.toggle()
                    
                    Auth.auth().signIn(with: credential) { [self] (res, err) in
                        
                        if err != nil{
                            self.alertMsg = err!.localizedDescription
                            self.alert.toggle()
                            self.isLoading.toggle()
                            
                            
                            return
                        }

                        // Go To Register Screen if not register yet. Checking phone

                        Firestore.firestore().collection("Users")
                            .whereField("id", isEqualTo: (Auth.auth().currentUser?.phoneNumber)!)
                            .getDocuments { (querySnapshot, error) in
                                if error != nil {
                                    print("Error in login" + error!.localizedDescription)
                                }
                                else {
                                    if querySnapshot!.isEmpty {
                                    withAnimation{
                                        self.pageNumber = 1
                                    }
                                    } else {
                                        fetchAdmin()
                                        self.status = true
                                    }
                                }
                            }
                        
                        self.isLoading.toggle()
                    }
                }
            }
            
            alertView.addTextField { (txt) in
                txt.placeholder = "Введите код из СМС"
                txt.text = "123456" 
            }
            
            alertView.addAction(cancel)
            alertView.addAction(ok)
            
            // Presentitng...
            UIApplication.shared.windows.first?.rootViewController?.present(alertView, animated: true, completion: nil)
        }
    }
    
//    func signUp(){
//
//        //save inages to firebase
//        let storage = Storage.storage().reference()
//
//        let ref = storage.child("profile_Pics").child(Auth.auth().currentUser!.uid)
//
//        // Image urls...
//        var urls : [String] = []
//
//        isLoading.toggle()
//
//        for index in images.indices{
//
//            ref.child("img\(index)").putData(images[index], metadata: nil) { (_, err) in
//
//                if err != nil{
//                    self.alertMsg = err!.localizedDescription
//                    self.alert.toggle()
//                    self.isLoading.toggle()
//                    return
//                }
//
//                ref.child("img\(index)").downloadURL { (url, _) in
//                    guard let imageUrl = url else{return}
//
//                    //appdending urls...
//                    urls.append("\(imageUrl)")
//
//                    // checking all images are uploaded...
//                    if urls.count == self.images.count{
//
//                        // Update DB...
//                        self.RegisterUser(urls: urls)
//                    }
//                }
//
//            }
//        }
//    }
    
    
    func RegisterUser(){
        
        let db = Firestore.firestore()
        
        db.collection("Users").document(Auth.auth().currentUser!.phoneNumber!).setData([
            "id" : currentUser!,
            "userName": name,
            "location": location,
            "token" : PushNotification.manager.userToken
            
            
        ]) { [unowned self] (err) in
            
            self.isLoading.toggle()
            
            if err != nil{
                self.alertMsg = err!.localizedDescription
                self.alert.toggle()
                return
            }
            
            // Success..
            self.status = true
            Store.manager.userProfile = User(id: currentUser, userName: name, location: location, token: PushNotification.manager.userToken)
            fetchAdmin()
        }
    }
    
    func fetchAdmin(){
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
                        Store.manager.isCurrentUserAdmin = true
                        print("you log in as admin")
                    }

                 
                }
            }
          }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let last = locations.last!
        
        CLGeocoder().reverseGeocodeLocation(last) { (places, _) in
            guard let placeMarks = places else{return}
            
            self.location = (placeMarks.first?.name ?? "") + ", " + (placeMarks.first?.locality ?? "")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        // DO Something...
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        if manager.authorizationStatus == .authorizedWhenInUse{
            manager.requestLocation()
        }
    }
  
}

