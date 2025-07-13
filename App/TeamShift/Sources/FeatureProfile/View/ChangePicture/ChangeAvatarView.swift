import SharedUIs
import SwiftUI

struct ChangeAvatarView: View {
    // MARK: Init
    init(viewModel: ChangeAvatarViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: Properties
    @State private var viewModel: ChangeAvatarViewModel
    
    var body: some View {
        VStack {
            ZStack {
                Image.imgUser1
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            .frame(height: 250)
            .frame(maxWidth: .infinity)
            .background(Color.red)
            .vSpacing(.top)
            .safeAreaPadding(.top)
//            ZStack {
//                
//            }
//            .frame(height: 250)
//            .background(Color.purple.opacity(0.3))
//            
//            Image.imgUser1
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//                .vSpacing(.top)
//                .frame(width: 250, height: 250)
//                .vSpacing(.top)
        }
        .background(Color.backgroundPrimary)
    }
}

#Preview {
    ChangeAvatarView(viewModel: .init(coordinator: .init(navigationController: .init())))
}
