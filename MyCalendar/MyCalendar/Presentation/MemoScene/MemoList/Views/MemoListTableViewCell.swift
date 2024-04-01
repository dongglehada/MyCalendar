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
    
    private let tagView: UIView = {
        let view = UIView()
        view.backgroundColor = .getColor(color: .gray)
        return view
    }()
    
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
        contentView.addSubview(tagView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subTitleLabel)
        
        tagView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(Constants.spacings.md)
            make.leading.equalToSuperview()
            make.height.equalTo(Constants.spacings.sm)
            make.width.equalTo(Constants.spacings.lg)
        }
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(tagView.snp.trailing).offset(Constants.spacings.md)
            make.top.trailing.equalToSuperview().inset(Constants.spacings.md)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Constants.spacings.sm)
            make.leading.equalTo(titleLabel.snp.leading)
            make.trailing.bottom.equalToSuperview().inset(Constants.spacings.md)
        }
        
    }
}

// MARK: - Bind
extension MemoListTableViewCell {
    
    func bind(memo: Memo) {
    }
}
