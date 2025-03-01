import 'package:flutter/material.dart';
import 'widget/product_card.dart';
import 'controller/ProductController.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  final ProductController productController = ProductController();

  void productDialog(
      {String? id,
        String? name,
        int? qty,
        String? img,
        int? unitPrice,
        int? totalPrice}) {
    TextEditingController productNameController = TextEditingController();
    TextEditingController productQtyController = TextEditingController();
    TextEditingController productImageController = TextEditingController();
    TextEditingController productUnitPriceController = TextEditingController();
    TextEditingController productTotalPriceController = TextEditingController();

    productNameController.text = name ?? '';
    productQtyController.text = qty != null ? qty.toString() : '0';
    productImageController.text = img ?? '';
    productUnitPriceController.text = unitPrice != null ? unitPrice.toString() : '0';
    productTotalPriceController.text = totalPrice != null ? totalPrice.toString() : '0';

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(id == null ? 'Add Product' : 'Update Product'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: productNameController,
                decoration: InputDecoration(labelText: 'Product Name'),
              ),
              TextField(
                controller: productImageController,
                decoration: InputDecoration(labelText: 'Product Image'),
              ),
              TextField(
                controller: productQtyController,
                decoration: InputDecoration(labelText: 'Product Qty'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: productUnitPriceController,
                decoration: InputDecoration(labelText: 'Product Unit Price'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: productTotalPriceController,
                decoration: InputDecoration(labelText: 'Total Price'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Close')),
                  ElevatedButton(
                      onPressed: () async {
                        if (id == null) {
                          await productController.createProduct(
                              productNameController.text,
                              productImageController.text,
                              int.parse(productQtyController.text),
                              int.parse(productUnitPriceController.text),
                              int.parse(productTotalPriceController.text));
                        } else {
                          await productController.UpdateProduct(
                              id,
                              productNameController.text,
                              productImageController.text,
                              int.parse(productQtyController.text),
                              int.parse(productUnitPriceController.text),
                              int.parse(productTotalPriceController.text));
                        }

                        // Refresh the UI immediately after adding/updating
                        await fetchData();
                        Navigator.pop(context);
                      },
                      child: Text(id == null ? 'Add Product' : 'Update Product')),
                ],
              )
            ],
          ),
        ));
  }


  Future<void> fetchData() async {
    await productController.fetchProducts();
    print(productController.products.length);
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: Text('Products'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.8,
                ),
                itemCount: productController.products.length,
                itemBuilder: (context, index) {
                  var product = productController.products[index];
                  return ProductCard(
                    product: product,
                    onEdit: () => productDialog(
                      id: product.sId,
                      name: product.productName,
                      img: product.img,
                      qty: product.qty,
                      unitPrice: product.unitPrice,
                      totalPrice: product.totalPrice,
                    ),
                    onDelete: () {
                      productController.deleteProducts(product.sId.toString()).then((value) {
                        if (value) {
                          setState(() {
                            fetchData();
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Product deleted"), duration: Duration(seconds: 2)),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Something went wrong, try again"), duration: Duration(seconds: 2)),
                          );
                        }
                      });
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),






      floatingActionButton: FloatingActionButton(
        onPressed: () => productDialog(),
        child: Icon(Icons.add),
      ),
    );
  }
}