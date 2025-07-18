// LiDAR wound scanner: full working code in one Swift file (updated for device compatibility + alert)

import UIKit
import ARKit
import SceneKit
import ModelIO
import MetalKit

class ViewController: UIViewController, ARSessionDelegate, ARSCNViewDelegate {
    var sceneView: ARSCNView!
    var scanButton: UIButton!

    private var meshAnchors: [ARMeshAnchor] = []
    private var isScanning = false

    override func viewDidLoad() {
        checkCameraPermissions()
        super.viewDidLoad()

        sceneView = ARSCNView(frame: view.bounds)
        sceneView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        sceneView.debugOptions = [.showFeaturePoints, .showWorldOrigin]
        sceneView.showsStatistics = true
        view.addSubview(sceneView)

        scanButton = UIButton(type: .system)
        scanButton.setTitle("Start Scan", for: .normal)
        scanButton.frame = CGRect(x: 20, y: 50, width: 120, height: 50)
        view.addSubview(scanButton)

        sceneView.delegate = self
        sceneView.session.delegate = self
        sceneView.automaticallyUpdatesLighting = true

        scanButton.addTarget(self, action: #selector(toggleScan), for: .touchUpInside)
        }

    func checkCameraPermissions() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            break
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if !granted {
                    DispatchQueue.main.async {
                        self.showAlert(title: "Camera Access Required", message: "Enable camera access in Settings to use this feature.")
                    }
                }
            }
        default:
            showAlert(title: "Camera Access Denied", message: "Please enable camera access in Settings.")
        }
    }

override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let config = ARWorldTrackingConfiguration()

        var lidarSupported = true

        // Safe scene reconstruction check
        if ARWorldTrackingConfiguration.supportsSceneReconstruction(.meshWithClassification) {
            config.sceneReconstruction = .meshWithClassification
        } else if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) {
            config.sceneReconstruction = .mesh
        } else {
            lidarSupported = false
            print("Scene reconstruction not supported on this device.")
        }

        // Only enable frame semantics if supported
        if ARWorldTrackingConfiguration.supportsFrameSemantics(.sceneDepth) {
            config.frameSemantics.insert(.sceneDepth)
        } else {
            lidarSupported = false
            print("Scene depth not supported on this device.")
        }

        if !lidarSupported {
            showAlert(title: "Unsupported Device", message: "Your device does not support LiDAR scanning. Please use an iPhone/iPad with LiDAR.")
            return
        }

        sceneView.session.run(config, options: [])
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }

    @objc func toggleScan() {
        isScanning.toggle()
        scanButton.setTitle(isScanning ? "Finish" : "Start Scan", for: .normal)

        if !isScanning {
            processScan()
        } else {
            meshAnchors.removeAll()
        }
    }

    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        guard isScanning else { return }
        for anchor in anchors {
            if let mesh = anchor as? ARMeshAnchor {
                meshAnchors.append(mesh)
            }
        }
    }

    func processScan() {
        guard let device = MTLCreateSystemDefaultDevice() else { return }
        guard !meshAnchors.isEmpty else { return }

        let vertices = meshAnchors.flatMap { extractVertices(from: $0) }
        let indices = meshAnchors.flatMap { extractIndices(from: $0) }

        let geometry = buildSCNGeometry(vertices: vertices, indices: indices)
        let measurements = computeMeasurements(vertices: vertices, indices: indices)

        let fileURL = exportMeshOBJ(vertices: vertices, indices: indices)
        uploadResults(meshURL: fileURL, measurements: measurements)
    }

    func extractVertices(from anchor: ARMeshAnchor) -> [SCNVector3] {
        let geometry = anchor.geometry
        let vertexBuffer = geometry.vertices.buffer
        let vertexCount = geometry.vertices.count
        let stride = geometry.vertices.stride
        let offset = geometry.vertices.offset

        var result: [SCNVector3] = []
        for i in 0..<vertexCount {
            let pointer = vertexBuffer.contents().advanced(by: i * stride + offset)
            let position = pointer.assumingMemoryBound(to: SIMD3<Float>.self).pointee
            let worldPosition = anchor.transform * SIMD4<Float>(position, 1.0)
            result.append(SCNVector3(worldPosition.x, worldPosition.y, worldPosition.z))
        }
        return result
    }

    func extractIndices(from anchor: ARMeshAnchor) -> [UInt32] {
        let geometry = anchor.geometry
        let indexBuffer = geometry.faces.buffer
        let faceCount = geometry.faces.count
        let stride = geometry.faces.indexCountPerPrimitive

        var indices: [UInt32] = []
        for i in 0..<faceCount {
            let pointer = indexBuffer.contents().advanced(by: i * stride * MemoryLayout<UInt32>.stride)
            let index = pointer.assumingMemoryBound(to: UInt32.self)
            indices.append(index[0])
            indices.append(index[1])
            indices.append(index[2])
        }
        return indices
    }

    func buildSCNGeometry(vertices: [SCNVector3], indices: [UInt32]) -> SCNGeometry {
        let vertexSource = SCNGeometrySource(vertices: vertices)
        let indexData = Data(bytes: indices, count: indices.count * MemoryLayout<UInt32>.stride)
        let element = SCNGeometryElement(data: indexData,
                                         primitiveType: .triangles,
                                         primitiveCount: indices.count / 3,
                                         bytesPerIndex: MemoryLayout<UInt32>.stride)
        return SCNGeometry(sources: [vertexSource], elements: [element])
    }

    func computeMeasurements(vertices: [SCNVector3], indices: [UInt32]) -> [String: Any] {
        var area: Float = 0
        var volume: Float = 0

        for i in stride(from: 0, to: indices.count, by: 3) {
            let v0 = vertices[Int(indices[i])]
            let v1 = vertices[Int(indices[i+1])]
            let v2 = vertices[Int(indices[i+2])]

            area += triangleArea(v0, v1, v2)
            volume += signedVolume(v0, v1, v2)
        }

        return [
            "area_cm2": Double(area * 1e4),
            "volume_cm3": Double(abs(volume) * 1e6)
        ]
    }

    func triangleArea(_ v0: SCNVector3, _ v1: SCNVector3, _ v2: SCNVector3) -> Float {
        let a = v1 - v0
        let b = v2 - v0
        return a.cross(b).length() * 0.5
    }

    func signedVolume(_ v0: SCNVector3, _ v1: SCNVector3, _ v2: SCNVector3) -> Float {
        return v0.dot(v1.cross(v2)) / 6.0
    }

    func exportMeshOBJ(vertices: [SCNVector3], indices: [UInt32]) -> URL {
        var obj = "v\n"
        for v in vertices {
            obj += "v \(v.x) \(v.y) \(v.z)\n"
        }
        for i in stride(from: 0, to: indices.count, by: 3) {
            obj += "f \(indices[i]+1) \(indices[i+1]+1) \(indices[i+2]+1)\n"
        }

        let url = FileManager.default.temporaryDirectory.appendingPathComponent("mesh.obj")
        try? obj.write(to: url, atomically: true, encoding: .utf8)
        return url
    }

    func uploadResults(meshURL: URL, measurements: [String: Any]) {
        guard let meshData = try? Data(contentsOf: meshURL) else { return }
        let payload: [String: Any] = [
            "patientId": "123",
            "timestamp": ISO8601DateFormatter().string(from: Date()),
            "measurements": measurements,
            "meshObj": meshData.base64EncodedString()
        ]

        guard let json = try? JSONSerialization.data(withJSONObject: payload) else { return }

        var request = URLRequest(url: URL(string: "https://your.api/endpoint")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = json

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Upload error: \(error)")
            } else {
                print("Upload complete.")
            }
        }.resume()
    }

    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension SCNVector3 {
    static func - (lhs: SCNVector3, rhs: SCNVector3) -> SCNVector3 {
        return SCNVector3(lhs.x - rhs.x, lhs.y - rhs.y, lhs.z - rhs.z)
    }
    func dot(_ v: SCNVector3) -> Float {
        return x * v.x + y * v.y + z * v.z
    }
    func cross(_ v: SCNVector3) -> SCNVector3 {
        return SCNVector3(
            y * v.z - z * v.y,
            z * v.x - x * v.z,
            x * v.y - y * v.x
        )
    }
    func length() -> Float {
        return sqrt(x * x + y * y + z * z)
    }
}
