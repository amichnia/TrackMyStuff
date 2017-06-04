//
// Copyright (c) 2017 GirAppe Studio. All rights reserved.
//

import Foundation
import UIKit.UIColor
import RxSwift
import BTracker

protocol AssignBeaconViewModelType: class {
    var completeSignal: Observable<Beacon?> { get }
    var beacon: Variable<Beacon?> { get }
    var theme: Variable<BasicViewTheme> { get }
    var beaconViewModel: BeaconViewModelType { get }
    var canAssign: Variable<Bool> { get }

    func assign(sender view: SourceViewType)
    func unassign(sender view: SourceViewType)
    func complete()
}

class AssignBeaconViewModel: AssignBeaconViewModelType {
    var beacon: Variable<Beacon?> { return beaconViewModel.beacon }
    var theme = Variable<BasicViewTheme>(.default)
    var beaconViewModel: BeaconViewModelType
    var canAssign = Variable<Bool>(false)

    fileprivate var workflow: MainWorkflowType

    let bag = DisposeBag()
    var completeSignal: Observable<Beacon?> { return completeSubject.asObservable() }
    private let completeSubject = PublishSubject<Beacon?>()


    init(workflow: MainWorkflowType, beacon: BeaconViewModelType) {
        self.workflow = workflow
        self.beaconViewModel = beacon

        setupBindings()
    }

    private func setupBindings() {
        let valid = Observable.combineLatest(beaconViewModel.proximityValid.asObservable(),
                                             beaconViewModel.motionValid.asObservable(),
                                             beaconViewModel.majorValid.asObservable(),
                                             beaconViewModel.minorValid.asObservable())
        { (proximity: Bool?, motion: Bool?, major: Bool?, minor: Bool?) -> Bool in
            return (proximity ?? false) && (motion ?? true) && (major ?? true) && (minor ?? true)
        }

        valid.bind(to: canAssign) >>> bag
    }

    func assign(sender view: SourceViewType) {
        beaconViewModel.update()
        completeSubject.onNext(beacon.value)
        workflow.pop(view: view)
    }

    func unassign(sender view: SourceViewType) {
        completeSubject.onNext(nil)
        workflow.pop(view: view)
    }

    func complete() {
        completeSubject.onCompleted()
    }
}
