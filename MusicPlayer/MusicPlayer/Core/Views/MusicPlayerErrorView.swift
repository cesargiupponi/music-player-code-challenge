//
//  MusicPlayerErrorView.swift
//  MusicPlayer
//
//  Created by Cesar Giupponi on 18/06/25.
//

import SwiftUI

struct MusicPlayerErrorView: View {
    let error: Error
    let retryAction: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {

            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 48))
                .foregroundStyle(Color.orange)
            
            Text("Oops! Something went wrong")
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(Color.white)
                .multilineTextAlignment(.center)
            
            Text(errorMessage)
                .font(.system(size: 16))
                .foregroundStyle(Color.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            
            Button(action: retryAction) {
                HStack(spacing: 8) {
                    Image(systemName: "arrow.clockwise")
                        .font(.system(size: 16, weight: .medium))
                    Text("Try Again")
                        .font(.system(size: 16, weight: .medium))
                }
                .foregroundStyle(Color.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(Color.orange)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
        .padding(32)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
    }
    
    private var errorMessage: String {
        if let urlError = error as? URLError {
            switch urlError.code {
            case .notConnectedToInternet, .networkConnectionLost:
                return "Please check your internet connection and try again."
            case .timedOut:
                return "The request timed out. Please try again."
            case .badServerResponse:
                return "The server is not responding. Please try again later."
            default:
                return "Unable to load songs. Please try again."
            }
        }
        
        return "Something unexpected happened. Please try again."
    }
}

#Preview {
    MusicPlayerErrorView(
        error: URLError(.notConnectedToInternet),
        retryAction: {}
    )
} 
