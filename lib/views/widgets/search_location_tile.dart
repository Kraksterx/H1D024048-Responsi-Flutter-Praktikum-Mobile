import 'package:flutter/material.dart';
import 'package:responsi_flutter/models/location_model.dart';

class SearchLocationTile extends StatelessWidget {
  final LocationModel location;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onToggleFavorite;
  final VoidCallback? onDelete;

  const SearchLocationTile({
    Key? key,
    required this.location,
    required this.isFavorite,
    required this.onTap,
    required this.onToggleFavorite,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF1E88E5).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.location_on_rounded,
            color: Color(0xFF1E88E5),
            size: 22,
          ),
        ),
        title: Text(
          location.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: Color(0xFF1C274C),
          ),
        ),
        subtitle: Text(
          location.locationSubtitle,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.redAccent : Colors.grey.shade400,
                size: 22,
              ),
              onPressed: onToggleFavorite,
              tooltip: isFavorite ? 'Hapus favorit' : 'Simpan favorit',
            ),
            if (onDelete != null)
              IconButton(
                icon: Icon(
                  Icons.close_rounded,
                  color: Colors.grey.shade400,
                  size: 20,
                ),
                onPressed: onDelete,
                tooltip: 'Hapus riwayat',
              ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
