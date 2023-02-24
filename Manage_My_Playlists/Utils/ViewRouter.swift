//
//  ViewRouter.swift
//  Manage_My_Playlists
//
//  Created by Aisultan Askarov on 31.01.2023.
//

import SwiftUI

// Router class to manage app navigation stack
class Router<Route: Equatable>: ObservableObject {
    
    // An array of routes representing the navigation stack
    var routes = [Route]()
    
    // A callback that gets executed whenever a new route is pushed
    var onPush: ((Route) -> Void)?
    
    // Initialize the router with an optional initial route
    init(initial: Route? = nil) {
        if let initial = initial {
            routes.append(initial)
        }
    }
    
    // Push a new route onto the navigation stack
    func push(_ route: Route) {
        routes.append(route)
        
        // Notify the listener that a new route was pushed
        onPush?(route)
    }
    
}

// A SwiftUI wrapper for the UIKit navigation controller
struct RouterHost<Route: Equatable, Screen: View>: UIViewControllerRepresentable {
    
    let router: Router<Route>
    
    // A closure that returns a SwiftUI view for a given route
    @ViewBuilder
    let builder: (Route) -> Screen
    
    // Create a new navigation controller
    func makeUIViewController(context: Context) -> UINavigationController {
        let navigation = UINavigationController()
        
        // Set the router's onPush callback to push new views onto the navigation stack
        router.onPush = { route in
            navigation.pushViewController(
                UIHostingController(rootView: builder(route)), animated: true
            )
        }
        
        return navigation
    }
    
    // Required method for UIViewControllerRepresentable, but not used in this case
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
    }
    
    // Specify the type of the wrapped view controller
    typealias UIViewControllerType = UINavigationController
}

// An enumeration of the app's available routes
enum AppRoute: Equatable {
    case PlaylistView
    case FeaturedArtistsView
}
