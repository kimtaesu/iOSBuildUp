//
//  UserPhotoImageView.swift
//  App
//
//  Created by tyler on 2021/11/12.
//

import UIKit


class UIUserProfileView: UIControl {
    
    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.3) {
                if self.isHighlighted {
                    self.profileImageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                } else {
                    self.profileImageView.transform = .identity
                }
            }
        }
    }
        
    public var placeHolderImage: UIImage = Asset.accountCircle.image.withRenderingMode(.alwaysTemplate)
    
    public var providerImage: UIImage? {
        didSet {
            let isHidden = self.providerImage == nil
            self.providerBadgeImageView.isHidden = isHidden
            self.providerBadgeImageView.image = self.providerImage
        }
    }
    
    private let profileImageView: UIImageView = {
        let image = UIImageView()
        return image
    }()

    private let providerBadgeImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.backgroundColor = .white
        image.isHidden = true
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.profileImageView.layer.masksToBounds = true
        self.profileImageView.image = self.placeHolderImage
        self.profileImageView.tintColor = .lightGray
        
        [self.profileImageView, self.providerBadgeImageView].forEach {
            self.addSubview($0)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layoutBadgeView()
        self.layoutProfileView()
    }
    
    private func layoutProfileView() {
        self.profileImageView.frame = self.frame
        self.profileImageView.layer.cornerRadius = self.bounds.width / 2
    }
    
    private func layoutBadgeView() {
        let size: CGFloat = self.bounds.width / 2
        let midX: CGFloat = size / 2
        self.providerBadgeImageView.layer.cornerRadius = midX
        self.providerBadgeImageView.size = .init(width: size, height: size)
        self.providerBadgeImageView.right = self.bounds.right + (midX / 2)
        self.providerBadgeImageView.bottom = self.bounds.bottom + (midX / 2)
    }
    
    func setImage(url: URL) {
        self.profileImageView.kf.setImage(with: url, placeholder: self.placeHolderImage)
    }
}

