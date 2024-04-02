//
//  MemoDetailViewModel.swift
//  MyCalendar
//
//  Created by SeoJunYoung on 4/2/24.
//

import Foundation

import RxSwift
import RxCocoa

class MemoDetailViewModel: ViewModelProtocol {
    var disposeBag = DisposeBag()
    
    struct Input {
        let viewWillDisappear: Observable<Bool>
        let didTapPinButton: Signal<Void>
        let didTapCalendarButton: ControlEvent<Void>
        let didChangeTitle: Observable<String>
        let didChangeMemo: Observable<String>
    }
    
    struct Output {
        let isPin: Observable<Bool>
//        let isTag: Observable<Bool>
//        let isDateSet: Observable<Bool>
//        let moveTo
//        let titleText: Observable<String>
//        let memoText: Observable<String>
    }
    
    func transform(input: Input) -> Output {
        
        input.viewWillDisappear
            .withUnretained(self)
            .subscribe { (owner, isRun) in
                if isRun {
                    owner.updateMemoToSQLiteUseCase.excute(memo: owner.memo)
                }
            }
            .disposed(by: disposeBag)
        
        input.didChangeTitle
            .withUnretained(self)
            .subscribe { (owner, title) in
                owner.memo.title = title
            }
            .disposed(by: disposeBag)
        
        input.didChangeMemo
            .withUnretained(self)
            .subscribe { (owner, memo) in
                owner.memo.memo = memo
            }
            .disposed(by: disposeBag)

        let isPin = input.didTapPinButton
            .withUnretained(self)
            .map({(owner, _) in
                owner.memo.isPin.toggle()
                return owner.memo.isPin
            })
            .asObservable()

        return Output(
            isPin: isPin
        )
    }
    
    let viewWillDisappear = BehaviorRelay<Bool>(value: false)
    
    var memo = Memo(id: 0, updateDate: Date.now, title: "", memo: "", isPin: false)
    
    var displayMemo = BehaviorRelay(value: Memo(id: 0, updateDate: Date.now, title: "", memo: "", isPin: false))
    
    // MARK: - Repository
    private let sqlLiteRepository: SQLiteRepositorieProtocol
    private let updateMemoToSQLiteUseCase: UpdateMemoToSQLiteUseCase
    
    init(sqlLiteRepository: SQLiteRepositorieProtocol) {
        self.sqlLiteRepository = sqlLiteRepository
        self.updateMemoToSQLiteUseCase = DefaultUpdateMemoToSQLiteUseCase(repository: sqlLiteRepository)
    }
    
    func isRunViewWillDisappear(isRun: Bool) {
        viewWillDisappear.accept(isRun)
    }
    
    func setMemo(memo: Memo) {
        self.memo = memo
    }
    
    func displayMemo(memo: Memo) {
        displayMemo.accept(memo)
    }
}
