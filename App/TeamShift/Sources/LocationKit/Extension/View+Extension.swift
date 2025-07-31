import CoreLocation
import MapKit
import SwiftUI

extension View {
    public func locationPicker(isPresented: Binding<Bool>, coordinates: @escaping (CLLocationCoordinate2D?) -> Void) -> some View {
        self.fullScreenCover(isPresented: isPresented) {
        }
    }
}
