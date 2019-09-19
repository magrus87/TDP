//
//  PointView.swift
//  TinkoffPoints
//
//  Created by Alexander Makarov on 16/09/2019.
//  Copyright © 2019 magrus87. All rights reserved.
//

import UIKit
import MapKit

class PointView: MKAnnotationView {
    
    private let size = CGSize(width: 20.0, height: 20.0)
    
    private var whiteBorderLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.white.cgColor
        return layer
    }()
    
    private var innerCircleLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.purple.cgColor
        return layer
    }()
    
    private var imageView = UIImageView()
    
//    override var annotation: MKAnnotation? {
//        willSet { calloutvi }
//    }
//    
//    override var annotation: MKAnnotation? {
//        willSet {
//            // 1
//            guard let artwork = newValue as? Artwork else { return }
//            canShowCallout = true
//            calloutOffset = CGPoint(x: -5, y: 5)
//            rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
//            // 2
//            markerTintColor = artwork.markerTintColor
//            glyphText = String(artwork.discipline.first!)
//        }
//    }
    
//    override var annotation: MKAnnotation? {
//        willSet { customCalloutView?.removeFromSuperview() }
//    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.clear
        
        layer.frame = CGRect(origin: .zero, size: size)
        layer.addSublayer(whiteBorderLayer)
        layer.addSublayer(innerCircleLayer)
        
        canShowCallout = true
        calloutOffset = CGPoint(x: 0.0, y: 0.0)
        image = nil
        
        rightCalloutAccessoryView = imageView
        detailCalloutAccessoryView = PointDetailView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return size
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        
        layer.cornerRadius = bounds.size.width/2

        whiteBorderLayer.path = UIBezierPath(roundedRect: bounds,
                                             cornerRadius: bounds.size.width/2).cgPath

        innerCircleLayer.path = UIBezierPath(roundedRect: CGRect(x: 3,
                                                                 y: 3,
                                                                 width: bounds.size.width - 6,
                                                                 height: bounds.size.height - 6),
                                             cornerRadius: (bounds.size.width - 6)/2).cgPath
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        
    }
    
    // MARK: - public
    
    func setImage(_ image: UIImage?) {
        imageView.frame = CGRect(origin: .zero, size: CGSize(width: 30.0, height: 30.0))
        imageView.image = image
    }
}
