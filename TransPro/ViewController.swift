//
//  ViewController.swift
//  TransPro
//
//  Created by Aries Yang on 2020/8/8.
//  Copyright © 2020 Aries Yang. All rights reserved.
//

import UIKit

final class TabBarController: UITabBarController {

    private let controllers: [UIViewController]

    init() {
        let colors: [(UIColor, String)] = [
            (.red, "RED"),
            (.orange, "ORANGE"),
            (.yellow, "YELLOW"),
            (.green, "GREEN"),
            (.blue, "BLUE")
        ]
        controllers = colors.map { color, title in
            let vc = UIViewController()
            let item = UITabBarItem()
            item.title = title
            item.setTitleTextAttributes([
                NSAttributedString.Key.foregroundColor: color as Any
            ], for: .normal)
            vc.view.backgroundColor = color
            vc.tabBarItem = item
            return vc
        }
        super.init(nibName: nil, bundle: nil)
        delegate = self
        setupUI()
    }

    private func setupUI() {
        tabBar.isTranslucent = false
        tabBar.barStyle = .black
        setViewControllers(controllers, animated: false)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self
    }
}

extension TabBarController: UIViewControllerAnimatedTransitioning {
    var duration: TimeInterval { 0.35 }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // Get from's / to's controller and view
        guard
            let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to),
            let fromView = transitionContext.view(forKey: .from),
            let toView = transitionContext.view(forKey: .to)
        else { return }

        // Get from's / to's index
        guard let fromIndex = controllers.firstIndex(of: fromVC), let toIndex = controllers.firstIndex(of: toVC) else { return }
        let direction: CGFloat = toIndex > fromIndex ? 1 : -1

        // FromView's begin-x and end-x
        let fromViewFrame = transitionContext.initialFrame(for: fromVC)
        let fromViewBeginX = fromViewFrame.origin.x
        let fromViewEndX = fromViewFrame.origin.x - fromViewFrame.width * direction

        // ToView's begin-x and end-x
        let toViewFrame = transitionContext.finalFrame(for: toVC)
        let toViewBeginX = toViewFrame.origin.x + toViewFrame.width * direction
        let toViewEndX = toViewFrame.origin.x

        let containerView = transitionContext.containerView
        fromView.frame.origin.x = fromViewBeginX // Actually do noting, it's already the value
        toView.frame.origin.x = toViewBeginX
        containerView.addSubview(toView)

        // Animation
        let animate = UIViewPropertyAnimator(duration: duration, curve: .linear) {
            fromView.frame.origin.x = fromViewEndX
            toView.frame.origin.x = toViewEndX
        }
        animate.addCompletion { (state) in
            switch state {
            case .end:
                transitionContext.completeTransition(true)
            default:
                transitionContext.completeTransition(false)
            }
        }
        animate.startAnimation()
    }
}
