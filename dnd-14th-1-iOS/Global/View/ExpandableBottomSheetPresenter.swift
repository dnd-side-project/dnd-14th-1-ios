//
//  BottomSheetPresenter.swift
//  dnd-14th-1-iOS
//
//  Created by a on 2/16/26.
//

import UIKit
import SnapKit

class ExpandableBottomSheetPresenter: UIViewController {
    
    // MARK: - Properties
    private lazy var maxHeight = view.frame.height
    private var height: CGFloat = 0
    private var isDismissPermitted = true
    var onMaximize: (() -> Void)?
    var onRestore: (() -> Void)?
    var onDismiss: (() -> Void)?
    
    // MARK: - UI Components
    private var contentView = UIView()
    
    // MARK: - Initializer
    init() {
        super.init(nibName: nil, bundle: nil)
        addObserver()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Life Cycle
    override func loadView() {
        applyPassthroughView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setGesture()
    }
    
    // MARK: - Public
    func presentOnTop(contentView: UIView, height: CGFloat) {
        guard let windowScene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
              let window = windowScene.windows.first(where: { $0.isKeyWindow }),
              let topViewController = window.rootViewController else {
            return
        }
        self.present(on: topViewController, contentView: contentView, height: height)
    }
    
    func present(on parent: UIViewController, contentView: UIView, height: CGFloat, isDismissPermitted: Bool = true) {
        self.contentView = contentView
        self.height = height
        self.isDismissPermitted = isDismissPermitted
        
        parent.addChild(self)
        parent.view.addSubview(view)
        didMove(toParent: parent)
        
        view.frame = CGRect(
            x: 0,
            y: parent.view.safeAreaInsets.top,
            width: parent.view.frame.width,
            height: parent.view.frame.height - parent.view.safeAreaInsets.top - parent.view.safeAreaInsets.bottom
        )
        
        view.addSubview(contentView)
        
        contentView.snp.makeConstraints {
            $0.top.equalTo(view.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(height)
        }
        view.setNeedsLayout()
        view.layoutIfNeeded()
        
        contentView.snp.remakeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-height)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
        }
        animate()
    }
}

extension ExpandableBottomSheetPresenter {
    
    private func addObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
    }
    
    private func setGesture() {
        let panGesture = UIPanGestureRecognizer(
            target: self,
            action: #selector(handleGesture(_:))
        )
        view.addGestureRecognizer(panGesture)
    }
    
    @objc private func keyboardWillShow() {
        maximizeSheet()
    }
    
    @objc private func handleGesture(_ gesture: UIPanGestureRecognizer) {
        dismissKeyboard()
        
        let translation = gesture.translation(in: view)
        var newHeight = min(maxHeight, maxHeight - contentView.convert(.zero, to: view).minY - translation.y)
        if !isDismissPermitted {
            newHeight = max(newHeight, height)
        }
        
        switch gesture.state {
        case .changed:
            if newHeight < height {
                contentView.snp.remakeConstraints {
                    $0.top.equalTo(view.keyboardLayoutGuide.snp.top).offset(-newHeight)
                    $0.leading.trailing.equalToSuperview()
                    $0.height.equalTo(height)
                }
            } else {
                contentView.snp.remakeConstraints {
                    $0.height.equalTo(newHeight)
                    $0.leading.trailing.equalToSuperview()
                    $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
                }
            }
            view.setNeedsLayout()
            view.layoutIfNeeded()
            gesture.setTranslation(.zero, in: view)
        case .ended:
            let maximizeOffset = (maxHeight + height) / 2
            let dismissOffset = height * 0.7
            
            if newHeight < dismissOffset {
                dismissSheet()
            } else if maximizeOffset < newHeight {
                maximizeSheet()
            } else {
                restoreSheet()
            }
        default:
            break
        }
    }
}

extension ExpandableBottomSheetPresenter {
    
    // MARK: - Helper
    private func maximizeSheet() {
        contentView.snp.remakeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-maxHeight)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
        }
        animate()
        onMaximize?()
    }
    
    private func restoreSheet() {
        contentView.snp.remakeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-height)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
        }
        animate()
        onRestore?()
    }
    
    func dismissSheet() {
        if !isDismissPermitted {
            restoreSheet()
            return
        }
        contentView.snp.remakeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(height)
        }
        animate(completion: {
            self.view.removeFromSuperview()
            self.willMove(toParent: nil)
            self.removeFromParent()
        })
        onDismiss?()
    }
    
    private func animate(completion: (()->Void)? = nil) {
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: 0.95,
            initialSpringVelocity: 0.7,
            animations: {
                self.view.setNeedsLayout()
                self.view.layoutIfNeeded()
            },
            completion: { _ in
                completion?()
            }
        )
    }
}
