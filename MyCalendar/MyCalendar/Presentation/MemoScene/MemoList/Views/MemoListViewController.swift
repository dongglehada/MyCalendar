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
    
    private let navigationMemoAddButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.setTitleColor(.getColor(color: .pointColor), for: .normal)
        return button
    }()
    
    private let navigationMemoEditButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "trash"), for: .normal)
        button.setTitleColor(.getColor(color: .pointColor), for: .normal)
        button.titleLabel?.lineBreakMode = .byWordWrapping
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
        navigationController?.navigationBar.topItem?.title = "Memos"
        let emptyButton = UIBarButtonItem()
        self.navigationItem.rightBarButtonItems = [
            UIBarButtonItem(customView: navigationMemoAddButton),
            emptyButton,
            UIBarButtonItem(customView: navigationMemoEditButton)
        ]
        navigationController?.navigationBar.tintColor = .getColor(color: .pointColor)
    }
    
    func setUpBind() {
        
        let input = MemoListViewModel.Input(
            viewWillAppear: self.rx.viewWillAppear,
            didTapNavigationAddButton: navigationMemoAddButton.rx.tap.asSignal(),
            didTapNavigationEditButton: navigationMemoEditButton.rx.tap.asSignal(),
            didTapMemoCell: memoTableView.rx.itemSelected.asSignal(),
            didDeleteMemo: memoTableView.rx.itemDeleted.asSignal()
        )
        
        let output = viewModel.transform(input: input)
        
        output.moveToMemoDetailVC
            .withUnretained(self)
            .subscribe(onNext: { (owner ,memo) in
                let vm = MemoDetailViewModel(sqlLiteRepository: SQLiteRepositorie.shared)
                vm.displayMemo(memo: memo)
                let vc = MemoDetailViewController(viewModel: vm)
                owner.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        output.moveToMemoAddVC
            .emit { [weak self] _ in
                guard let self = self else { return }
                self.navigationController?.pushViewController(MemoDetailViewController(viewModel: MemoDetailViewModel(sqlLiteRepository: SQLiteRepositorie.shared)), animated: true)
            }
            .disposed(by: disposeBag)
        
        output.loadToMemoDatas
            .bind(to: memoTableView.rx.items(cellIdentifier: MemoListTableViewCell.identifier)) { (index: Int, element: Memo, cell: MemoListTableViewCell) in
                cell.bind(memo: element)
            }
            .disposed(by: disposeBag)
        
        output.changeEditMode
            .emit { [weak self] _ in
                guard let self = self else { return }
                let isEditing = !self.memoTableView.isEditing
                self.memoTableView.setEditing(isEditing, animated: true)
                self.navigationMemoEditButton.setImage(isEditing ? UIImage(systemName: "checkmark") : UIImage(systemName: "trash"), for: .normal)
            }
            .disposed(by: disposeBag)
        
        output.deleteMemo
            .emit { [weak self] indexPath in
                guard let self = self else { return }
                let memo = viewModel.getMemo()[indexPath.row]
                self.viewModel.deleteMemo(memo: memo)
                self.viewWillAppear(true)
            }
            .disposed(by: disposeBag)
    }
}
