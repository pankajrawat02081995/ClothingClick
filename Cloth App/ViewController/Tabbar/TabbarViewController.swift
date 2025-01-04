import UIKit

class TabbarViewController: UITabBarController, UITabBarControllerDelegate {

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
        if let index = tabBarController.viewControllers?.firstIndex(of: viewController), index == 2 {
            if let navController = viewController as? UINavigationController {
                // Always pop to the root view controller
                navController.popToRootViewController(animated: false)

            }
        }
        return true
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
