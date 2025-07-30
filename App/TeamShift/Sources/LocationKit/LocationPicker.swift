import CoreLocation
import MapKit
import SharedModels
import SharedUIs
import SwiftUI

// https://www.youtube.com/watch?v=U2kBmasBSTA&t=108s
public struct LocationPicker: View {
    public init(onLocationSelected: @escaping ((Coordinate?) -> Void)) {
        self.onLocationSelected = onLocationSelected
    }
    
    // MARK: Properties
    //    @Binding var isPresented: Bool(Presenting with swiftUI)
    @State private var manager = LocationManager()
    @Environment(\.openURL) private var openURL
    @Environment(\.dismiss) private var dismiss
    @Namespace private var mapSpace
    @FocusState private var isKeyboardActive: Bool
    var onLocationSelected: ((Coordinate?) -> Void)
    
    public  var body: some View {
        NavigationView {
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
                    mapLoadingView
                }
            }
            .onAppear(perform: manager.requestUserLocation)
            .animation(.easeInOut(duration: 0.25), value: manager.showSearchResults)
            .navigationBar("Select Location")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    backButton
                }
            }
        }
    }
}

// MARK: Views
extension LocationPicker {
    @ViewBuilder
    private var backButton: some View {
        Button {
            if manager.showSearchResults {
                isKeyboardActive = false
                manager.clearSearchResult()
                manager.showSearchResults = false
            } else {
                // Dismiss
                // isPresented = false
                dismiss()
            }
        } label: {
            (manager.showSearchResults ? Image.icnBack : Image.icnClose)
                .renderingMode(.template)
                .foregroundStyle(Color.appPrimary)
                .contentShape(.rect)
        }
    }
    
    @ViewBuilder
    private var mapLoadingView: some View {
        Group {
            Rectangle()
                .fill(.ultraThinMaterial)
                .ignoresSafeArea()
            
            ProgressView()
                .foregroundStyle(Color.appPrimary)
        }
    }
    
    @ViewBuilder
    private var noPermissionView: some View {
        ZStack(alignment: .bottom) {
            Text("Please allow location permission\nin app settings!")
                .font(.customSubHeadline)
                .foregroundStyle(Color.appPrimary)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            // try again and go to setting button
            PrimaryButton(title: "Go to Settings") {
                if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                    openURL(settingsURL)
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
                    Marker(coordinate: selectedCoordinates) { Text("") }
                }
                
                UserAnnotation()
            }
            .onTapGesture { screenCoordinate in
                // get coordinates of tapped location
                if let coordinate = proxy.convert(screenCoordinate, from: .local) {
                    print("Tapped coordinate: \(coordinate.latitude), \(coordinate.longitude)")
                    manager.mapLocationSelected(on: coordinate)
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
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(Color.textSecondary)
                .fontWeight(.semibold)
            
            TextField("Search", text: $manager.searchText)
                .font(.customSubHeadline)
                .foregroundStyle(Color.textPrimary)
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
                        .foregroundStyle(Color.textSecondary)
                }
            }
        }
        .padding(.horizontal, 16)
        .background(.ultraThinMaterial, in: .rect(cornerRadius: 10))
        .padding(.horizontal, 16)
        .padding(.bottom, 16)
        .background(.background)
    }
    
    @ViewBuilder
    private var selectLocationButton: some View {
        PrimaryButton(title: "Select Location") {
            // Dismiss and pass the result to previous screen
            // isPresented = false
            onLocationSelected(Coordinate(from: manager.selectedCoordinate))
            dismiss()
        }
        .padding(16)
        .background(.background)
    }
    
    @ViewBuilder
    private var searchResultView: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 16) {
                ForEach(manager.searchResult, id: \.self) { placeMark in
                    searchResultCardView(placeMark)
                        .padding(.horizontal, 16)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .background(.background)
    }
    
    @ViewBuilder
    private func searchResultCardView(_ placeMark: MKPlacemark) -> some View {
        VStack(spacing: 10) {
            HStack(spacing: 10) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(placeMark.name ?? "")
                        .font(.customSubHeadline)
                        .foregroundStyle(Color.appPrimary)
                    
                    Text(placeMark.title ?? placeMark.subtitle ?? "")
                        .font(.customCaption)
                        .foregroundStyle(Color.textSecondary)
                }
                
                Spacer(minLength: 0)
                
                Image(systemName: "checkmark")
                    .font(.callout)
                    .foregroundStyle(Color.appPrimary)
                    .opacity(manager.isPlaceMarkSelected(placeMark) ? 1 : 0)
            }
            
            Divider()
        }
        .contentShape(.rect)
        .onTapGesture {
            isKeyboardActive = false
            // updating map position
            manager.updateMapPosition(placeMark)
        }
    }
}
