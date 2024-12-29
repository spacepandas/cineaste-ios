// swiftlint:disable:this file_name
//
//  XCTestCase+SnapshotTests.swift
//  CineasteSnapshotTests
//
//  Created by Felizia Bernutz on 01.11.19.
//  Copyright © 2019 spacepandas.de. All rights reserved.
//

import UIKit
import SnapshotTesting

/// Asserts that a given value matches a reference on disk.
/// This overload makes two snapshots with "Light" and "Dark" user interface style in a UINavigationController.
///
/// - Parameters:
///
///   - themes: An array of UIUserInterfaceStyle you want to test.
///   - value: A value to compare against a reference.
///   - name: An optional description of the snapshot.
///   - recording: Whether or not to record a new reference.
///   - timeout: The amount of time a snapshot must be generated in.
///   - file: The file in which failure occurred. Defaults to the file name of the test case in which this function was called.
///   - testName: The name of the test in which failure occurred. Defaults to the function name of the test case in which this function was called.
///   - line: The line number on which failure occurred. Defaults to the line number on which this function was called.
func assertThemedNavigationSnapshot(
    for themes: [UIUserInterfaceStyle] = [.light, .dark],
    matching value: UINavigationController,
    record recording: Bool = false,
    timeout: TimeInterval = 5,
    file: StaticString = #file,
    testName: String = #function,
    line: UInt = #line
    ) {
    enforceSnapshotDevice()

    for theme in themes {
        value.overrideUserInterfaceStyle = theme

        assertSnapshot(
            matching: value,
            as: .image(precision: 0.99),
            named: theme.displayName,
            record: recording,
            timeout: timeout,
            file: file,
            testName: testName,
            line: line
        )
    }
}

/// Asserts that a given value matches a reference on disk.
/// This overload makes two snapshots with "Light" and "Dark" user interface style in a UIView.
///
/// - Parameters:
///
///   - themes: An array of UIUserInterfaceStyle you want to test.
///   - value: A value to compare against a reference.
///   - size: An optional size of the snapshot.   
///   - name: An optional description of the snapshot.
///   - recording: Whether or not to record a new reference.
///   - timeout: The amount of time a snapshot must be generated in.
///   - file: The file in which failure occurred. Defaults to the file name of the test case in which this function was called.
///   - testName: The name of the test in which failure occurred. Defaults to the function name of the test case in which this function was called.
///   - line: The line number on which failure occurred. Defaults to the line number on which this function was called.
func assertThemedViewSnapshot(
    for themes: [UIUserInterfaceStyle] = [.light, .dark],
    matching value: UIView,
    with size: CGSize? = nil,
    record recording: Bool = false,
    timeout: TimeInterval = 5,
    file: StaticString = #file,
    testName: String = #function,
    line: UInt = #line
    ) {
    enforceSnapshotDevice()

    for theme in themes {
        value.overrideUserInterfaceStyle = theme

        assertSnapshot(
            matching: value,
            as: .image(precision: 0.99, size: size),
            named: theme.displayName,
            record: recording,
            timeout: timeout,
            file: file,
            testName: testName,
            line: line
        )
    }
}

/// Asserts that a given value matches a reference on disk.
/// This overload makes two snapshots with "Light" and "Dark" user interface style in a UIViewController on a iPhoneSE device.
///
/// - Parameters:
///
///   - themes: An array of UIUserInterfaceStyle you want to test.
///   - value: A value to compare against a reference.
func assertThemedLandscapeViewControllerSnapshot(
    for themes: [UIUserInterfaceStyle] = [.light, .dark],
    matching value: UIViewController,
    record recording: Bool = false,
    timeout: TimeInterval = 5,
    file: StaticString = #file,
    testName: String = #function,
    line: UInt = #line
) {
    enforceSnapshotDevice()

    for theme in themes {
        value.view.overrideUserInterfaceStyle = theme

        assertSnapshot(
            matching: value,
            as: .image(on: .iPhoneSe(.landscape), precision: 0.99),
            named: "landscape-\(theme.displayName)",
            record: recording,
            timeout: timeout,
            file: file,
            testName: testName,
            line: line
        )
    }
}

private func enforceSnapshotDevice() {
    let is2xDevice = UIScreen.main.scale == 2
    let isVersion18 = ProcessInfo().operatingSystemVersion.majorVersion == 18

    guard is2xDevice, isVersion18 else {
        fatalError("Running device should have @2x screen scale (like iPhone SE) and iOS18.")
    }
}

private extension UIUserInterfaceStyle {
    var displayName: String {
        switch self {
        case .light:
            return "Light"
        case .dark:
            return "Dark"
        default:
            return ""
        }
    }
}
