//
//  ViewModels.swift
//  AIVoice
//
//  Created by Tommy Ludwig on 11.04.23.
//

import Foundation
// This file was generated from JSON Schema using quicktype, do not modify it directly.

// MARK: - Welcome
struct ViewModel: Codable {
    let voices: [Voice]
}

// MARK: - Voice
struct Voice: Identifiable, Codable {
    var id: UUID
    let voiceID, name: String?
    let samples: [Sample]?
    let category: String?
    let fineTuning: FineTuning?
    let labels: Labels?
    let description, previewURL: String?
    let availableForTiers: [String]?
    let settings: Settings?

    enum CodingKeys: String, CodingKey {
        case id
        case voiceID = "voice_id"
        case name, samples, category
        case fineTuning = "fine_tuning"
        case labels, description
        case previewURL = "preview_url"
        case availableForTiers = "available_for_tiers"
        case settings
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
        self.voiceID = try container.decodeIfPresent(String.self, forKey: .voiceID)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.samples = try container.decodeIfPresent([Sample].self, forKey: .samples)
        self.category = try container.decodeIfPresent(String.self, forKey: .category)
        self.fineTuning = try container.decodeIfPresent(FineTuning.self, forKey: .fineTuning)
        self.labels = try container.decodeIfPresent(Labels.self, forKey: .labels)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.previewURL = try container.decodeIfPresent(String.self, forKey: .previewURL)
        self.availableForTiers = try container.decodeIfPresent([String].self, forKey: .availableForTiers)
        self.settings = try container.decodeIfPresent(Settings.self, forKey: .settings)
    }
}

// MARK: - FineTuning
struct FineTuning: Codable {
    let modelID: String?
    let isAllowedToFineTune, fineTuningRequested: Bool?
    let finetuningState: String?
    let verificationAttempts: [VerificationAttempt]?
    let verificationFailures: [String]?
    let verificationAttemptsCount: Int?
    let sliceIDS: [String]?

    enum CodingKeys: String, CodingKey {
        case modelID = "model_id"
        case isAllowedToFineTune = "is_allowed_to_fine_tune"
        case fineTuningRequested = "fine_tuning_requested"
        case finetuningState = "finetuning_state"
        case verificationAttempts = "verification_attempts"
        case verificationFailures = "verification_failures"
        case verificationAttemptsCount = "verification_attempts_count"
        case sliceIDS = "slice_ids"
    }
}

// MARK: - VerificationAttempt
struct VerificationAttempt: Codable {
    let text: String?
    let dateUnix: Int?
    let accepted: Bool?
    let similarity, levenshteinDistance: Int?
    let recording: Recording?

    enum CodingKeys: String, CodingKey {
        case text
        case dateUnix = "date_unix"
        case accepted, similarity
        case levenshteinDistance = "levenshtein_distance"
        case recording
    }
}

// MARK: - Recording
struct Recording: Codable {
    let recordingID, mimeType: String?
    let sizeBytes, uploadDateUnix: Int?
    let transcription: String?

    enum CodingKeys: String, CodingKey {
        case recordingID = "recording_id"
        case mimeType = "mime_type"
        case sizeBytes = "size_bytes"
        case uploadDateUnix = "upload_date_unix"
        case transcription
    }
}

// MARK: - Labels
struct Labels: Codable {
    let additionalProp1, additionalProp2, additionalProp3: String?
}

// MARK: - Sample
struct Sample: Codable {
    let sampleID, fileName, mimeType: String?
    let sizeBytes: Int?
    let hash: String?

    enum CodingKeys: String, CodingKey {
        case sampleID = "sample_id"
        case fileName = "file_name"
        case mimeType = "mime_type"
        case sizeBytes = "size_bytes"
        case hash
    }
}

// MARK: - Settings
struct Settings: Codable {
    let stability, similarityBoost: Int?

    enum CodingKeys: String, CodingKey {
        case stability
        case similarityBoost = "similarity_boost"
    }
}
