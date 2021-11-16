//
//  UIBuildUpViewController+Contact.swift
//  App
//
//  Created by tyler on 2021/11/11.
//

import UIKit

extension UIBuildUpViewController {
    public func contactDocument(
        _ email: String,
        doc: QuestionDocument
    ) {
        let subject: String = doc.asSubjectMail.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let body: String = doc.asBodyMail.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let mailToUrl: URL? = URL(string: "mailto:\(email)?subject=\(subject)&body=\(body)")
        
        guard let url = mailToUrl,
              UIApplication.shared.canOpenURL(url)
        else {
            UIApplication.shared.showCantOpenUrl(title: nil, message: "이메일을 연결할 수 없습니다.")
            return
        }
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

extension QuestionDocument {
    var asSubjectMail: String {
        "\(self.docId) 오탈자 및 문의드립니다."
    }
    
    var asBodyMail: String {
        "안녕하세요! \(self.docId) \(self.question.text) 오탈자 및 문의드립니다."
    }
}
