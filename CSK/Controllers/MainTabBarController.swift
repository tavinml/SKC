//
//  MainTabBarController.swift
//  CSK
//
//  Created by Gustavo Monteiro Lopes on 17/11/26.
//

import UIKit
import SwiftData

final class MainTabBarController: UITabBarController {
    
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder) não foi implementado")
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabs()
    }
    
    private func setupTabs() {
        let exploreController = ViewController(modelContext: modelContext)
        exploreController.title = "Explorar"
        
        let favoritesController = FavoritesViewController(modelContext: modelContext)
        favoritesController.title = "Favoritos"
        favoritesController.view.backgroundColor = .systemBackground
        
        let registerController = RegistersViewController(modelContext: modelContext)
        registerController.title = "Registros"
        registerController.view.backgroundColor = .systemBackground
        
        let exploreNavigation = UINavigationController(rootViewController: exploreController)
        let favoritesNavigation = UINavigationController(rootViewController: favoritesController)
        let registerNavigation = UINavigationController(rootViewController: registerController)
        
        exploreNavigation.tabBarItem = UITabBarItem(title: "Explorar",
                                                    image: UIImage(systemName: "safari"),
                                                    selectedImage: UIImage(systemName: "safari.fill"))
        
        favoritesNavigation.tabBarItem = UITabBarItem(title: "Favoritos",
                                                      image: UIImage(systemName: "heart"),
                                                      selectedImage: UIImage(systemName: "heart.fill"))
        
        registerNavigation.tabBarItem = UITabBarItem(title: "Registros",
                                                      image: UIImage(systemName: "note.text"),
                                                      selectedImage: UIImage(systemName: "note.text"))
        
        viewControllers = [
            exploreNavigation,
            favoritesNavigation,
            registerNavigation
        ]
        
    }
}
