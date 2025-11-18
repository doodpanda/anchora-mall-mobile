import 'package:flutter/material.dart';
import 'package:anchora_mall/models/product_entry.dart';

class ProductEntryCard extends StatelessWidget {
  final ProductEntry product;
  final VoidCallback onTap;

  const ProductEntryCard({
    super.key,
    required this.product,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: InkWell(
        onTap: onTap,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            side: BorderSide(color: Colors.grey.shade300),
          ),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Thumbnail
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: product.thumbnail.isNotEmpty
                      ? Image.network(
                          'http://localhost:8000/image-proxy/?url=${Uri.encodeComponent(product.thumbnail)}',
                          height: 150,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            height: 150,
                            color: Colors.grey[300],
                            child: const Center(
                              child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
                            ),
                          ),
                        )
                      : Container(
                          height: 150,
                          width: double.infinity,
                          color: Colors.grey[300],
                          child: const Center(
                            child: Icon(Icons.image, size: 50, color: Colors.grey),
                          ),
                        ),
                ),
                const SizedBox(height: 8),

                // Title
                Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),

                // Price
                Row(
                  children: [
                    Text(
                      '\$${product.price}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: product.discountedPrice != null 
                            ? Colors.grey 
                            : Colors.blue.shade700,
                        decoration: product.discountedPrice != null 
                            ? TextDecoration.lineThrough 
                            : null,
                      ),
                    ),
                    if (product.discountedPrice != null) ...[
                      const SizedBox(width: 8),
                      Text(
                        '\$${product.discountedPrice}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.red.shade700,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 6),

                // Category
                Text('Category: ${product.category}'),
                const SizedBox(height: 6),

                // Description preview
                Text(
                  product.description.length > 100
                      ? '${product.description.substring(0, 100)}...'
                      : product.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 6),

                // Featured indicator
                Row(
                  children: [
                    if (product.isFeatured)
                      const Chip(
                        label: Text(
                          'Featured',
                          style: TextStyle(
                            color: Colors.amber,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        backgroundColor: Colors.amber,
                        padding: EdgeInsets.all(0),
                        labelPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                      ),
                    if (product.isFeatured && product.isOfficialStore)
                      const SizedBox(width: 8),
                    if (product.isOfficialStore)
                      const Chip(
                        label: Text(
                          'Official Store',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        backgroundColor: Colors.green,
                        padding: EdgeInsets.all(0),
                        labelPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
