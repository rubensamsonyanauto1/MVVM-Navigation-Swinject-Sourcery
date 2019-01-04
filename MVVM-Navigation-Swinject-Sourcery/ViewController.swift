//
//  ViewController.swift
//  Example
//
//  Created by Ruben Samsonyan on 03.01.19.
//  Copyright © 2019 Ruben Samsonyan. All rights reserved.
//

import UIKit
import Swinject
import RxSwift

class ViewController: UIViewController {

    lazy var resolver = ResolverBuilder().resolver
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func buttonPressed(_ sender: Any) {
        let controller = resolver.resolveExampleViewController(anythingElse: PublishSubject<Bool>().asObservable())
        navigationController?.show(controller, sender: self)
    }

    @IBAction func toNavigationExample(_ sender: Any) {
        let controller = resolver.resolveRootViewController()
        navigationController?.show(controller, sender: self)
    }
}
