//
//  DummyControlBundle.swift
//  DummyControl
//
//  Created by Kan Tao on 2024/8/11.
//

import WidgetKit
import SwiftUI

@main
struct DummyControlBundle: WidgetBundle {
    var body: some Widget {
        DummyControl()
        DummyControlControl()
    }
}
