import UIKit

class TabbarViewController: UITabBarController, UITabBarControllerDelegate {
    let customTransitioningDelegate = CustomTransitioningDelegate()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        // Configure view controllers for the tab bar
        let firstNavController = createNavController(
            viewController: HomePageVC.instantiate(fromStoryboard: .Dashboard),
            title: "Home",
            unselectedImage: "ic_home_unselected",
            selectedImage: "ic_home_selected"
        )
        
        let secondNavController = createNavController(
            viewController: DiscoverVC.instantiate(fromStoryboard: .Dashboard),
            title: "Discover",
            unselectedImage: "ic_discover_unselect",
            selectedImage: "ic_discover_selected"
        )
        
        let thirdNavController = createNavController(
            viewController: PostItemViewController.instantiate(fromStoryboard: .Main),
            title: "Sell",
            unselectedImage: "ic_sell_unselected",
            selectedImage: "ic_maket_selected"
        )
        
        let fourthNavController = createNavController(
            viewController: ChatViewController.instantiate(fromStoryboard: .Main),
            title: "Messages",
            unselectedImage: "ic_msg_unselected",
            selectedImage: "ic_message_selected"
        )
        
        let fifthNavController = createNavController(
            viewController: UserViewController.instantiate(fromStoryboard: .Main),
            title: "Account",
            unselectedImage: "ic_user_unselected",
            selectedImage: "ic_account_selected"
        )
        
        // Assign view controllers to the tab bar
        self.viewControllers = [
            firstNavController,
            secondNavController,
            thirdNavController,
            fourthNavController,
            fifthNavController
        ]
        
        // Add customizations to the tab bar
        self.addTopBorderToTabBar()
    }
    
    // Create a UINavigationController with proper configuration
    private func createNavController(viewController: UIViewController, title: String, unselectedImage: String, selectedImage: String) -> UINavigationController {
        let navController = UINavigationController(rootViewController: viewController)
        viewController.tabBarItem = UITabBarItem(
            title: title,
            image: UIImage(named: unselectedImage),
            selectedImage: UIImage(named: selectedImage)
        )
        return navController
    }
    
    // UITabBarControllerDelegate method to handle tab selection behavior
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        // Handle special case for the second tab (index 1)
        if let index = tabBarController.viewControllers?.firstIndex(of: viewController) {
            // Check if user details are nil and the tab index is greater than 1
            if appDelegate.userDetails == nil && index > 1 {
                let vc = LoginVC.instantiate(fromStoryboard: .Auth)
                vc.modalPresentationStyle = .custom
                vc.transitioningDelegate = customTransitioningDelegate
                vc.pushView = { vc in
                    vc.hidesBottomBarWhenPushed = true
                    self.pushViewController(vc: vc)
                }
                self.present(vc, animated: true, completion: nil)
                return false // Prevent tab selection
            } else {
                // Additional logic for specific tabs
                if index == 2 {
                    let isComplete =  appDelegate.userDetails?.phone?.trim().isEmpty ?? true
                    if isComplete == true{
                        UIAlertController().alertViewWithTitleAndMessage(self, message: "Please complete your profile to sell your Clothes.") { [weak self] in
                            guard self != nil else {return}
                            if let currentNav = tabBarController.selectedViewController as? UINavigationController {
                                let viewController = MobileNumberVC.instantiate(fromStoryboard: .Auth)
                                viewController.hidesBottomBarWhenPushed = true
                                currentNav.pushViewController(viewController, animated: true)
                            }
                        }
                        return false
                    }else {
                        if let navController = viewController as? UINavigationController {
                            // Always pop to the root view controller
                            navController.popToRootViewController(animated: false)
                        }
                    }
                }
            }
        }
        return true // Allow tab selection
    }

    // Add a top border to the tab bar
    private func addTopBorderToTabBar() {
        let topBorder = CALayer()
        topBorder.frame = CGRect(x: 0, y: 0, width: tabBar.frame.size.width, height: 1)
        topBorder.backgroundColor = UIColor(named: "App_Light_Border_Color")?.cgColor
        tabBar.layer.addSublayer(topBorder)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Customize tab bar appearance
        UITabBar.appearance().backgroundColor = .customWhite
        UITabBar.appearance().tintColor = UIColor(named: "Black_Theme_Color") ?? .black
    }
}
