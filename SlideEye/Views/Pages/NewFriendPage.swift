import SwiftUI
import PhotosUI

struct NewFriendPage: View {
    @Environment(ModelData.self) var modelData
    @Binding var friendDetails: Friend
    
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    
    func findCityDetails()
    {
        // TODO: implement automated timezone finding
    }
    
    func calculateID() -> Int
    {
        var id = 1001
        
        let friendsList = ModelData().friends
        if (friendsList.count > 0)
        {
             id = friendsList.last!.id + 1
        }
        else { }
        
        return id
    }
    
    var body: some View {
        List
        {
            Group
            {
                Section("Name"){
                    TextField("Name", text: $friendDetails.name)
                }
                .padding(.vertical, 30)
                .offset(y: 30)
                
                Section("Profile Picture"){
                    ZStack
                    {
                        friendDetails.profilePicture
                            .resizable()
                            .scaledToFit()
                        
                        Group
                        {
                            Rectangle()
                                .fill(.bar)
                                .frame(width: 100, height: 100)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .shadow(radius: 10)
                                .mask(
                                    Image(systemName: "person.and.background.dotted")
                                        .resizable()
                                        .frame(width: 50, height: 50)
                                        .foregroundStyle(.white)
                                )
                            
                        }
                        .onTapGesture(perform: {
                            self.showingImagePicker = true
                        })
                    }
                    
                    
                    /*friendDetails.profilePicture
                        .resizable()
                        .scaledToFit()
                        .overlay(alignment: .bottomTrailing) {
                            /*PhotosPicker(selection: $friendDetails.profilePicture,
                             matching: .images,
                             photoLibrary: .shared()) {
                             Image(systemName: "pencil.circle.fill")
                             .symbolRenderingMode(.multicolor)
                             .font(.system(size: 30))
                             .foregroundColor(.accentColor)
                             }
                             .buttonStyle(.borderless)*/
                        }*/
                }
                .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                            PhotoPicker(image: self.$inputImage)
                        }
                
                Section("Occupation"){
                    TextField("Occupation", text: $friendDetails.occupation)
                }
                
                Section("Location"){
                    TextField("Location", text: $friendDetails.location)
                }
                
                Section(header: Text("City"), footer: Text("Enter the closest larger city your friend lives in, it will be used to find some of the information below")){
                    TextField("City", text: $friendDetails.city)
                        .onSubmit {
                            findCityDetails()
                        }
                }
                
                Section("Country"){
                    TextField("Country", text: $friendDetails.country)
                }
                
                Section("Continent"){
                    TextField("Continent", text: $friendDetails.continent)
                }
                
                Section(header: Text("Time Zone ID"), footer: Text("This should conform to the following format: Continent/City, e.g. 'America/New_York'")){
                    TextField("Time Zone ID", text: $friendDetails.timeZoneID)
                }
                
                Section("Favorite"){
                    Toggle("Favorite", isOn: $friendDetails.isFavorite)
                }
                
                Section("Notes"){
                    TextField("Notes", text: $friendDetails.notes)
                }
            }
        }
        .onAppear(perform: {
            friendDetails.id = calculateID()
        })
    }
    
    func loadImage() {
            guard let inputImage = inputImage else { return }
            // Crop the image to a square based on the smallest dimension
            let sideLength = min(inputImage.size.width, inputImage.size.height)
            let squareCropRect = CGRect(x: (inputImage.size.width - sideLength) / 2, y: (inputImage.size.height - sideLength) / 2, width: sideLength, height: sideLength)
            if let croppedCGImage = inputImage.cgImage?.cropping(to: squareCropRect) {
                friendDetails.profilePicture = Image(uiImage: UIImage(cgImage: croppedCGImage))
            }
        }
    }

struct PhotoPicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    
    func makeUIViewController(context: Context) -> some UIViewController {
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var parent: PhotoPicker
        
        init(_ parent: PhotoPicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            
            guard let provider = results.first?.itemProvider else { return }
            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { image, _ in
                    DispatchQueue.main.async {
                        self.parent.image = image as? UIImage
                    }
                }
            }
        }
    }
}

#Preview {
    NewFriendPage(friendDetails: .constant(ModelData().friends[0]))
}
