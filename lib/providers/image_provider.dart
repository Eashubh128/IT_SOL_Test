import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:itsoltest/constants/api_constants.dart';
import 'package:itsoltest/constants/string_constants.dart';

// Objectives
// 1 . onClick => open the screen in full screen
// 2 . onBackClick => close the screen

/// Provider class for managing the state of the image gallery
class GalleryImageProvider extends ChangeNotifier {
  // List to store loaded images
  List<dynamic> _images = [];
  // Current page number for API pagination
  int _page = 1;
  // Flag to indicate if images are currently being loaded
  bool _isLoading = false;
  // Flag to indicate if there are more images to load
  bool _hasMore = true;

  // Getters for private variables
  List<dynamic> get images => _images;
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;

  /// Loads more images from the API
  Future<void> loadMoreImages() async {
    // Prevent multiple simultaneous loads or loading when there are no more images
    if (_isLoading || !_hasMore) return;

    // Set loading state and notify listeners
    _isLoading = true;
    notifyListeners();

    try {
      // Fetch images from API
      final response =
          await http.get(Uri.parse(ApiConstants.getImageUrl(page: _page)));

      if (response.statusCode == 200) {
        // Parse response data
        final data = json.decode(response.body);
        final newImages = data['hits'];

        if (newImages.isEmpty) {
          // No more images to load
          _hasMore = false;
        } else {
          // Add new images to the list and increment page number
          _images.addAll(newImages);
          _page++;
        }
      } else {
        // Handle API error
        throw Exception(StringConstants.failedToLoadImages);
      }
    } catch (e) {
      // Log error
      print('${StringConstants.errorLoadingImages} $e');
    } finally {
      // Reset loading state and notify listeners
      _isLoading = false;
      notifyListeners();
    }
  }
}
