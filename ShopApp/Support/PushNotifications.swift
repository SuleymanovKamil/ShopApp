//
//  FirebaseManager.swift
//  SwiftUIFirebaseApp
//
//  Created by Jack Colley on 01/10/2020.
//

import Foundation
import UIKit


class PushNotification: ObservableObject {

    static var manager = PushNotification()
    
    let legacyServerKey = "AAAABQXQd8Q:APA91bEEvuWxVst1Z_zmMVyeXQ16eLP9jP42v_Lw1H6D89BZm1zvKJu8TNnh1IzyH_ciz-ECIo0DGpsWzRc-JD49mFIdoWKHH0pkgvUOZZpOMJVCnTBMJokztkpCSZ4WYPjm3c5AQRmP"
    var userToken = ""
 
    
    func sendPushNotification(token: String, title: String, body: String) {
        let payload: [String: Any] = ["title": title, "body": body, "sound": "sound.caf"]
        let paramString: [String: Any] = ["to": token,
                                          "notification": payload]
        
        let urlString = "https://fcm.googleapis.com/fcm/send"
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject:paramString, options: [.prettyPrinted])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("key=\(legacyServerKey)", forHTTPHeaderField: "Authorization")

        let task =  URLSession.shared.dataTask(with: request as URLRequest)  { (data, response, error) in
            do {
                if let data = data {
                    if let object  = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: Any] {
                        NSLog("Received data: \(object))")
                    }
                }
            } catch let err as NSError {
                print(err.debugDescription)
            }
        }
        task.resume()
    }
}
