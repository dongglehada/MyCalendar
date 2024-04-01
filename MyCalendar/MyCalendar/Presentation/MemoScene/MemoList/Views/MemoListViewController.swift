//
//  MemoViewController.swift
//  MyCalendar
//
//  Created by SeoJunYoung on 4/1/24.
//

import UIKit

import SnapKit

import RxCocoa
import RxSwift

class MemoListViewController: BasicController {
    
    // MARK: - Properties

    private let viewModel: MemoListViewModel
    
    // MARK: - Components
    let memoTableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        return view
    }()
    
    init(viewModel: MemoListViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Life Cycle
extension MemoListViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        setUpUI()
        setUpBind()
    }
}

// MARK: - SetUp
private extension MemoListViewController {
    
    func setUp() {
        memoTableView.delegate = self
        memoTableView.dataSource = self
        memoTableView.register(MemoListTableViewCell.self, forCellReuseIdentifier: MemoListTableViewCell.identifier)
    }
    
    func setUpUI() {
        view.addSubview(memoTableView)
        memoTableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func setUpBind() {
        
    }

}

extension MemoListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MemoListTableViewCell.identifier) as? MemoListTableViewCell else { return UITableViewCell() }
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    
}
