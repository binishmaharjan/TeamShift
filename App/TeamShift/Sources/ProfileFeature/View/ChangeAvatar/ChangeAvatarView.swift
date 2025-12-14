import SharedModels
import SharedUIs
import SwiftUI

struct ChangeAvatarView: View {
    // MARK: Init
    init(viewModel: ChangeAvatarViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: Properties
    @State private var viewModel: ChangeAvatarViewModel
    @State private var colorPickerSize: CGFloat = 40
    
    var body: some View {
        VStack(spacing: 16) {
            iconPreview
            
            VStack {
                colorTitle
                colorPicker
            }
            .padding(.horizontal, 16)
            
            VStack {
                iconTitle
                iconPicker
            }
            .padding(.horizontal, 16)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) { saveButton }
            }
        }
        .loadingView(viewModel.isLoading)
    }
}

extension ChangeAvatarView {
    @ViewBuilder
    private var saveButton: some View {
        Button {
            Task {
                await viewModel.updateAvatar()
            }
        } label: {
            Text(l10.commonButtonSave)
                .font(.customHeadline)
        }
        .buttonStyle(.toolbar)
        .disabled(!viewModel.isSavedButtonEnabled)
    }
    
    @ViewBuilder
    private var iconPreview: some View {
        (viewModel.selectedIconData?.image ?? Image.icnMan2)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(height: 250)
            .frame(maxWidth: .infinity)
            .padding(.top)
            .background(viewModel.selectedColorTemplate?.gradient)
    }
    
    @ViewBuilder
    private var colorTitle: some View {
        Text(l10.changeAvatarColorTitle)
            .font(.customSubHeadline)
            .foregroundStyle(Color.textPrimary)
            .hSpacing(.leading)
    }
    
    @ViewBuilder
    private var colorPicker: some View {
        GeometryReader { geometry in
            let spacing: CGFloat = 16
            let totalSpacing = spacing * CGFloat(viewModel.colorTemplates.count - 1)
            let availableWidth = geometry.size.width
            let itemSize = (availableWidth - totalSpacing) / CGFloat(viewModel.colorTemplates.count)
            
            HStack(spacing: spacing) {
                ForEach(viewModel.colorTemplates, id: \.id) { template in
                    colorItem(for: template, size: itemSize)
                }
            }
            .frame(maxWidth: .infinity)
            .preference(key: SizePreferenceKey.self, value: itemSize)
        }
        .frame(maxHeight: colorPickerSize)
        .onPreferenceChange(SizePreferenceKey.self) { [$colorPickerSize] value in
            $colorPickerSize.wrappedValue = value // OR: MainActor.assumeIsolated { self.colorPickerSize = value }
        }
    }
    
    @ViewBuilder
    private var iconTitle: some View {
        Text(l10.changeAvatarIconTitle)
            .font(.customSubHeadline)
            .foregroundStyle(Color.textPrimary)
            .hSpacing(.leading)
    }
    
    @ViewBuilder
    private var iconPicker: some View {
        GeometryReader { geometry in
            let spacing: CGFloat = 16
            let columns = 6
            let totalSpacing = spacing * CGFloat(columns - 1)
            let availableWidth = geometry.size.width
            let itemSize = (availableWidth - totalSpacing) / CGFloat(columns)
            
            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: spacing), count: columns), spacing: spacing) {
                    ForEach(viewModel.iconDatas, id: \.id) { iconData in
                        iconItem(for: iconData, size: itemSize)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func colorItem(for template: ColorTemplate, size: CGFloat) -> some View {
        Button {
            viewModel.selectedColorTemplate = template
        } label: {
            Circle()
                .fill(template.gradient)
                .frame(width: size, height: size)
                .overlay(
                    Circle()
                        .stroke(
                            viewModel.selectedColorTemplate?.id == template.id ? Color.appPrimary : Color.clear,
                            lineWidth: 3
                        )
                )
                .shadow(color: .textPrimary.opacity(0.1), radius: 4, x: 0, y: 2)
        }
    }
    
    @ViewBuilder
    private func iconItem(for iconData: IconData, size: CGFloat) -> some View {
        Button {
            viewModel.selectedIconData = iconData
        } label: {
            iconData.image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: size - 10, height: size - 10) // subtracting 10 for touch area
                .clipShape(Circle())
                .padding(5) // Add padding for better touch area
                .background(viewModel.selectedIconData?.id == iconData.id ? Color.appPrimary.opacity(0.5) : Color.clear)
                .clipShape(Circle())
        }
    }
}

#Preview {
    ChangeAvatarView(viewModel: .init(coordinator: .init(navigationController: .init())))
}
