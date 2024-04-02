//
//  MemoListViewModel.swift
//  MyCalendar
//
//  Created by SeoJunYoung on 4/1/24.
//

import Foundation

import RxSwift
import RxCocoa

class MemoListViewModel: ViewModelProtocol {
    
    // MARK: - Properties
    
    var disposeBag = DisposeBag()
    
    struct Input {
        let viewWillAppear: Observable<Bool>
        let didTapNavigationRightButton: Signal<Void>
        let didTapMemoCell: Signal<IndexPath>
    }
    
    struct Output {
        let moveToMemoDetailVC: Observable<Memo>
        let moveToMemoAddVC: Signal<Void>
        let loadToMemoDatas: Observable<[Memo]>
    }
    
    func transform(input: Input) -> Output {
        let loadToMemoDatas = input.viewWillAppear
            .withUnretained(self)
            .map({(owner, _) in
                return owner.getMemoToSQLiteUseCase.excute()
            })
            .asObservable()
        
        let moveToMemoDetailVC = input.didTapMemoCell
            .withUnretained(self)
            .map { (owner, indexPath) in
                return owner.getMemoToSQLiteUseCase.excute()[indexPath.row]
            }
            .asObservable()
        
        return Output(
            moveToMemoDetailVC: moveToMemoDetailVC,
            moveToMemoAddVC: input.didTapNavigationRightButton,
            loadToMemoDatas: loadToMemoDatas
        )
    }
    
    let viewWillAppear = BehaviorRelay<Bool>(value: false)
    
    // MARK: - Repository
    private let sqliteRepository: SQLiteRepositorieProtocol
    
    // MARK: - UseCase
    private let getMemoToSQLiteUseCase: GetMemoToSQLiteUseCase
    
    init(sqlLiteRepository: SQLiteRepositorieProtocol) {
        self.sqliteRepository = sqlLiteRepository
        self.getMemoToSQLiteUseCase = DefaultGetMemoToSQLiteUseCase(repository: sqliteRepository)
    }
    
    func isRunViewWillAppear(isRun: Bool) {
        viewWillAppear.accept(isRun)
    }
    
}
