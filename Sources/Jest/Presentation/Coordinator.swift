//
//  Coordinator.swift
//  Jest
//
//  Created by José Carlos Estela Anguita on 15/05/2020.
//
#if canImport(UIKit)
import UIKit

public protocol Coordinator {
    var navigationController: UINavigationController? { get set }
    func start()
}
#endif
