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
        let viewWillAppear: ControlEvent<Void>
        let didTapNavigationEditButton: Signal<Void>
        let didTapNavigationDeleteButton: Signal<Void>
        let didTapMemoCell: Signal<IndexPath>
        let didDeleteMemo: Signal<IndexPath>
    }
    
    struct Output {
        let moveToMemoDetailVC: Observable<Memo>
        let moveToMemoAddVC: Signal<Void>
        let loadToMemoDatas: Observable<[Memo]>
        let changeEditMode: Signal<Void>
        let deleteMemo: Signal<IndexPath>
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
            moveToMemoAddVC: input.didTapNavigationEditButton,
            loadToMemoDatas: loadToMemoDatas,
            changeEditMode: input.didTapNavigationDeleteButton,
            deleteMemo: input.didDeleteMemo
        )
    }
    
    // MARK: - Repository
    private let sqliteRepository: SQLiteRepositorieProtocol
    
    // MARK: - UseCase
    private let getMemoToSQLiteUseCase: GetMemoToSQLiteUseCase
    private let deleteMemoToSQLiteUseCase: DeleteMemoToSQLiteUseCase
    
    init(sqlLiteRepository: SQLiteRepositorieProtocol) {
        self.sqliteRepository = sqlLiteRepository
        self.getMemoToSQLiteUseCase = DefaultGetMemoToSQLiteUseCase(repository: sqliteRepository)
        self.deleteMemoToSQLiteUseCase = DefaultDeleteMemoToSQLiteUseCase(repository: sqlLiteRepository)
    }
    
    func deleteMemo(memo: Memo) {
        deleteMemoToSQLiteUseCase.excute(memo: memo)
    }
    
    func getMemo() -> [Memo]{
        return getMemoToSQLiteUseCase.excute()
    }
}
