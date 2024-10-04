import 'package:flutter/material.dart';
import 'package:itsoltest/constants/dimension_constants.dart';
import 'package:itsoltest/constants/string_constants.dart';
import 'package:itsoltest/pages/image_full_screen.dart';
import 'package:itsoltest/providers/image_provider.dart';
import 'package:provider/provider.dart';

/// A stateful widget that displays a gallery of images loaded from an API
class ImageGallery extends StatefulWidget {
  const ImageGallery({Key? key}) : super(key: key);

  @override
  _ImageGalleryState createState() => _ImageGalleryState();
}

class _ImageGalleryState extends State<ImageGallery> {
  // Controller for handling scroll events
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Add scroll listener to detect when to load more images
    _scrollController.addListener(_scrollListener);
    // Initial load of images after the widget is inserted into the tree
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<GalleryImageProvider>(context, listen: false)
          .loadMoreImages();
    });
  }

  @override
  void dispose() {
    // Clean up the scroll controller when the widget is disposed
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  /// Listener for scroll events to trigger loading more images
  void _scrollListener() {
    print("Offset pixels are : " +
        _scrollController.position.pixels.toString() +
        "  maxScrollExtent is  : " +
        _scrollController.position.maxScrollExtent.toString());
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 500) {
      // Load more images when user is near the end of the list
      Provider.of<GalleryImageProvider>(context, listen: false)
          .loadMoreImages();
    }
  }

  @override
  Widget build(BuildContext context) {
    int columnCount = _getColumnCount(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(StringConstants.appTitle),
      ),
      body: Consumer<GalleryImageProvider>(
        builder: (context, imageProvider, child) {
          return GridView.builder(
            controller: _scrollController,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columnCount,
              childAspectRatio: 1,
              crossAxisSpacing: DimensionConstants.gridSpacing,
              mainAxisSpacing: DimensionConstants.gridSpacing,
            ),
            itemCount: imageProvider.images.length + 1,
            itemBuilder: (context, index) {
              if (index < imageProvider.images.length) {
                return _buildImageItem(imageProvider.images[index]);
              } else if (imageProvider.hasMore) {
                return _buildLoader();
              } else {
                return _buildEndOfListIndicator();
              }
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Provider.of<GalleryImageProvider>(context, listen: false)
              .loadMoreImages();
        },
        child: const Icon(
          Icons.refresh,
        ),
      ),
    );
  }

  int _getColumnCount(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 1200) {
      return 5; // Extra large screens
    } else if (screenWidth > 900) {
      return 4; // Large screens
    } else if (screenWidth > 600) {
      return 3; // Medium screens
    } else {
      return 2; // Small screens (mobile)
    }
  }

  /// Builds a card widget to display an individual image with its details
  Widget _buildImageItem(dynamic image) {
    return InkWell(
      onTap: () {
        // Expanding the image or move to next page
        // 1. Simply move to a new screen and use the Appbar Nav to navigate back || or can create a dialog with a column with a back button and a child

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ImageFullScreen(
              networkImageUrl: image[StringConstants.WEBFORMAT_URL],
            ),
          ),
        );
      },
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Image.network(
                image[StringConstants.WEBFORMAT_URL],
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(DimensionConstants.cardPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      '${StringConstants.likes} ${image[StringConstants.LIKES_KEY]}'),
                  Text(
                      '${StringConstants.views} ${image[StringConstants.VIEWS_KEY]}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a loading indicator widget
  Widget _buildLoader() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(DimensionConstants.cardPadding),
        child: CircularProgressIndicator(),
      ),
    );
  }

  /// Builds a widget to indicate the end of the image list
  Widget _buildEndOfListIndicator() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(DimensionConstants.endOfListPadding),
        child: Text(StringConstants.noMoreImages),
      ),
    );
  }
}
