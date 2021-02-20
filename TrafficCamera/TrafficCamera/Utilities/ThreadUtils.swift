//
//  ThreadUtils.swift
//  TrafficCamera
//
//  Created by Dhananjay Dubey on 20/2/21.
//

import Foundation

/// Executes provided closure on main thred
///
/// - Parameter workItem: Work item closure to be executed
func performOnMain(_ workItem: @escaping () -> Void) {
    if Thread.isMainThread {
        workItem()
    } else {
        DispatchQueue.main.async {
            workItem()
        }
    }
}
