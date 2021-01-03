//
//  OSLog.swift
//  ImageFirstUI
//
//  Created by Hervé LEMAI on 03/01/2021.
//
import Foundation
import os.log

extension OSLog {
    private static var subsystem = Bundle.main.bundleIdentifier!

    /// Logs the view cycles like viewDidLoad.
    static let imageLoad = OSLog(subsystem: subsystem, category: "imageLoading")
}
