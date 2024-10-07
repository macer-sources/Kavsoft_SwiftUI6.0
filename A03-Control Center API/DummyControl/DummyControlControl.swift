//
//  DummyControlControl.swift
//  DummyControl
//
//  Created by Kan Tao on 2024/8/11.
//

import AppIntents
import SwiftUI
import WidgetKit

struct DummyControlControl: ControlWidget {
    static let kind: String = "com.yonglekeji.A03-Control-Center-API.DummyControl"
    
    var body: some ControlWidgetConfiguration {
        StaticControlConfiguration(kind: Self.kind) {
            // toggle style
//            ControlWidgetToggle(isOn: SharedManager.shared.isTurnedOn, action: DymmyControlIntent()) {
//                Text("Living Room")
//            } valueLabel: { isTuredOn in
//                Image(systemName: isTuredOn ? "fan.fill": "fan")
//                Text(isTuredOn ? "Turned On" : "Turned Off")
//            }
            
            ControlWidgetButton(action: CaffineUpdateIntent(amount: 10.0)) {
                Image(systemName: "cup.and.saucer.fill")
                Text("Caffine In Take")
                let amount = SharedManager.shared.caffineInTake
                Text("\(String(format: "%.1f", amount)) mgs")
            }
            
        }
    }
}
 

struct CaffineUpdateIntent: AppIntent {
    static var title: LocalizedStringResource {"Update Caffine In Take"}
    @Parameter(title:"Amount Taken")
    var amount: Double
    
    init(amount: Double) {
        self.amount = amount
    }
    
    init() {
        
    }
    
    func perform() async throws -> some IntentResult {
        
        SharedManager.shared.caffineInTake += amount
        return .result()
    }
}

struct DymmyControlIntent: SetValueIntent {
    static var title: LocalizedStringResource {"Turn On Living Room Fan"}
    @Parameter(title: "is Turned On")
    var value: Bool
    
    func perform() async throws -> some IntentResult {
        // update conentet here
        SharedManager.shared.isTurnedOn = value
        return .result()
    }
}
