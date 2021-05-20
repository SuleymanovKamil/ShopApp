//
//  BasketView.swift
//  ShopApp
//
//  Created by Камиль Сулейманов on 10.05.2021.
//

import SwiftUI

struct BasketView: View {
    @EnvironmentObject var store: Store
    let paymentHandler = PaymentHandler()
    
    var body: some View {
        VStack (alignment: .leading){
            HStack {
                Text("Товаров в корзине: ")
                    .font(.title2)
                    .bold()
                
                Spacer()
                
                Text("\(store.basket.count)")
                    .bold()
            }
            .font(.title3)
            .padding()
            PullToRefresh(content: {
                List{
                    ForEach(store.basket, id: \.self) { item in
                        HStack {
                            
                            Image(uiImage: Utility.shared.base64ToImage(item.item.image!) ?? #imageLiteral(resourceName: "placeholder"))
                                .resizable()
                                .scaledToFit()
                                .frame(height: 70)
                                .cornerRadius(6)
                            
                            Spacer()
                            
                            VStack (alignment: .trailing, spacing: 0){
                                
                                Text(item.item.name)
                                Text("Количество: \(item.quantity)шт.")
                                Text("Цена: \( String(format: "%.0f", item.item.price * Double(item.quantity)))₽")
                                
                                
                                Spacer()
                            }
                            
                        }
                    }
                    .onDelete(perform: delete)
                }
            },  onRefresh: {control in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    //add task for refresh
                    control.endRefreshing()
                }
            })
            
            HStack {
                
                
                Button(action: {
                    paymentHandler.ammount = Double(store.totalSum)
                    paymentHandler.startPayment { (success) in
                        if success {
                            print("Success")
                            store.basket.removeAll()
                        } else {
                            print("Failed")
                        }
                    }
                }, label: {
                    Text("Заплатить с Pay")
                        .foregroundColor(Color("darkMode"))
                        .padding(10)
                        .padding(.horizontal)
                        .background(Color.primary.cornerRadius(5))
                })
                
                
                Spacer()
                Text("Итого: \(String(format: "%.0f", store.totalSum))₽")
                    .font(.title3)
                    .bold()
                
            }
            .padding(.horizontal)
            
            Spacer()
        }
    }
    func delete(at offsets: IndexSet) {
        store.basket.remove(atOffsets: offsets)
    }
}

struct BasketView_Previews: PreviewProvider {
    static var previews: some View {
        BasketView()
            .environmentObject(Store())
    }
}


struct PullToRefresh<Content: View>: UIViewRepresentable {
    
    var content: Content
    var onRefresh: (UIRefreshControl) -> ()
    var refreshControl = UIRefreshControl()
    
    init(@ViewBuilder content: @escaping () -> Content, onRefresh: @escaping (UIRefreshControl) -> ()){
        self.content = content()
        self.onRefresh = onRefresh
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> UIScrollView {
        
        let scrollView = UIScrollView()
        refreshControl.attributedTitle = NSAttributedString(string: "Обновление")
        refreshControl.tintColor = .black
        refreshControl.addTarget(context.coordinator, action: #selector(context.coordinator.onRefresh), for: .valueChanged)
        
      
        setupView(scrollView: scrollView)
        scrollView.refreshControl = refreshControl
        
        return scrollView
    }
    
    func updateUIView(_ uiView: UIScrollView, context: Context) {
        setupView(scrollView: uiView)
    }
    
    func setupView(scrollView: UIScrollView) {
        let hostView = UIHostingController(rootView: content.frame(maxHeight: .infinity, alignment: .top))
        hostView.view.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            hostView.view.topAnchor.constraint(equalTo: scrollView.topAnchor),
            hostView.view.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            hostView.view.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            hostView.view.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            
            hostView.view.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            hostView.view.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.heightAnchor, constant: 1)
        ]
        scrollView.subviews.last?.removeFromSuperview()
        scrollView.addSubview(hostView.view)
        scrollView.addConstraints(constraints)
    }
    
    class Coordinator: NSObject{
        var parent: PullToRefresh
        
        init(parent: PullToRefresh){
            self.parent = parent
        }
        @objc func onRefresh(){
            parent.onRefresh(parent.refreshControl)
        }
    }
}
