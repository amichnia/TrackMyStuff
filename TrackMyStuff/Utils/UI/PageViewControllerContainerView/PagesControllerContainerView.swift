//
//  PagesControllerContainerView.swift
//  NedBankApp
//
//  Created by Andrzej Michnia on 27.07.2017.
//  Copyright © 2017 NedBank. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

public typealias PageScrollProgress = (current: Int, pending: Int, progress: CGFloat)

public class PagesControllerContainerView: UIView {
    public var pageController: UIPageViewController!
    var pages: [UIViewController] = []

    var currentIndex: Int?
    var pendingIndex: Int?

    var pageChangedSubject = PublishSubject<Int>()
    var scrollSubject = PublishSubject<PageScrollProgress>()
    var bag = DisposeBag()

    public var didChangePage: Observable<Int> {
        return pageChangedSubject.asObservable()
    }
    public var didScroll: Observable<PageScrollProgress> {
        return scrollSubject.asObservable()
    }

    public func setup(with pages: [PageView], initial: PageView? = nil) {
        let pages = pages.flatMap { $0 as? UIViewController }
        self.pages = pages
        self.subviews.forEach { $0.removeFromSuperview() }

        setupPageController()

        guard let initialPage = (initial as? UIViewController) ?? pages.first else { return }
        guard let currentIndex = pages.index(where: { $0 === initialPage }) else { return }

        self.currentIndex = currentIndex
        pageController.setViewControllers([initialPage], direction: .forward, animated: false, completion: nil)

        setupObservers()
    }

    public func move(to page: Int, completion: (() -> Void)? = nil) {
        guard page < pages.count else { return }
        guard let currentIndex = self.currentIndex else { return }
        guard page != currentIndex else { return }

        let forward = page > currentIndex

        pendingIndex = page
        let controller = pages[page]

        pageController.view.isUserInteractionEnabled = false
        pageController.setViewControllers([controller], direction: forward ? .forward : .reverse, animated: true, completion: { _ in
            self.pageController.view.isUserInteractionEnabled = true
            self.currentIndex = self.pendingIndex
            completion?()
        })
    }

    func setupPageController() {
        pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageController.delegate = self
        pageController.dataSource = self

        pageController.view.translatesAutoresizingMaskIntoConstraints = false
        pageController.view.frame = bounds
        addSubview(pageController.view)
        pageController.view.topAnchor.constraint(equalTo: topAnchor).isActive = true
        pageController.view.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        pageController.view.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        pageController.view.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    }

    func setupObservers() {
        bag = DisposeBag()

        if let scroll = pageController.view.subviews.first(where: { $0 is UIScrollView }) as? UIScrollView {
            self.bind(interaction: scroll.rx.didScroll.asObservable())
        } else {
            self.bind(interaction: didChangePage)
        }
    }

    func bind<T>(interaction trigger: Observable<T>) {
        trigger.map { [weak self] _ -> PageScrollProgress? in
                    self?.resolvedScroll()
                }
                .unwrap()
                .bind(to: scrollSubject) >>> bag
    }

    func visibility(of view: UIView) -> CGFloat {
        guard bounds.width != 0 else { return 0 }

        let converted = self.convert(view.frame, from: view)
        let intersection = bounds.intersection(converted)

        return intersection.width / bounds.width
    }

    private func resolvedScroll() -> PageScrollProgress? {
        guard let currentIndex = self.currentIndex else { return nil }
        guard let pendingIndex = self.pendingIndex else {
            return (current: currentIndex, pending: currentIndex, progress: 1)
        }

        let pending = self.pages[pendingIndex] as PageView
        let pendingVisibility = self.visibility(of: pending.view)

        return (current: currentIndex, pending: pendingIndex, progress: pendingVisibility)
    }
}

extension PagesControllerContainerView: UIPageViewControllerDelegate {
    public func pageViewController(_ pageViewController: UIPageViewController,
            willTransitionTo pendingViewControllers: [UIViewController]) {
        pendingIndex = pages.index(of: pendingViewControllers.first!)
    }

    public func pageViewController(_ pageViewController: UIPageViewController,
            didFinishAnimating finished: Bool,
            previousViewControllers: [UIViewController],
            transitionCompleted completed: Bool) {
        guard completed else { return }

        currentIndex = pendingIndex
        guard let index = currentIndex else { return }
        pageChangedSubject.onNext(index)
    }
}

extension PagesControllerContainerView: UIPageViewControllerDataSource {
    public func pageViewController(_ pageViewController: UIPageViewController,
            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = pages.index(of: viewController) else { return nil }
        guard index > 0 else { return nil }

        return pages[index - 1]
    }

    public func pageViewController(_ pageViewController: UIPageViewController,
            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = pages.index(of: viewController) else { return nil }
        guard index < pages.count - 1 else { return nil }

        return pages[index + 1]
    }
}
