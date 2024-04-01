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
    
    private var disposeBag = DisposeBag()
    
    // MARK: - Components
    private let memoTableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        return view
    }()
    
    private let navigationRightButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .getColor(color: .pointColor)
        return button
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
        setUpNavigation()
        setUpBind()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.viewWillAppear.accept(true)
    }
}

// MARK: - SetUp
private extension MemoListViewController {
    
    func setUp() {
        memoTableView.register(MemoListTableViewCell.self, forCellReuseIdentifier: MemoListTableViewCell.identifier)
    }
    
    func setUpUI() {
        view.addSubview(memoTableView)
        memoTableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func setUpNavigation() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: navigationRightButton)
    }
    
    func setUpBind() {
        
        let input = MemoListViewModel.Input(
            viewWillAppear: viewModel.viewWillAppear.asObservable(),
            didTapNavigationRightButton: navigationRightButton.rx.tap.asSignal(),
            didTapMemoCell: memoTableView.rx.itemSelected.asSignal()
        )
        
        let output = viewModel.transform(input: input)
        
        output.moveToMemoDetailVC
            .emit { indexPath in
                print(indexPath)
            }
            .disposed(by: disposeBag)
        
        output.moveToMemoAddVC
            .emit { [weak self] _ in
                self?.navigationController?.pushViewController(MemoDetailViewController(), animated: true)
            }
            .disposed(by: disposeBag)
        
        output.loadToMemoDatas
            .bind(to: memoTableView.rx.items(cellIdentifier: MemoListTableViewCell.identifier)) { (index: Int, element: Memo, cell: MemoListTableViewCell) in
                cell.bind(memo: element)
                cell.selectionStyle = .none
            }
            .disposed(by: disposeBag)
    }
    
}
