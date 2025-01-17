//
//  AnimationAppTests.swift
//  AnimationAppTests
//
//  Created by Анна Яцун on 16.01.2025.
//

import XCTest
@testable  import AnimationApp


@MainActor
final class BreedViewModelTests: XCTestCase {
    private var mockBreedService: MockBreedService!
    private var mockNetworkMonitor: MockNetworkMonitor!
    private var viewModel: BreedViewModel!

    override func setUp() {
        super.setUp()
        mockBreedService = MockBreedService()
        mockNetworkMonitor = MockNetworkMonitor()
        viewModel = BreedViewModel(breedService: mockBreedService, networkMonitor: mockNetworkMonitor)
    }

    override func tearDown() {
        mockBreedService = nil
        mockNetworkMonitor = nil
        viewModel = nil
        super.tearDown()
    }

    func testLoadBreedsSuccess() async {
        let mockBreeds = [Breed(id: "1", name: "Persian", description: "Some info about Breed", image: Breed.BreedImage?(nil)), Breed(id: "2", name: "Siamese", description: "Some info about Breed", image: Breed.BreedImage?(nil))]
        mockBreedService.result = .success(mockBreeds)
        mockNetworkMonitor.isConnected = true

        await viewModel.loadMoreBreeds()

        XCTAssertEqual(viewModel.breeds, mockBreeds)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
    }

    func testLoadMoreBreedsFailure() async {
          mockBreedService.result = .failure(NSError(domain: "TestError", code: 1, userInfo: nil))
          await viewModel.loadMoreBreeds()
          XCTAssertTrue(viewModel.breeds.isEmpty)
          XCTAssertEqual(viewModel.errorMessage, "Failed to load breeds: The operation couldn’t be completed. (TestError error 1.)")
          XCTAssertFalse(viewModel.isLoading)
      }

    func testNoInternetConnection() async {
        mockNetworkMonitor.isConnected = false
        await viewModel.loadMoreBreeds()

        XCTAssertTrue(viewModel.breeds.isEmpty)
        XCTAssertFalse(viewModel.isLoading)
    }
}
