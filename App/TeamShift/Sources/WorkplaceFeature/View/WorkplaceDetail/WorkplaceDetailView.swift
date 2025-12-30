import LocationKit
import MapKit
import SharedModels
import SharedUIs
import SwiftUI

struct WorkplaceDetailView: View {
    init(viewModel: WorkplaceDetailViewModel) {
        self.viewModel = viewModel
    }
    
    @State private var viewModel: WorkplaceDetailViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                mapView
                    .frame(height: 200)

                contentView
                    .padding(.top, 16)
                    .padding(.horizontal, 20)
            }
        }
    }
}

extension WorkplaceDetailView {
    @ViewBuilder
    private var mapView: some View {
        if let locationName = viewModel.workplace.locationName, let locationCoord = viewModel.workplace.locationCoords {
            let coordinate = CLLocationCoordinate2D(latitude: locationCoord.latitude, longitude: locationCoord.longitude)
            MapView(coordinate: coordinate, location: locationName)
        } else {
            VStack(alignment: .center) {
                Image.icnLocation
                    .renderingMode(.template)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 64, height: 64)
                    .foregroundStyle(Color.textSecondary)
                
                Text("No Location Registered")
                    .font(.customHeadline)
                    .foregroundStyle(Color.textSecondary)
            }
            .frame(maxWidth: .infinity)
        }
    }

    @ViewBuilder
    private var contentView: some View {
        VStack(alignment: .leading, spacing: 24) {
            titleSection
            
            if viewModel.workplace.description != nil {
                descriptionSection
            }
            
            membersSection
        }
    }

    @ViewBuilder
    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(viewModel.workplace.name)
                .font(.customTitle3)
                .foregroundColor(Color.textPrimary)

            if let branchName = viewModel.workplace.branchName {
                Text(branchName)
                    .font(.customFootnote)
                    .foregroundColor(Color.textSecondary)
            }
            
            if let phoneNumber = viewModel.workplace.phoneNumber {
                Text(phoneNumber)
                    .font(.customFootnote)
                    .foregroundColor(Color.textSecondary)
            }
        }
    }

    @ViewBuilder
    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Description")
                .font(.customSubHeadline)
                .bold()
                .foregroundColor(Color.textPrimary)

            Text(viewModel.workplace.description.content)
                .font(.customFootnote)
                .foregroundColor(Color.textPrimary)
        }
    }

    @ViewBuilder
    private var membersSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Members")
                .font(.customSubHeadline)
                .bold()
                .foregroundColor(Color.textPrimary)

            VStack(spacing: 12) {
                ForEach(0..<3) { index in
                    memberRowPlaceholder
                    
                    if index != 2 {
                        Divider()
                    }
                }
            }
            .padding(.vertical)
            .padding(.leading)
            .background(Color.backgroundList.opacity(0.5))
            .cornerRadius(12)
        }
    }

    @ViewBuilder
    private var memberRowPlaceholder: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(Color.appPrimary.opacity(0.3))
                .frame(width: 44, height: 44)

            VStack(alignment: .leading) {
                Text("User Name")
                    .font(.customSubHeadline)
                    .foregroundColor(Color.textPrimary)
                Text("Role")
                    .font(.customCaption)
                    .foregroundColor(Color.textSecondary)
            }

            Spacer()
        }
    }
}

#Preview {
    NavigationView {
        NavigationView {
            WorkplaceDetailView(viewModel: WorkplaceDetailViewModel(workplace: .mockData))
                .navigationBar("Convenience store")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}
