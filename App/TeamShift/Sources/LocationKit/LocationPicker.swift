import CoreLocation
import MapKit
import SharedUIs
import SwiftUI

// https://www.youtube.com/watch?v=U2kBmasBSTA&t=108s
public struct LocationPicker: View {
    public init() {
        self._isPresented = .constant(false) // TODO: not related since it will be done by Coordinator
    }
    
    // MARK: Properties
    @Binding var isPresented: Bool
    @StateObject private var manager = LocationManager()
    @Environment(\.openURL) private var openURL
    @Namespace private var mapSpace
    @FocusState private var isKeyboardActive: Bool
    var coordinates: ((CLLocationCoordinate2D?) -> Void) = { _ in }
    
   public  var body: some View {
        ZStack {
            if !manager.isUpdating {
                if manager.isPermissionDenied {
                    noPermissionView
                } else {
                    ZStack {
                        searchResultView
                        
                        mapView
                            .safeAreaInset(edge: .bottom, spacing: 0) {
                                selectLocationButton
                            }
                            .opacity(manager.showSearchResults ? 0 : 1)
                            .ignoresSafeArea(.keyboard, edges: .all)
                    }
                    .safeAreaInset(edge: .top, spacing: 0) {
                        mapSearchBar
                    }
                }
            } else {
                Group {
                    Rectangle()
                        .fill(.ultraThinMaterial)
                        .ignoresSafeArea()
                    
                    ProgressView()
                }
            }
        }
        .onAppear(perform: manager.requestUserLocation)
        .animation(.easeInOut(duration: 0.25), value: manager.showSearchResults)
    }
    
    @ViewBuilder
    private var noPermissionView: some View {
        ZStack(alignment: .bottom) {
            Rectangle()
                .fill(.ultraThinMaterial)
                .ignoresSafeArea()
            
            Text("Please allow location permission\nin app settings!")
                .font(.customSubHeadline)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            Button {
            } label: {
                Image(systemName: "xmark")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.primary)
                    .padding(15)
                    .contentShape(.rect)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            
            // try again and go to setting button
            VStack(spacing: 12) {
                Button {
                    if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                        openURL(settingsURL)
                    }
                } label: {
                    Text("Go to Settings")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .foregroundStyle(.background)
                        .background(Color.primary, in: .rect(cornerRadius: 12))
                }
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 10)
        }
    }
    
    @ViewBuilder
    private var mapView: some View {
        MapReader { proxy in
            Map(position: $manager.position) {
                if let selectedCoordinates = manager.selectedCoordinate {
                    Marker(coordinate: selectedCoordinates) {
                        Text("Selected")
                    }
                }
                
                UserAnnotation()
            }
            .onTapGesture { screenCoordinate in
                // get coordinates of tapped location
                if let coordinate = proxy.convert(screenCoordinate, from: .local) {
                    print("Tapped coordinate: \(coordinate.latitude), \(coordinate.longitude)")
                    manager.selectedCoordinate = coordinate
                }
            }
            .mapControls {
                MapUserLocationButton(scope: mapSpace)
                MapCompass(scope: mapSpace)
                MapPitchToggle(scope: mapSpace)
            }
            .mapScope(mapSpace)
            .onMapCameraChange { ctx in
                manager.currentRegion = ctx.region
            }
        }
    }
    
    @ViewBuilder
    private var mapSearchBar: some View {
        VStack(spacing: 15) {
            Text("Select Location")
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
                .overlay(alignment: .leading) {
                    Button {
                        if manager.showSearchResults {
                            isKeyboardActive = false
                            manager.clearSearchResult()
                            manager.showSearchResults = false
                        } else {
                            isPresented = false
                        }
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.primary)
                            .contentShape(.rect)
                    }
                }
            
            HStack(spacing: 12) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.gray)
                
                TextField("Search", text: $manager.searchText)
                    .padding(.vertical, 10)
                    .focused($isKeyboardActive)
                    .submitLabel(.search)
                    .onSubmit {
                        // if empty search text then closing the search view
                        // else searching the relevant places
                        if manager.searchText.isEmpty {
                            manager.clearSearchResult()
                        } else {
                            manager.searchForPlaces()
                        }
                    }
                    .onChange(of: isKeyboardActive) { _, newValue in
                        if newValue {
                            manager.showSearchResults = true
                        }
                    }
                    .contentShape(.rect)
                
                if manager.showSearchResults {
                    Button {
                        // only clear search result
                        manager.clearSearchResult()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title3)
                            .foregroundStyle(.gray)
                    }
                }
            }
            .padding(.horizontal, 15)
            .background(.ultraThinMaterial, in: .rect(cornerRadius: 10))
        }
        .padding(15)
        .background(.background)
    }
    
    @ViewBuilder
    private var selectLocationButton: some View {
        Button {
            isPresented = false
            coordinates(manager.selectedCoordinate)
        } label: {
            Text("Select Location")
                .fontWeight(.semibold)
                .foregroundStyle(Color.primary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(.ultraThinMaterial, in: .rect(cornerRadius: 10))
        }
        .padding(15)
        .background(.background)
    }
    
    @ViewBuilder
    private var searchResultView: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 15) {
                ForEach(manager.searchResult, id: \.self) { placemark in
                    searchResultCardView(placemark)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .background(.background)
    }
    
    @ViewBuilder
    private func searchResultCardView(_ placemark: MKPlacemark) -> some View {
        VStack(spacing: 10) {
            HStack(spacing: 10) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(placemark.name ?? "")
                    
                    Text(placemark.title ?? placemark.subtitle ?? "")
                        .font(.caption)
                        .foregroundStyle(.gray)
                }
                
                Spacer(minLength: 0)
                
                Image(systemName: "checkmark")
                    .font(.callout)
                    .foregroundStyle(.gray)
                    .opacity(manager.selectedResult == placemark ? 1 : 0)
            }
            
            Divider()
        }
        .contentShape(.rect)
        .onTapGesture {
            isKeyboardActive = false
            // updating map position
            manager.updateMapPosition(placemark)
        }
    }
}
