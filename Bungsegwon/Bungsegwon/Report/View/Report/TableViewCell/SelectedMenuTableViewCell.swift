//
//  SelectedMenuTableViewCell.swift
//  Bungsegwon
//
//  Created by 성단빈 on 2020/12/22.
//

import UIKit

protocol SelectedMenuTableViewCellDelegate: class {
  func deleteDelegate(_ indexPath: IndexPath) -> Void
}

class SelectedMenuTableViewCell: UITableViewCell {
  // MARK: - Properties
  static let identifier = "SelectedMenuTableViewCell"
  let tasteTextField = UITextField()
  let numberAndPriceTextField = UITextField()
  var indexPath: IndexPath?
  let deleteBtn = UIButton()
  weak var delegate: SelectedMenuTableViewCellDelegate?
  
  // MARK: - View LifeCycle
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    self.setUI()
    self.setLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    [
      self.tasteTextField,
      self.numberAndPriceTextField
    ].forEach {
      $0.layer.cornerRadius = 8
      $0.layer.borderWidth = 1
      $0.clipsToBounds = true
      $0.layer.borderColor = UIColor(
        red: 0.898,
        green: 0.898,
        blue: 0.898,
        alpha: 1
      ).cgColor
    }
  }
  
  // MARK: - SetUI
  private func setUI() {
    [
      self.tasteTextField,
      self.numberAndPriceTextField,
      self.deleteBtn
    ].forEach {
      self.contentView.addSubview($0)
    }
    
    self.backgroundColor = UIColor(red: 0.957, green: 0.957, blue: 0.957, alpha: 1)
    self.contentView.backgroundColor = UIColor(red: 0.957, green: 0.957, blue: 0.957, alpha: 1)
    
    [
      self.tasteTextField,
      self.numberAndPriceTextField
    ].forEach {
      let textFieldLeftPaddingView = UIView(
        frame: CGRect(x: 0, y: 0, width: 17, height: 0)
      )
      $0.leftViewMode = .always
      $0.leftView = textFieldLeftPaddingView
      $0.tintColor = UIColor(
        red: 1,
        green: 0.831,
        blue: 0.392,
        alpha: 1
      )
      $0.backgroundColor = .white
      $0.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 14)
    }
    
    self.tasteTextField.placeholder = "메뉴"
    
    self.numberAndPriceTextField.placeholder = "2개 1000원"
    
    self.deleteBtn.setImage(
      UIImage(named: "TableViewDeleteImage"),
      for: .normal
    )
    self.deleteBtn.addTarget(
      self,
      action: #selector(self.deleteDidTapBtn),
      for: .touchUpInside
    )
  }
  
  // MARK: - SetLayout
  private func setLayout() {
    self.tasteTextField.snp.makeConstraints {
      $0.top.equalToSuperview().offset(4)
      $0.leading.equalToSuperview().offset(16)
      $0.width.equalTo(108)
      $0.height.equalTo(52)
      $0.bottom.equalToSuperview().offset(-4)
    }
    
    self.numberAndPriceTextField.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.leading.equalTo(self.tasteTextField.snp.trailing).offset(8)
      $0.trailing.equalTo(self.deleteBtn.snp.leading).offset(-9)
      $0.height.equalTo(52)
    }
    
    self.deleteBtn.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.width.height.equalTo(24)
      $0.trailing.equalToSuperview().offset(-13)
    }
    
  }
  
  // MARK: - Configuer
  func configuer(_ indexPath: IndexPath) {
    self.indexPath = indexPath
  }
  
  // MARK: - Action Button
  @objc private func deleteDidTapBtn(_ sender: UIButton) {
    guard let cellIndexPath = self.indexPath else { return }
    
    self.delegate?.deleteDelegate(cellIndexPath)
  }
  
}

// MARK: - Extension
