//
//  UserListCell.swift
//  GithubUserSearch
//
//  Created by cheolho on 2023/05/10.
//

import UIKit

import AlamofireImage
import SuperEasyLayout
import Then

class UserListCell: UITableViewCell {
    
    private lazy var horizontalStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 16
    }
    
    private lazy var profileImageView = UIImageView().then {
        $0.layer.borderColor = UIColor.lightGray.cgColor
        $0.layer.borderWidth = 1.0
        $0.contentMode = .scaleAspectFit
        $0.tintColor = UIColor.lightGray
        $0.clipsToBounds = true
    }
    
    private lazy var verticalStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 8
    }
    
    private lazy var nameLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .title3)
    }
    
    private lazy var urlLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .callout)
    }
    
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.isUserInteractionEnabled = true
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Item
    public var user: User? {
        didSet {
            guard let user = user else { return }
            if let encodedUrl = user.avatar_url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                let avatarUrl = URL(string: encodedUrl) {
                profileImageView.af.setImage(withURL: avatarUrl)
            }
            nameLabel.text = user.login
            urlLabel.text = user.html_url
        }
    }
    
}


// MARK: - Setup
extension UserListCell {

    private func setupViews() {
        self.addSubview(horizontalStackView)
        horizontalStackView.addArrangedSubview(profileImageView)
        horizontalStackView.addArrangedSubview(verticalStackView)
        verticalStackView.addArrangedSubview(nameLabel)
        verticalStackView.addArrangedSubview(urlLabel)
        
        horizontalStackView.do {
            $0.top == self.top + 16
            $0.left == self.left + 16
            $0.bottom == self.bottom - 16
            $0.right == self.right - 16
        }
        
        profileImageView.do {
            $0.width == 48
            $0.height >= 48
            $0.layer.cornerRadius = 48 / 2.0
        }
    }

}
