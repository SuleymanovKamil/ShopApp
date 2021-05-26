//
//  Constants.swift
//  LaRibaApp
//
//  Created by Камиль  Сулейманов on 05.02.2021.
//

import SwiftUI
import Firebase

let currentUser = Auth.auth().currentUser?.phoneNumber
let currentDevice = UIDevice.current.identifierForVendor!.uuidString
let imagePlaceholder = "https://poanonic.ru/public/images/placeholder.png"
let screenHeight = UIScreen.main.bounds.height
let screenWidth = UIScreen.main.bounds.width
let small = UIScreen.main.bounds.height < 750

//Remove navLink tap animation
struct FlatLinkStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
    }
}


//Blur effect
struct BlurView : UIViewRepresentable {
    var style : UIBlurEffect.Style
    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: style))
        return view
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {   
    }
}

//shadows
struct ShadowModifier: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    func body (content: Content) -> some View {
        content
            .shadow(color: Color.primary.opacity(0.2), radius: 3, x: 3, y: 3)
            .shadow(color: Color.primary.opacity(0.2), radius: 3, x: -3, y: -3)
    }
}

extension View {
    func doubleShadows() -> some View {
        self.modifier(ShadowModifier())
    }
}

//Button style
struct DarkModeButton: ViewModifier{
    func body(content: Content) -> some View {
        content
            .foregroundColor(Color("darkMode"))
            .padding(10)
            .padding(.horizontal, 30)
            .background(Color.primary.cornerRadius(5))
    }
}

extension View{
    func darkModeButton() -> some View{
        self.modifier(DarkModeButton())
    }
}

struct CustomCorner: Shape {
    var corners: UIRectCorner
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width:  10, height: 10))
        return Path(path.cgPath)
    }
}


//Hide keyboard
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

//add separator to int
extension Formatter {
    static let withSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = " "
        formatter.numberStyle = .decimal
        return formatter
    }()
}

extension Int{
    var formattedWithSeparator: String {
        return Formatter.withSeparator.string(for: self) ?? " "
    }
}



// Keyboard Responder
final class KeyboardResponder: ObservableObject {
    private var notificationCenter: NotificationCenter
    @Published private(set) var currentHeight: CGFloat = 0
    @Published private(set) var keyboardShows = false

    init(center: NotificationCenter = .default) {
        notificationCenter = center
        notificationCenter.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyBoardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    deinit {
        notificationCenter.removeObserver(self)
    }

    @objc func keyBoardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            currentHeight = keyboardSize.height
            keyboardShows = true
        }
    }

    @objc func keyBoardWillHide(notification: Notification) {
        currentHeight = 0
        keyboardShows = false
    }
}

// Custom navbar colors .navigationAppearance(backgroundColor: .orange, foregroundColor: .systemBackground, tintColor: .systemBackground, hideSeparator: true)
struct NavAppearanceModifier: ViewModifier {
    init(backgroundColor: UIColor, foregroundColor: UIColor, tintColor: UIColor?, hideSeparator: Bool) {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.titleTextAttributes = [.foregroundColor: foregroundColor]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: foregroundColor]
        navBarAppearance.backgroundColor = backgroundColor
        if hideSeparator {
            navBarAppearance.shadowColor = .clear
        }
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().compactAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        if let tintColor = tintColor {
            UINavigationBar.appearance().tintColor = tintColor
        }
    }
    
    func body(content: Content) -> some View {
        content
    }
}

extension View {
    func navigationAppearance(backgroundColor: UIColor, foregroundColor: UIColor, tintColor: UIColor? = nil, hideSeparator: Bool = false) -> some View {
        self.modifier(NavAppearanceModifier(backgroundColor: backgroundColor, foregroundColor: foregroundColor, tintColor: tintColor, hideSeparator: hideSeparator))
        
    }
}


//Remove duplicates in arrays
extension Array where Element:Equatable {
    func removeDuplicates() -> [Element] {
        var result = [Element]()

        for value in self {
            if result.contains(value) == false {
                result.append(value)
            }
        }

        return result
    }
}


//Remove element from array be name
extension Array where Element: Equatable {

   // Remove first collection element that is equal to the given `object`:
   mutating func remove(object: Element) {
       guard let index = firstIndex(of: object) else {return}
       remove(at: index)
   }

}
