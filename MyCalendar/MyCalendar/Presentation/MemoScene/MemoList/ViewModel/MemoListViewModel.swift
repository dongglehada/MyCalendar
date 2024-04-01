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
    
    var disposeBag = DisposeBag()
    
    struct Input {
        let viewWillAppear: Observable<Bool>
        let didTapNavigationRightButton: Signal<Void>
        let didTapMemoCell: Signal<IndexPath>
    }
    
    struct Output {
        let moveToMemoDetailVC: Signal<IndexPath>
        let moveToMemoAddVC: Signal<Void>
        let loadToMemoDatas: Observable<[Memo]>
    }
    
    func transform(input: Input) -> Output {
        let loadToMemoDatas = input.viewWillAppear.withUnretained(self)
            .map({(owner, _) in
                return owner.sqlLiteRepository.getData()
            })
            .asObservable()
        
        return Output(
            moveToMemoDetailVC: input.didTapMemoCell,
            moveToMemoAddVC: input.didTapNavigationRightButton,
            loadToMemoDatas: loadToMemoDatas
        )
    }
    
    // MARK: - Properties
    
    private let memoDatas = BehaviorRelay<[Memo]>(value: [])
    
    let viewWillAppear = BehaviorRelay<Bool>(value: false)
    
    // MARK: - Repository
    private let sqlLiteRepository: SQLiteRepositorieProtocol
    
    init(sqlLiteRepository: SQLiteRepositorieProtocol) {
        self.sqlLiteRepository = sqlLiteRepository
    }
    
}
