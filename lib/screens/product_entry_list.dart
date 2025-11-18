import 'package:flutter/material.dart';
import 'package:anchora_mall/models/product_entry.dart';
import 'package:anchora_mall/widgets/left_drawer.dart';
import 'package:anchora_mall/widgets/product_entry_card.dart';
import 'package:anchora_mall/screens/product_detail.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class ProductEntryListPage extends StatefulWidget {
  final bool showMyProducts;
  
  const ProductEntryListPage({super.key, this.showMyProducts = false});

  @override
  State<ProductEntryListPage> createState() => _ProductEntryListPageState();
}

class _ProductEntryListPageState extends State<ProductEntryListPage> {
  Future<List<ProductEntry>> fetchProducts(CookieRequest request) async {
    // TODO: Replace the URL with your app's URL and don't forget to add a trailing slash (/)!
    // To connect Android emulator with Django on localhost, use URL http://10.0.2.2/
    // If you using chrome,  use URL http://localhost:8000
    
    final url = widget.showMyProducts 
        ? 'http://localhost:8000/api/products/?source=my_products'
        : 'http://localhost:8000/api/products/';
    
    final response = await request.get(url);
    
    // Decode response to json format
    var data = response;
    
    // Convert json data to ProductEntry objects
    List<ProductEntry> listProducts = [];
    for (var d in data) {
      if (d != null) {
        listProducts.add(ProductEntry.fromJson(d));
      }
    }
    return listProducts;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.showMyProducts ? 'My Products' : 'All Products',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade700, Colors.blue.shade500],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: const LeftDrawer(),
      body: FutureBuilder(
        future: fetchProducts(request),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (!snapshot.hasData || snapshot.data!.length == 0) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.showMyProducts 
                        ? 'You have no products yet.'
                        : 'There are no products in Anchora Mall yet.',
                    style: const TextStyle(fontSize: 20, color: Color(0xff59A5D8)),
                  ),
                  const SizedBox(height: 8),
                ],
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (_, index) => ProductEntryCard(
                  product: snapshot.data![index],
                  onTap: () {
                    // Navigate to product detail page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailPage(
                          product: snapshot.data![index],
                        ),
                      ),
                    );
                  },
                ),
              );
            }
          }
        },
      ),
    );
  }
}
