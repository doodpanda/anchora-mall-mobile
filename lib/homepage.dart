import 'package:flutter/material.dart';
import 'package:anchora_mall/widgets/left_drawer.dart';
import 'package:anchora_mall/screens/product_form.dart';
import 'package:anchora_mall/screens/product_entry_list.dart';
import 'package:anchora_mall/screens/login.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class AnchoraMallHome extends StatefulWidget {
  const AnchoraMallHome({super.key});

  @override
  State<AnchoraMallHome> createState() => _AnchoraMallHomeState();
}

class _AnchoraMallHomeState extends State<AnchoraMallHome> {
  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        duration: const Duration(milliseconds: 1500),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const LeftDrawer(),
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Anchora Mall',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.white,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade700, Colors.blue.shade500],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Hero Icon removed to eliminate glow effect
                const SizedBox(height: 20),

                // Welcome Text
                const Text(
                  'Welcome to Anchora Mall',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'Explore, manage, and create amazing products',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 60),

                // All Products Button
                _buildProductButton(
                  label: 'All Products',
                  icon: Icons.shopping_bag_outlined,
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade400, Colors.blue.shade600],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProductEntryListPage(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),

                // My Products Button
                _buildProductButton(
                  label: 'My Products',
                  icon: Icons.favorite_outline,
                  gradient: LinearGradient(
                    colors: [Colors.green.shade400, Colors.green.shade600],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProductEntryListPage(showMyProducts: true),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),

                // Create Product Button
                _buildProductButton(
                  label: 'Tambah Produk',
                  icon: Icons.add_circle_outline,
                  gradient: LinearGradient(
                    colors: [Colors.red.shade400, Colors.red.shade600],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProductFormPage(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),

                // Logout Button
                _buildProductButton(
                  label: 'Logout',
                  icon: Icons.logout,
                  gradient: LinearGradient(
                    colors: [Colors.grey.shade400, Colors.grey.shade600],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  onPressed: () async {
                    final request = context.read<CookieRequest>();
                    // TODO: Replace the URL with your app's URL and don't forget to add a trailing slash (/)!
                    // To connect Android emulator with Django on localhost, use URL http://10.0.2.2/
                    // If you using chrome,  use URL http://localhost:8000
                    
                    final response = await request.logout(
                        "http://localhost:8000/auth/logout/");
                    String message = response["message"];
                    if (context.mounted) {
                        if (response['status']) {
                            String uname = response["username"];
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text("$message See you again, $uname."),
                            ));
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => const LoginPage()),
                            );
                        } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(message),
                                ),
                            );
                        }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductButton({
    required String label,
    required IconData icon,
    required LinearGradient gradient,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 28,
                  color: Colors.white,
                ),
                const SizedBox(width: 16),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
