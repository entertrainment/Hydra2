import CoreML
import Foundation

/// Uses a CoreML model to provide an anomaly (threat) score.
/// Ensure your CoreML model (e.g., ThreatModel.mlmodel) is added to the project.
class AnomalyDetector {
    static let shared = AnomalyDetector()
    
    // ThreatModel is the auto-generated class from your CoreML model.
    let model: ThreatModel?
    
    private init() {
        model = try? ThreatModel(configuration: MLModelConfiguration())
    }
    
    /// Predicts a threat score based on input features.
    func predictThreatScore(features: [Double]) -> Double? {
        guard let model = model else { return nil }
        guard let mlArray = try? MLMultiArray(shape: [NSNumber(value: features.count)], dataType: .double) else {
            return nil
        }
        for (i, feature) in features.enumerated() {
            mlArray[i] = NSNumber(value: feature)
        }
        guard let output = try? model.prediction(input: ThreatModelInput(features: mlArray)) else {
            return nil
        }
        return output.threatScore.doubleValue
    }
}
