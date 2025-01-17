import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class DriverCard extends StatelessWidget {
  final String driverName;
  final String phoneNumber;
  final String? driverImageUrl;
  final VoidCallback onCallPressed;

  const DriverCard({
    super.key,
    required this.driverName,
    required this.phoneNumber,
    this.driverImageUrl,
    required this.onCallPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            _buildDriverAvatar(),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    driverName,
                    style: const TextStyle(
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    phoneNumber,
                    style: const TextStyle(
                      fontFamily: "Inter",
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    'Tu conductor',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onCallPressed,
                borderRadius: BorderRadius.circular(50),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.indigo.withOpacity(0.1),
                  ),
                  child: const Icon(
                    Icons.phone,
                    color: Colors.indigo,
                    size: 24,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDriverAvatar() {
    // If image URL is provided, use CachedNetworkImage
    if (driverImageUrl != null && driverImageUrl!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: driverImageUrl!,
        imageBuilder: (context, imageProvider) => Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
        placeholder: (context, url) => Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            width: 50,
            height: 50,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
          ),
        ),
        errorWidget: (context, url, error) => _buildDefaultAvatar(),
      );
    }

    // If no image, return default avatar
    return _buildDefaultAvatar();
  }

  Widget _buildDefaultAvatar() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.indigo.shade100,
      ),
      child: Center(
        child: Icon(
          Icons.person,
          color: Colors.indigo.shade600,
          size: 30,
        ),
      ),
    );
  }
}
