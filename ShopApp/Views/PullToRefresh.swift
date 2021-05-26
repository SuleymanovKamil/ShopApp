//
//  PullToRefresh.swift
//  ShopApp
//
//  Created by Камиль Сулейманов on 26.05.2021.
//

import SwiftUI

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
