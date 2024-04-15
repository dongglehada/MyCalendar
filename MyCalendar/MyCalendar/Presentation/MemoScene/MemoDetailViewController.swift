//
//  MemoDetailViewController.swift
//  MyCalendar
//
//  Created by SeoJunYoung on 4/2/24.
//

import UIKit

import SnapKit

import RxSwift
import RxCocoa

class MemoDetailViewController: BasicController {

    // MARK: - Properties
    
    private let viewModel: MemoDetailViewModel
    
    private var disposeBag = DisposeBag()

    // MARK: - Components

    private let navigationCalendarButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "calendar"), for: .normal)
        button.tintColor = .getColor(color: .gray)
        return button
    }()
    
    private let navigationPinButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "pin"), for: .normal)
        button.tintColor = .getColor(color: .gray)
        return button
    }()
    
    private let titleTextField: UITextField = {
        let view = UITextField()
        view.font = Fonts.lg.boldFont
        view.placeholder = "Empty Title"
        view.textAlignment = .center
        return view
    }()
    
    private let textView: UITextView = {
        let view = UITextView()
        view.font = Fonts.md.normalFont
        return view
    }()
    
    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        return picker
    }()
    
    init(viewModel: MemoDetailViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Life Cycle
extension MemoDetailViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        setUpUI()
        setUpBind()
        setUpNavigation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        viewModel.isRunViewWillAppear(isRun: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        viewModel.isRunViewWillDisappear(isRun: true)
    }
}

// MARK: - SetUp
private extension MemoDetailViewController {
    func setUp() {
        
    }
    
    func setUpUI() {
        view.addSubview(textView)
        
        textView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide).inset(Constants.spacings.md)
        }
        
        titleTextField.snp.makeConstraints { make in
            make.width.equalTo(Constants.screenWidth / 2)
            make.height.equalTo(Constants.spacings.xl)
        }
    }
    
    func setUpBind() {
        
        let input = MemoDetailViewModel.Input(
            viewWillDisappear: viewModel.viewWillDisappear.asObservable(),
            didTapPinButton: navigationPinButton.rx.tap.asSignal(),
            didTapCalendarButton: navigationCalendarButton.rx.tap.asSignal(),
            didChangeTitle: titleTextField.rx.text.orEmpty.asObservable(),
            didChangeMemo: textView.rx.text.orEmpty.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        output.isPin
            .withUnretained(self)
            .subscribe(onNext: { (owner, isPin) in
                if isPin {
                    owner.navigationPinButton.tintColor = .getColor(color: .pointColor)
                } else {
                    owner.navigationPinButton.tintColor = .getColor(color: .gray)
                }
            })
            .disposed(by: disposeBag)
        
        output.loadMemo
            .withUnretained(self)
            .subscribe { (owner, memo) in
                owner.viewModel.setMemo(memo: memo)
                owner.titleTextField.text = memo.title
                owner.textView.text = memo.memo
                owner.setPinButtonColor(isPin: memo.isPin)
                owner.setCalendarButtonColor(date: memo.calendarDate)
            }
            .disposed(by: disposeBag)
        
        output.didTapCalendarButton
            .withUnretained(self)
            .subscribe { (owner, memo) in
                let alert = UIAlertController(title: "날짜 고르기", message: "날짜를 골라주세요", preferredStyle: .actionSheet)
                let datePicker = UIDatePicker()
                datePicker.datePickerMode = .date
                datePicker.preferredDatePickerStyle = .wheels
                datePicker.locale = Locale(identifier: "ko_KR")
                
                if memo.calendarDate != nil {
                    datePicker.date = memo.calendarDate!
                }
                
                let ok = UIAlertAction(title: "선택 완료", style: .cancel) { _ in
                    owner.viewModel.setCalendarDate(date: datePicker.date)
                }
                

                let cancel = UIAlertAction(title: "날짜 삭제", style: .default) { _ in
                    owner.viewModel.setCalendarDate(date: nil)
                }
                
                alert.addAction(ok)
                alert.addAction(cancel)
                        
                let vc = UIViewController()
                vc.view = datePicker
                        
                alert.setValue(vc, forKey: "contentViewController")
                        
                owner.present(alert, animated: true)
            }.disposed(by: disposeBag)
    }
    
    func setUpNavigation() {
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(customView: navigationPinButton),
            UIBarButtonItem(customView: navigationCalendarButton)
        ]
        navigationItem.titleView = titleTextField
    }
}

// MARK: - Methods
private extension MemoDetailViewController {
    func setPinButtonColor(isPin: Bool) {
        if isPin {
            navigationPinButton.tintColor = .getColor(color: .pointColor)
        } else {
            navigationPinButton.tintColor = .getColor(color: .gray)
        }
    }
    
    func setCalendarButtonColor(date: Date?) {
        if date == nil {
            navigationCalendarButton.tintColor = .getColor(color: .gray)
        } else {
            navigationCalendarButton.tintColor = .getColor(color: .pointColor)
        }
    }
}
