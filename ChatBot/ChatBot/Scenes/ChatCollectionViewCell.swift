//
//  ChatCollectionViewCell.swift
//  ChatBot
//
//  Created by Kim EenSung on 4/2/24.
//

import UIKit

/// 콜렉션뷰셀
final class ChatCollectionViewCell: UICollectionViewCell {
    static let className: String = String(describing: ChatCollectionViewCell.self)
    
    weak var delegate: ChatCollectionViewCellDelegate?
    
    private(set) var chatBubbleView = ChatBubbleView()
    private let refreshButton = UIButton().then {
        $0.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
        $0.tintColor = .systemRed
        $0.isHidden = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        setUpRefreshButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        hideRefreshButton()
    }
}

// MARK: - UI
extension ChatCollectionViewCell {
    private func configureUI() {
        self.addSubview(chatBubbleView)
        self.addSubview(refreshButton)
        
        chatBubbleView.snp.makeConstraints { 
            $0.top.equalTo(self.snp.top)
            $0.bottom.equalTo(refreshButton.snp.top)
            $0.width.lessThanOrEqualTo(self.snp.width).multipliedBy(0.70)
            $0.trailing.equalTo(self.snp.trailing)
        }
        
        refreshButton.snp.makeConstraints {
            $0.width.height.equalTo(8)
            $0.trailing.equalTo(chatBubbleView.snp.leading).inset(10)
        }
    }
}

// MARK: - Public Methods
extension ChatCollectionViewCell {
    func text(_ string: String, isUser: Bool) {
        chatBubbleView.setText(string)
        chatBubbleView.setUser(isUser)
        
        chatBubbleView.snp.remakeConstraints {
            $0.top.equalTo(self.snp.top)
            $0.bottom.equalTo(self.snp.bottom)
            $0.width.lessThanOrEqualTo(self.snp.width).multipliedBy(0.70)
            _ = isUser ? $0.trailing.equalTo(self.snp.trailing) : $0.leading.equalTo(self.snp.leading)
        }
    }
}

// MARK: - RefreshButton Configuration
protocol ChatCollectionViewCellDelegate: AnyObject {
    func tapRefreshButton(_ chatCollectionViewCell: ChatCollectionViewCell)
}

extension ChatCollectionViewCell {
    private func setUpRefreshButton() {
        refreshButton.addTarget(self, action: #selector(resendChat), for: .touchUpInside)
    }
    
    @objc func resendChat() {
        delegate?.tapRefreshButton(self)
    }
    
    func showRefreshButton() {
        refreshButton.isHidden = false
    }
    
    func hideRefreshButton() {
        refreshButton.isHidden = true
    }
}
