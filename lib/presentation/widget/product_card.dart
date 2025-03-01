import 'package:flutter/material.dart';
import '../../data/models/product.dart';
import '../screens/product_view.dart';

class ProductCard extends StatelessWidget {
  final Data product;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ProductCard({super.key, required this.product, required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to ProductView when clicking on the image
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductView(product: product),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Center(
              child: Container(
                height: 140,
                color: Colors.grey.shade200,
                child: Image.network(
                  product.img.toString(),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Icon(Icons.image_not_supported, size: 100, color: Colors.grey),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name
                  Text(
                    product.productName.toString(),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  // Product Price
                  Text(
                    'Price: \$${product.unitPrice} | Qty: ${product.qty}',
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(onPressed: onEdit, icon: Icon(Icons.edit)),
                        IconButton(onPressed: onDelete, icon: Icon(Icons.delete, color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
