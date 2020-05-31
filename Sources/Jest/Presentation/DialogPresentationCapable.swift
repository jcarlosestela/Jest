//
//  DialogPresentationCapable.swift
//  Jest
//
//  Created by José Carlos Estela Anguita on 15/05/2020.
//

public struct DialogAction {
    
    let title: String
    let action: (() -> Void)?
    
    init(title: String, action: (() -> Void)? = nil) {
        self.title = title
        self.action = action
    }
}

public protocol DialogPresentationCapable {
    func showDialog(title: String, description: String?, accept: DialogAction?, cancel: DialogAction?)
}

#if canImport(UIKit)
import UIKit

public extension DialogPresentationCapable where Self: UIViewController {
    
    func showDialog(title: String, description: String?, accept: DialogAction?, cancel: DialogAction?) {
        let alert = UIAlertController(title: title, message: description, preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
    }
}

#endif
