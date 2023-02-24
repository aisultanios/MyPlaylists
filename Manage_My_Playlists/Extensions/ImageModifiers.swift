//
//  ImageModifiers.swift
//  Manage_My_Playlists
//
//  Created by Aisultan Askarov on 8.01.2023.
//

import SwiftUI
import UIKit

extension UIImage {
    
    func getPixelColor() -> [UIColor]? {
        
        guard let pixelData = self.cgImage?.dataProvider?.data else { return nil }
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        
        var colors = [UIColor]()
        
        for i in 0..<Int(self.size.height) {
            
            let pixelInfo: Int = ((Int(self.size.width) * i) + Int(20)) * 3
            
            let r = CGFloat(data[pixelInfo]) / CGFloat(255.0)
            let g = CGFloat(data[pixelInfo+1]) / CGFloat(255.0)
            let b = CGFloat(data[pixelInfo+2]) / CGFloat(255.0)
            
            colors.append(UIColor(red: r, green: g, blue: b, alpha: 1.0))
        }
        
        return colors
    }
    
    var averageColor: UIColor? {
        guard let inputImage = CIImage(image: self) else { return nil }
        let extentVector = CIVector(x: inputImage.extent.origin.x, y: inputImage.extent.origin.y, z: inputImage.extent.size.width, w: inputImage.extent.size.height)
        
        guard let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: extentVector]) else { return nil }
        guard let outputImage = filter.outputImage else { return nil }
        
        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [.workingColorSpace: kCFNull!])
        context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: .RGBA8, colorSpace: nil)
        
        return UIColor(red: CGFloat(bitmap[0]) / 255, green: CGFloat(bitmap[1]) / 255, blue: CGFloat(bitmap[2]) / 255, alpha: CGFloat(bitmap[3]) / 255)
    }
    
}

extension Image {

    func navBtnModifier() -> some View {
        self
            .resizable()
            .scaledToFit()
            .clipShape(Circle())
            .foregroundColor(.gray.opacity(0.15))
    }
    
    func featuredArtistImageModifier(width: CGFloat?, height: CGFloat?) -> some View {
        self
            .resizable()
            .scaledToFill()
            .clipShape(Circle())
            .background(.clear)
            .frame(width: width ?? 10.0, height: height ?? 10.0, alignment: .top)
    }
    
    func playlistArtworkImageModifier(width: CGFloat) -> some View {
        self
            .resizable()
            .scaledToFill()
            .aspectRatio(contentMode: .fill)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .frame(width: width - 145, height: width - 145, alignment: .center)
            .shadow(color: .gray, radius: 0.35)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: width - 175, height: width - 180, alignment: .center)
                    .ignoresSafeArea(.container, edges: .bottom)
                    .shadow(color: .black.opacity(0.17), radius: 20, x: 0, y: 30)
            }
    }
    
    func playlistsPlayBtnImageModifiers() -> some View {
        self
            .resizable()
            .scaledToFit()
            .frame(width: 15, height: 15, alignment: .center)
            .foregroundColor(.pink)
            .tint(.pink)
            .colorMultiply(.pink)
    }
    
    func playlistsShuffleBtnImageModifiers() -> some View {
        self
            .resizable()
            .scaledToFit()
            .frame(width: 20, height: 20, alignment: .center)
            .foregroundColor(.pink)
            .tint(.pink)
            .colorMultiply(.pink)
    }
    
    func trackCoverImageModifier() -> some View {
        self
            .resizable()
            .scaledToFit()
            .clipShape(RoundedRectangle(cornerRadius: 6.5))
    }
    
    func trackCoverPlaceholderModifier() -> some View {
        self
            .resizable()
            .scaledToFit()
            .clipShape(RoundedRectangle(cornerRadius: 6.5))
            .frame(width: 47.5, height: 47.5)
            .foregroundColor(.gray.opacity(0.35))
    }
    
    func trackCellEllipseModifier() -> some View {
        self
            .resizable()
            .scaledToFit()
            .frame(width: 20, height: 55.0, alignment: .center)
            .foregroundColor(.black)
    }
    
}
