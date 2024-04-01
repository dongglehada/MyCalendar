//
//  MemoListTableViewCell.swift
//  MyCalendar
//
//  Created by SeoJunYoung on 4/1/24.
//

import UIKit

import SnapKit

class MemoListTableViewCell: UITableViewCell {
    // MARK: - Properties
    
    // MARK: - Components
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "테스트테스트테스트"
        label.setLabel(font: Fonts.lg.boldFont, color: .black)
        return label
    }()
    
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "테스트테스트테스트테스트테스트테스트테스트테스트테스트"
        label.setLabel(font: Fonts.md.normalFont, color: .gray)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
        setUpUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - SetUp
private extension MemoListTableViewCell {
    
    func setUp() {
        
    }
    
    func setUpUI() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(subTitleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(Constants.spacings.md)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Constants.spacings.sm)
            make.leading.trailing.bottom.equalToSuperview().inset(Constants.spacings.md)
        }
        
    }
}

// MARK: - Bind
extension MemoListTableViewCell {
    
//    private func bind() {
//        datas.bind { [weak self] _ in
//            self?.collectionView.reloadData()
//        }
//    }
//    
    func bind(memo: Memo) {
//        datas.value = data.datas
    }
}
