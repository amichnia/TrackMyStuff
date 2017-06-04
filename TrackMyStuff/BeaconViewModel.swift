//
// Copyright (c) 2017 GirAppe Studio. All rights reserved.
//

import Foundation
import UIKit.UIColor
import RxSwift
import BTracker

protocol BeaconViewModelType: class {
    var beacon: Variable<Beacon?> { get }
    var isAssigned: Variable<Bool> { get }
    var assignmentButtonText: Variable<String> { get }

    var proximityUUID: Variable<String?> { get }
    var proximityValid: Variable<Bool?> { get }
    var motionUUID: Variable<String?> { get }
    var motionValid: Variable<Bool?> { get }
    var major: Variable<String?> { get }
    var majorValid: Variable<Bool?> { get }
    var minor: Variable<String?> { get }
    var minorValid: Variable<Bool?> { get }

    func update()
}

class BeaconViewModel: BeaconViewModelType {
    var beacon: Variable<Beacon?>
    var isAssigned: Variable<Bool>
    var assignmentButtonText: Variable<String>

    var proximityUUID = Variable<String?>(nil)
    var proximityValid = Variable<Bool?>(nil)
    var motionUUID = Variable<String?>(nil)
    var motionValid = Variable<Bool?>(nil)
    var major = Variable<String?>(nil)
    var majorValid = Variable<Bool?>(nil)
    var minor = Variable<String?>(nil)
    var minorValid = Variable<Bool?>(nil)

    let bag = DisposeBag()

    init(beacon: Beacon?) {
        self.beacon = Variable<Beacon?>(beacon)

        if let beacon = beacon {
            isAssigned = Variable<Bool>(true)
            assignmentButtonText = Variable<String>(R.string.localizable.assignBeaconButtonAssigned(beacon.proximityUUID.uuidString))
        } else {
            isAssigned = Variable<Bool>(false)
            assignmentButtonText = Variable<String>(R.string.localizable.assignBeaconButtonUnassigned())
        }

        setupBindings()
        setupValidityBindings()
    }

    private func setupBindings() {
        beacon.asObservable().map({ $0?.proximityUUID.uuidString }) --> proximityUUID >>> bag
        beacon.asObservable().map({ $0?.motionUUID?.uuidString }) --> motionUUID >>> bag

        beacon.asObservable().map({ beacon -> String? in
            guard let value = beacon?.major.value() else { return nil }
            return "\(value)"
        }) --> major >>> bag

        beacon.asObservable().map({ beacon -> String? in
            guard let value = beacon?.minor.value() else { return nil }
            return "\(value)"
        }) --> minor >>> bag

        isAssigned.asObservable().map({
            if $0, let to = self.beacon.value?.proximityUUID.uuidString {
                return R.string.localizable.assignBeaconButtonAssigned(to)
            } else {
                return R.string.localizable.assignBeaconButtonUnassigned()
            }
        }) --> assignmentButtonText >>> bag
    }

    private func setupValidityBindings() {
        proximityUUID.asObservable().unwrap().map({ UUID(uuidString: $0) != nil }) --> proximityValid >>> bag
        motionUUID.asObservable().unwrap().map({ UUID(uuidString: $0) != nil || $0.isEmpty }) --> motionValid >>> bag
        major.asObservable().unwrap().map({ Int($0) != nil || $0.isEmpty }) --> majorValid >>> bag
        minor.asObservable().unwrap().map({ Int($0) != nil || $0.isEmpty }) --> minorValid >>> bag
    }

    func update() {
        guard let proximity = proximityUUID.value else { return }

        let identifier = UUID().uuidString
        let motion = motionUUID.value

        if let major = Int(text: self.major.value), let minor = Int(text: self.minor.value!) {
            beacon.value = Beacon(identifier: identifier, proximityUUID: proximity, major: major, minor: minor, motionUUID: motion)
        } else if let major = Int(text: self.major.value) {
            beacon.value = Beacon(identifier: identifier, proximityUUID: proximity, major: major, motionUUID: motion)
        } else {
            beacon.value = Beacon(identifier: identifier, proximityUUID: proximity, motionUUID: motion)
        }
    }
}
