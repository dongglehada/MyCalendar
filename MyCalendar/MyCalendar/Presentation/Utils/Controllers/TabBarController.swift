//
//  TabBarController.swift
//  MyCalendar
//
//  Created by SeoJunYoung on 4/1/24.
//

import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
}

private extension TabBarController {
    func setUp() {
        
        let memoVC = UINavigationController(rootViewController: MemoListViewController(viewModel: MemoListViewModel(sqlLiteRepository: SQLiteRepositorie.shared)))
        memoVC.tabBarItem = UITabBarItem(
            title: "Memo",
            image: UIImage(systemName: "list.bullet"),
            selectedImage: UIImage(systemName: "list.bullet")
        )
        
        let calendarVC = UINavigationController(rootViewController: CalendarViewController(viewModel: CalendarViewModel(sqliteRepository: SQLiteRepositorie.shared)))
        calendarVC.tabBarItem = UITabBarItem(
            title: "Calendar",
            image: UIImage(systemName: "calendar"),
            selectedImage: UIImage(systemName: "calendar")
        )
        
        viewControllers = [memoVC, calendarVC]
        tabBar.tintColor = .getColor(color: .pointColor)
    }
}
