//
//  ImageLoader.swift
//  RecipeFinder
//
//  Created by Shushanik Barseghyan on 18.12.24.
//

import SwiftUI

class ImageLoader: ObservableObject {
    @Published var image: UIImage?

    func loadImage(from url: URL?) {
        guard let url = url else {
            self.image = nil
            return
        }

        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url), let uiImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = uiImage
                }
            } else {
                DispatchQueue.main.async {
                    self.image = nil
                }
            }
        }
    }
}

struct LoadedImage: View {
    @StateObject private var loader = ImageLoader()
    let url: String
    let placeholder = Placeholder()

    var body: some View {
        Group {
            if let uiImage = loader.image {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
            } else {
                placeholder
            }
        }
        .onAppear {
            loader.loadImage(from: URL(string: url))
        }
    }
}

struct Placeholder: View {
    var body: some View {
        Image(systemName: "fork.knife.circle")
            .resizable()
            .scaledToFit()
            .foregroundStyle(Color.accentColor.opacity(0.6))
    }
}
