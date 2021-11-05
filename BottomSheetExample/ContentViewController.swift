//
//  ContentViewController.swift
//  BottomSheetExample
//
//  Created by Aaron Lee on 2021/11/05.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class ContentViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private var bag = DisposeBag()
    
    private let stackView = UIStackView()
        .then {
            $0.axis = .vertical
            $0.spacing = 16
            $0.alignment = .fill
            $0.distribution = .fillEqually
        }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
    
}

// MARK: - Layout

extension ContentViewController {
    
    private func configureView() {
        navigationController?.isNavigationBarHidden = false
        title = "Content View"
        
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
            view.backgroundColor = .white
        }
        
        layoutStackView()
        layoutButtons()
    }
    
    private func layoutStackView() {
        view.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func layoutButtons() {
        
        let numbers: [Int] = Array(1...3)
        numbers.forEach { count in
            
            let button = UIButton(type: .system)
                .then {
                    $0.setTitle("Button \(count)", for: .normal)
                    $0.setContentHuggingPriority(.defaultLow, for: .horizontal)
                }
            
            stackView.addArrangedSubview(button)
            
            button
                .rx
                .tap
                .bind { [weak self] in
                    DispatchQueue.main.async {
                        let text: String = "Count \(count)"
                        self?.push2LabelViewController(with: text)
                    }
                }
                .disposed(by: bag)
            
        }
        
    }
    
    private func push2LabelViewController(with text: String = "N/A") {
        let viewController: LabelViewController = LabelViewController()
        viewController.label.text = text
        viewController.title = text
        
        if navigationController != nil {
            navigationController?.pushViewController(viewController, animated: true)
            return
        }
        
        present(viewController, animated: true)
    }
    
}
