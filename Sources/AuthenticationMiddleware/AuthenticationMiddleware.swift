import OpenAPIRuntime
import Foundation
import HTTPTypes

package struct AuthenticationMiddleware {
    private let userID: String?
    private let client: String
    private let device: String
    private let deviceID: String
    private let version: String

    package init(
        userID: String?,
        client: String,
        device: String,
        deviceID: String,
        version: String
    ) {
        self.userID = userID
        self.client = client
        self.device = device
        self.deviceID = deviceID
        self.version = version
    }
}

extension AuthenticationMiddleware: ClientMiddleware {
    package func intercept(
        _ request: HTTPRequest,
        body: HTTPBody?,
        baseURL: URL,
        operationID: String,
        next: (HTTPRequest, HTTPBody?, URL) async throws -> (HTTPResponse, HTTPBody?)
    ) async throws -> (HTTPResponse, HTTPBody?) {
        var request = request
        request.headerFields[.authorization] = authHeaders()
        return try await next(request, body, baseURL)
    }

    private func authHeaders() -> String {
        let fields = [
            "DeviceId": deviceID,
            "Device": device,
            "Client": client,
            "Version": version
        ]
            .map { "\($0.key)=\($0.value)" }
            .joined(separator: ", ")
        return "Emby \(fields)"
    }
}