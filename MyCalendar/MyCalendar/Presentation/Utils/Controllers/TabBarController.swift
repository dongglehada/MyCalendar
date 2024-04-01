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
        
        let memoVC = UINavigationController(rootViewController: MemoListViewController(viewModel: MemoListViewModel(sqlLiteRepository: SQLiteRepositorie())))
        memoVC.tabBarItem = UITabBarItem(
            title: "메모",
            image: UIImage(systemName: "newspaper"),
            selectedImage: UIImage(systemName: "newspaper.fill")
        )
        
        let calendarVC = UINavigationController(rootViewController: CalendarViewController())
        calendarVC.tabBarItem = UITabBarItem(
            title: "캘린더",
            image: UIImage(systemName: "newspaper"),
            selectedImage: UIImage(systemName: "newspaper.fill")
        )
        

        viewControllers = [memoVC, calendarVC]
        tabBar.tintColor = .systemPink
    }
}
