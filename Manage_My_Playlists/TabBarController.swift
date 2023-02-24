//
//  TabBarController.swift
//  Manage_My_Playlists
//
//  Created by Aisultan Askarov on 26.01.2023.
//

import UIKit
import SwiftUI

class TabBarController: UITabBarController {
    
    let viewBlur = UIVisualEffectView(effect: UIBlurEffect(style: .systemChromeMaterial))
    let artists = MediaContentManager.shared.featuredArtists

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let firstVeiwController = createNavController(vc: ListenNow(), image: UIImage(systemName: "play.circle.fill")!, title: "Listen Now")
        let secondViewController = createNavController(vc: Browse(), image: UIImage(systemName: "square.grid.2x2.fill")!, title: "Browse")
        let thirdViewController = createNavController(vc: Radio(), image: UIImage(systemName: "dot.radiowaves.left.and.right")!, title: "Radio")
        let forthViewController = createNavController(vc: MyLibrary(), image: UIImage(systemName: "square.stack.fill")!, title: "Library")
        let fifthViewController = createNavController(vc: Search(), image: UIImage(systemName: "magnifyingglass")!, title: "Search")
                
        viewControllers = [firstVeiwController, secondViewController, thirdViewController, forthViewController, fifthViewController]
        tabBar.barStyle = .default
        tabBar.isTranslucent = true
        tabBar.clipsToBounds = false
        tabBar.backgroundImage = UIImage()
        tabBar.shadowImage = UIImage() // add this if you want remove tabBar separator
        tabBar.barTintColor = .clear
        tabBar.backgroundColor = .clear // here is your tabBar color
        tabBar.layer.backgroundColor = UIColor.clear.cgColor
        tabBar.tintColor = UIColor.systemPink
        tabBar.unselectedItemTintColor = UIColor.systemGray.withAlphaComponent(0.85)
        
        viewBlur.frame = tabBar.bounds
        viewBlur.autoresizingMask = .flexibleWidth
        viewBlur.autoresizingMask = .flexibleHeight
        tabBar.insertSubview(viewBlur, at: 0)
        
        guard let items = tabBar.items else { return }
        
        for item in items {
            item.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        }
        
        selectedViewController = forthViewController
        
    }
    
    //MARK: - Functions
    
}

extension UITabBarController {
    
    func createNavController(vc: UIViewController, image: UIImage, title: String) -> UINavigationController {
            
        let viewController = vc
        let navController = UINavigationController(rootViewController: viewController)

        navController.tabBarItem.image = image
        navController.tabBarItem.title = title
        navController.navigationItem.title = title

        return navController
    }
    
}

