//
//  ResizablePagesControllerContainerView.swift
//  NedBankApp
//
//  Created by Andrzej Michnia on 20.07.2017.
//  Copyright © 2017 NedBank. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

public protocol ResizablePageView: PageView {
    var desiredHeight: CGFloat { get }
    var resizeTrigger: Observable<Void> { get }
}

public class ResizablePagesControllerContainerView: PagesControllerContainerView {
    fileprivate var estimatedPageHeight: CGFloat = 800
    fileprivate var alphaFunction: (CGFloat) -> CGFloat = { return 0.3 + 0.7 * $0 }

    fileprivate var pageControllerHeight: NSLayoutConstraint!
    fileprivate weak var resizedHeight: NSLayoutConstraint!

    public func setup(with pages: [ResizablePageView], resizing heightConstraint: NSLayoutConstraint) {
        super.setup(with: pages)

        resizedHeight = heightConstraint
        resizedHeight.constant = pages.first?.desiredHeight ?? resizedHeight.constant
        resolvePageControllerHeight()
    }

    override func setupPageController() {
        pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageController.delegate = self
        pageController.dataSource = self

        pageController.view.translatesAutoresizingMaskIntoConstraints = false
        pageController.view.frame = bounds
        addSubview(pageController.view)
        pageController.view.topAnchor.constraint(equalTo: topAnchor).isActive = true
        pageController.view.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        pageController.view.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        pageControllerHeight = pageController.view.heightAnchor.constraint(equalToConstant: bounds.height)
        pageControllerHeight.isActive = true
    }

    private func resolvePageControllerHeight() {
        pageControllerHeight.constant = pages.reduce(estimatedPageHeight) { (best, controller) -> CGFloat in
            let aspiring = (controller as? ResizablePageView)?.desiredHeight ?? controller.view.bounds.height
            return Swift.max(best, aspiring)
        }
    }

    override func setupObservers() {
        super.setupObservers()

        pages.forEach { controller in
            guard let page = controller as? ResizablePageView else { return }
            bind(interaction: page.resizeTrigger)
        }

        didChangePage.asObservable().subscribe(onNext: { [weak self] page in
            self?.updatePageControllerSizeIfNeeded(with: page)
        }) >>> bag
    }

    override func bind<T>(interaction trigger: Observable<T>) {
        trigger.map { [weak self] _ -> CGFloat? in
            self?.resolvedHeight()
        }
        .unwrap()
        .subscribe(onNext: { [weak self] height in
            self?.resizedHeight.constant = height
        }) >>> bag

        trigger.subscribe(onNext: { [weak self] _ in
            self?.updateViewAlpha(for: self?.currentIndex)
            self?.updateViewAlpha(for: self?.pendingIndex)
        }) >>> bag
    }

    private func updateViewAlpha(for index: Int?) {
        guard let currentIndex = index else { return }
        guard let current = self.pages[currentIndex] as? ResizablePageView else { return }

        let value = visibility(of: current.view)
        current.view.alpha = alphaFunction(value)
    }

    private func resolvedHeight() -> CGFloat? {
        guard let currentIndex = self.currentIndex else { return nil }
        guard let pendingIndex = self.pendingIndex else {
            return resolvedCurrentOnlyHeight()
        }

        guard let current = self.pages[currentIndex] as? ResizablePageView else { return nil }
        guard let pending = self.pages[pendingIndex] as? ResizablePageView else { return nil }

        let pendingVisibility = self.visibility(of: pending.view)
        let currentHeight = current.desiredHeight
        let pendingHeight = pending.desiredHeight

        return currentHeight + ((pendingHeight - currentHeight) * pendingVisibility)
    }

    private func resolvedCurrentOnlyHeight() -> CGFloat? {
        guard let currentIndex = self.currentIndex else { return nil }
        guard let current = self.pages[currentIndex] as? ResizablePageView else { return nil }

        return current.desiredHeight
    }

    private func updatePageControllerSizeIfNeeded(with index: Int) {
        guard let page = pages[index] as? ResizablePageView else { return }
        guard page.desiredHeight > pageControllerHeight.constant else { return }

        pageControllerHeight.constant = page.desiredHeight
    }
}
