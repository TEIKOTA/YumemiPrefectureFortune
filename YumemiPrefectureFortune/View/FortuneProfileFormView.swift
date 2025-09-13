import SwiftUI
import SwiftData
import PhotosUI

struct FortuneProfileFormView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @StateObject var viewModel: FortuneProfileFormViewModel
    
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var imageError: Error?
    @State private var showImageErrorAlert: Bool = false
    
    @State private var validationError: Error?
    @State private var showValidationErrorAlert: Bool = false
    
    private let labelWidth: CGFloat = 80
    private let componentHeight: CGFloat = 24
    
    init(user: UserProfile?) {
        _viewModel = StateObject(wrappedValue: FortuneProfileFormViewModel(user: user))
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                
                PhotosPicker(
                    selection: $selectedPhotoItem,
                    matching: .images,
                    photoLibrary: .shared()
                ) {
                    ZStack(alignment: .center) {
                        let diameter: CGFloat = 100
                        if let image = viewModel.iconImage {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: diameter, height: diameter)
                                .clipShape(Circle())
                        } else {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: diameter, height: diameter)
                                .foregroundColor(Color(UIColor.placeholderText))
                                .clipShape(Circle())
                        }

                        let radius: CGFloat = diameter / 2
                        let angle = CGFloat.pi / 4
                        
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: diameter * 0.3))
                            .foregroundColor(.accentColor)
                            .background(Circle().fill(Color(UIColor.systemBackground)))
                            .offset(
                                x: radius * cos(angle),
                                y: radius * sin(angle)
                            )
                    }
                }
                .padding(.bottom)
                .onChange(of: selectedPhotoItem) { _, newItem in
                    Task {
                        do {
                            try await viewModel.loadIcon(from: newItem)
                        } catch {
                            self.imageError = error
                            self.showImageErrorAlert = true
                        }
                    }
                }

                Divider()
                
                HStack {
                    
                    Text("名前")
                        .frame(width: labelWidth,
                               height: componentHeight,
                               alignment: .leading)
                    TextField("名前を入力",
                              text: $viewModel.name.nonOptional(defaultValue: ""))
                    .frame(height: componentHeight)
                    .onChange(of: viewModel.name ?? "") { oldValue, newValue in
                        /// APIの理論上の最大文字数は127だが視認性の観点から16にする
                        let nameMaxLength: Int = 16
                        
                        if newValue.count > nameMaxLength {
                            viewModel.name = String(newValue.prefix(nameMaxLength))
                        }
                    }
                    
                }
                Divider()
                
                HStack {
                    
                    Text("生年月日")
                        .frame(width: labelWidth,
                               height: componentHeight,
                               alignment: .leading)
                    DateSelectionButton(
                        placeholder: "日付を選択",
                        selection: $viewModel.birthday
                    )
                    .frame(height: componentHeight)
                    
                }
                Divider()
                
                HStack {
                    
                    Text("血液型")
                        .frame(width: labelWidth - 10,
                               height: componentHeight,
                               alignment: .leading)
                    
                    Picker("BloodTypePicker",
                           selection: $viewModel.bloodType) {
                        Text("血液型を選択")
                            .tag(nil as BloodType?)
                        ForEach(BloodType.allCases) { bloodType in
                            Text(bloodType.displayName)
                                .tag(bloodType as BloodType?)
                        }
                    }
                           .frame(height: componentHeight)
                           .accentColor(viewModel.bloodType == nil ?
                                        Color(UIColor.placeholderText) : .accentColor)
                    
                    Spacer()
                    
                }
                Divider()
                
                HStack {
                    
                    VStack {
                        Text("自己紹介")
                            .frame(width: labelWidth,
                                   height: componentHeight,
                                   alignment: .leading)
                        Spacer()
                    }
                    
                    VStack {
                        ZStack(alignment: .topLeading) {
                            TextEditor(text: $viewModel.introduction.nonOptional(defaultValue: ""))
                            VStack {
                                if viewModel.introduction?.isEmpty ?? true {
                                    Text("任意")
                                        .frame(width: .infinity,
                                               height: componentHeight,
                                               alignment: .leading)
                                        .foregroundColor(Color(UIColor.placeholderText))
                                    Spacer()
                                }
                            }
                        }
                        Spacer()
                    }
                }
                .frame(height: componentHeight * 3)
                Divider()
                Spacer()
                
            }
            .padding(24)
            .alert("画像読み込みエラー", isPresented: $showImageErrorAlert, presenting: imageError) { _ in
                Button("OK") {}
            } message: { error in
                Text(error.localizedDescription)
            }
            .alert("入力エラー", isPresented: $showValidationErrorAlert, presenting: validationError) { _ in
                Button("OK") {}
            } message: { error in
                Text(error.localizedDescription)
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("キャンセル") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("保存") {
                        do {
                            let savedProfile = try viewModel.save()
                            
                            if case .create = viewModel.mode {
                                modelContext.insert(savedProfile)
                            }
                            
                            dismiss()
                        } catch {
                            self.validationError = error
                            self.showValidationErrorAlert = true
                        }
                    }
                }
            }
        }
    }
}

#Preview("light") {
    PreviewSheetWrapper()
        .preferredColorScheme(.light)
}

#Preview("dark") {
    PreviewSheetWrapper()
        .preferredColorScheme(.dark)
}

struct PreviewSheetWrapper: View {
    @State private var showSheet = true
    
    var body: some View {
        Text("Preview")
            .sheet(isPresented: $showSheet) {
                FortuneProfileFormView(user: nil)
                    .presentationCornerRadius(24)
            }
    }
}
