//
//  APIService.swift
//  Studious Seal
//
//  Fetches dashboard data from the OpenClaw backend via ngrok URL.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case networkError(Error)
    case invalidResponse
    case decodingError(Error)
}

@MainActor
final class APIService: ObservableObject {
    /// Replace with the ngrok URL provided by the backend team.
    static let baseURLString = "https://metal-bags-study.loca.lt/"

    @Published var dashboard: DashboardResponse?
    @Published var isLoading = false
    @Published var error: Error?

    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 15
        return URLSession(configuration: config)
    }()

    func fetchDashboard(urlString: String? = nil) async {
        let urlString = urlString ?? Self.baseURLString
        guard let url = URL(string: urlString) else {
            error = APIError.invalidURL
            return
        }

        isLoading = true
        error = nil

        do {
            let (data, response) = try await session.data(from: url)
            guard let http = response as? HTTPURLResponse, (200...299).contains(http.statusCode) else {
                error = APIError.invalidResponse
                isLoading = false
                return
            }
            let decoder = JSONDecoder()
            let decoded = try decoder.decode(DashboardResponse.self, from: data)
            dashboard = decoded
        } catch {
            self.error = APIError.decodingError(error)
        }
        isLoading = false
    }

    /// Load mock data for previews and testing without backend.
    func loadMockData() {
        let mock = DashboardResponse(
            userProfile: UserProfile(userId: "student_101", name: "Alex", linkedPlatforms: ["discord", "telegram", "whatsapp"]),
            liveStatus: LiveStatus(
                overallUrgencyScore: 8.5,
                isGaming: true,
                currentActivity: "League of Legends",
                lastActivePlatform: "discord",
                lastPingTimestamp: "2026-03-14T12:05:00Z"
            ),
            classes: [
                Class(classId: "IFT-1010", name: "Programming I", professor: "Dr. Turing", syllabusParsed: true)
            ],
            assignments: [
                Assignment(assignmentId: "task_001", classId: "IFT-1010", title: "Binary Tree Implementation", dueDate: "2026-03-16T23:59:00Z", priorityScore: 9, status: "pending", type: "project"),
                Assignment(assignmentId: "task_002", classId: "IFT-1010", title: "Weekly Quiz 5", dueDate: "2026-03-18T23:59:00Z", priorityScore: 5, status: "pending", type: "quiz")
            ],
            interventionLogs: [
                InterventionLog(logId: "log_089", timestamp: "2026-03-14T12:00:00Z", platform: "discord", trigger: "gaming_detected", messageSent: "Hey Alex! I see you're in the Rift. Your IFT-1010 project is due in 2 days. Urgency is at a 9/10. Log off and study!", userReply: "Logging off now, promise.")
            ],
            knowledgeGaps: [
                KnowledgeGap(gapId: "gap_001", classId: "BIOL-101", topic: "Cellular Respiration", questionAsked: "Where does the Krebs cycle occur?", wrongAnswerGiven: "Nucleus", correctConcept: "The Krebs cycle occurs in the mitochondrial matrix.", studyReference: "Syllabus.pdf - Page 14", youtubeLink: "https://youtube.com/results?search_query=Krebs+cycle+explained", status: "needs_review")
            ]
        )
        dashboard = mock
        error = nil
    }
}
