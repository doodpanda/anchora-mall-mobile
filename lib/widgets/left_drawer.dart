import 'package:flutter/material.dart';
import 'package:anchora_mall/homepage.dart';
import 'package:anchora_mall/screens/product_form.dart';
import 'package:anchora_mall/screens/product_entry_list.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade700, Colors.blue.shade500],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.store,
                  size: 60,
                  color: Colors.white,
                ),
                SizedBox(height: 12),
                Text(
                  'Anchora Mall',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Your Shopping Destination',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home, color: Colors.blue),
            title: const Text(
              'Halaman Utama',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const AnchoraMallHome(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.add_circle, color: Colors.red),
            title: const Text(
              'Tambah Produk',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProductFormPage(),
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.shopping_bag, color: Colors.green),
            title: const Text(
              'All Products',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            onTap: () {
              // Navigate to product list page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProductEntryListPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.favorite, color: Colors.green),
            title: const Text(
              'My Products',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            onTap: () {
              // Navigate to product list page (filtered by user)
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProductEntryListPage(showMyProducts: true)),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings, color: Colors.grey),
            title: const Text(
              'Settings',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Settings coming soon...'),
                  duration: Duration(milliseconds: 1000),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.info, color: Colors.grey),
            title: const Text(
              'About',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            onTap: () {
              Navigator.pop(context);
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('About Anchora Mall'),
                  content: const Text(
                    'Anchora Mall v1.0\n\nA modern shopping app built with Flutter.\n\nDeveloped for educational purposes.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}