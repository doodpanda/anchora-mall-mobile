# Anchora Mall – Flutter App

Aplikasi Flutter sederhana bertema toko (Anchora Mall) dengan desain modern dan bersih. Halaman utama menampilkan tiga tombol aksi dengan ikon dan warna berbeda:

- All Products (biru)
- My Products (hijau)
- Create Product (merah)

Saat masing-masing tombol ditekan, aplikasi menampilkan Snackbar berbahasa Indonesia sesuai ketentuan tugas.

File utama:

- `lib/main.dart` – Entry point aplikasi (hanya menginisialisasi MaterialApp dan memuat halaman beranda).
- `lib/homepage.dart` – Implementasi UI/UX halaman beranda (tombol, layout, snackbar).

---

## 1) Apa itu Widget Tree di Flutter? Bagaimana hubungan Parent–Child bekerja?

Di Flutter, hampir semua hal adalah widget. Widget disusun secara hierarkis membentuk sebuah “widget tree” (pohon widget). Setiap node di pohon adalah widget, dan widget dapat memiliki satu atau banyak anak (children).

- Parent (induk) bertanggung jawab memberikan konteks, constraint (batas ukuran), dan data/tema ke child (anak).
- Child membangun tampilan berdasarkan constraint dari parent dan melaporkan kembali ukuran akhirnya ke parent.
- Data dan tema mengalir ke bawah (inherited widgets), sementara event/tindakan (seperti callback) biasanya mengalir ke atas melalui fungsi yang dipanggil oleh child.

Secara sederhana: parent menentukan “aturan main” (ukuran, posisi, tema), child menggambar sesuai aturan tersebut.

---

## 2) Widget yang digunakan di proyek ini dan fungsinya

Pada `lib/main.dart` dan `lib/homepage.dart` saya menggunakan widget berikut:

- `MaterialApp`: Pembungkus root aplikasi Material Design; menyediakan tema, routing/navigasi, dan integrasi material lainnya.
- `Scaffold`: Kerangka halaman standar (menyediakan `AppBar`, `body`, `SnackBar`, dll.).
- `AppBar`: Bilah judul di bagian atas layar.
- `Container`: Kotak serbaguna untuk dekorasi (warna, gradient), ukuran, dan padding/margin.
- `Center`: Menempatkan child tepat di tengah parent-nya.
- `SingleChildScrollView`: Membuat konten dapat discroll jika melebihi tinggi layar.
- `Column`: Menyusun widget secara vertikal.
- `Row`: Menyusun widget secara horizontal (digunakan di dalam tombol kustom).
- `Padding`: Memberi jarak dalam di sekitar child.
- `SizedBox`: Memberi ruang kosong dengan tinggi/lebar tertentu (spacer).
- `Text`: Menampilkan teks statis/dinamis.
- `Icon`: Menampilkan ikon material.
- `Material`: Menyediakan “material ink” untuk efek ripple.
- `InkWell`: Area yang dapat ditekan dengan efek ripple.
- `SnackBar`: Komponen feedback ringan yang muncul sementara di bagian bawah layar.

Catatan: Saya juga menggunakan beberapa kelas non-widget untuk styling seperti `BoxDecoration`, `LinearGradient`, `EdgeInsets`, `Alignment`, dan `Colors`.

---

## 3) Fungsi `MaterialApp` dan mengapa sering menjadi root

`MaterialApp` adalah widget tingkat atas yang:

- Menyediakan design system (warna, typography) via `ThemeData`.
- Mengatur routing/navigasi (routes, onGenerateRoute, navigatorKey).
- Mengatur localizations, title, debug banner, dan konfigurasi global lain.

Karena banyak fitur dasar aplikasi Material diikat pada `MaterialApp`, widget ini hampir selalu dipakai sebagai root agar seluruh subtree mendapatkan tema dan layanan navigasi secara konsisten.

---

## 4) Perbedaan `StatelessWidget` vs `StatefulWidget` – kapan memilihnya?

- `StatelessWidget`:
	- Tidak menyimpan state internal yang berubah-ubah.
	- Build-nya murni berdasarkan input (props) dan context.
	- Untuk UI statis atau depend pada data eksternal yang tidak dikelola di widget tersebut.

- `StatefulWidget`:
	- Memiliki objek `State` untuk menyimpan state yang bisa berubah (misal: counter, form value, loading state).
	- Memanggil `setState()` untuk memicu rebuild.
	- Untuk UI perlu bereaksi terhadap interaksi pengguna atau perubahan data lokal.

Di proyek ini, `AnchoraMallHome` adalah `StatefulWidget` karena kita menampilkan `SnackBar` berdasarkan interaksi pengguna (menekan tombol), dan berpotensi menambah fitur dinamis lain ke depan.

---

## 5) Apa itu `BuildContext` dan mengapa penting? Bagaimana dipakai di `build()`?

`BuildContext` merepresentasikan lokasi sebuah widget di dalam widget tree. Ia penting karena:

- Memberi akses ke inherited widgets (mis. `Theme.of(context)`, `MediaQuery.of(context)`).
- Menentukan navigator/snackbar yang relevan (mis. `ScaffoldMessenger.of(context)`).
- Menjadi parameter pada metode `build(BuildContext context)` untuk membangun UI sesuai environment saat ini.

Contoh penggunaan di project ini:

```dart
ScaffoldMessenger.of(context).showSnackBar(
	SnackBar(content: Text('Kamu telah menekan tombol All Products')),
);
```

---

## 6) Konsep “Hot Reload” vs “Hot Restart”

- **Hot Reload**: Menyuntikkan perubahan kode ke VM Dart dan melakukan rebuild widget tree. State yang ada (variabel di `State`) dipertahankan.
- **Hot Restart**: Mengulang aplikasi dari awal (menjalankan ulang `main()`), state direset. Berguna saat perubahan tidak terdeteksi oleh hot reload atau ingin menguji dari kondisi awal.

---

## 7) Menambahkan navigasi antar layar di Flutter

Ada beberapa cara, dua yang paling umum:

1) Menggunakan `Navigator.push` dengan `MaterialPageRoute`:

```dart
onPressed: () {
	Navigator.of(context).push(
		MaterialPageRoute(
			builder: (context) => const AllProductsPage(),
		),
	);
}

class AllProductsPage extends StatelessWidget {
	const AllProductsPage({super.key});
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(title: const Text('All Products')),
			body: const Center(child: Text('Daftar semua produk')), 
		);
	}
}
```

2) Menggunakan named routes di `MaterialApp`:

```dart
MaterialApp(
	routes: {
		'/': (context) => const AnchoraMallHome(),
		'/all-products': (context) => const AllProductsPage(),
	},
);

// Navigasi
Navigator.pushNamed(context, '/all-products');
```

Di proyek ini tombol masih menampilkan `SnackBar`. Untuk menambah navigasi, dapat mengganti callback `onPressed` tombol agar memanggil `Navigator` seperti contoh di atas.

---

## Tugas 8: Implementasi Navigation, Layout, Form, dan Input Elements

### 1. Perbedaan antara Navigator.push() dan Navigator.pushReplacement()

**Navigator.push():**
- Menambahkan halaman baru ke atas stack navigation
- Halaman sebelumnya tetap tersimpan di memori dan dapat diakses kembali
- Menampilkan tombol back otomatis di AppBar
- Cocok untuk navigasi yang memungkinkan pengguna kembali ke halaman sebelumnya

**Navigator.pushReplacement():**
- Mengganti halaman saat ini dengan halaman baru
- Halaman sebelumnya dihapus dari stack navigation
- Tidak menampilkan tombol back
- Cocok untuk navigasi satu arah seperti dari login ke homepage atau antar menu utama

**Penggunaan dalam aplikasi Anchora Mall:**
- `Navigator.push()` digunakan saat navigasi dari homepage ke form tambah produk, karena user mungkin ingin kembali ke homepage
- `Navigator.pushReplacement()` digunakan di drawer untuk navigasi antar menu utama, agar tidak menumpuk halaman di stack

### 2. Pemanfaatan Hierarchy Widget untuk Struktur Halaman Konsisten

**Scaffold:**
- Menyediakan kerangka dasar halaman dengan AppBar, body, drawer, dan floating action button
- Memastikan konsistensi layout di seluruh aplikasi
- Mengelola SnackBar dan dialog secara otomatis

**AppBar:**
- Header konsisten dengan title, gradient background, dan navigasi
- Ikon hamburger otomatis muncul ketika drawer tersedia
- Warna dan styling yang konsisten menggunakan tema aplikasi

**Drawer:**
- Menu navigasi samping yang konsisten di seluruh aplikasi
- Menyediakan akses mudah ke semua halaman utama
- Header dengan branding aplikasi yang konsisten

Contoh implementasi:
```dart
Scaffold(
  drawer: const LeftDrawer(), // Consistent navigation
  appBar: AppBar(
    // Consistent header styling
    flexibleSpace: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade700, Colors.blue.shade500],
        ),
      ),
    ),
  ),
  body: // Page content
)
```

### 3. Kelebihan Layout Widget untuk Form Elements

**Padding:**
- Memberikan ruang yang konsisten di sekitar elemen form
- Memastikan form tidak menempel ke tepi layar
- Meningkatkan readability dan user experience

**SingleChildScrollView:**
- Memungkinkan form di-scroll ketika konten melebihi tinggi layar
- Mencegah overflow error pada device dengan layar kecil
- Mempertahankan akses ke semua elemen form

**ListView (dalam Drawer):**
- Mengorganisir menu items secara vertikal
- Automatic scrolling jika menu items terlalu banyak
- Consistent spacing antar items

Contoh penggunaan dalam aplikasi:
```dart
SingleChildScrollView(
  padding: const EdgeInsets.all(16.0),
  child: Column(
    children: [
      // Form fields dengan padding konsisten
      _buildTextFormField(...),
      const SizedBox(height: 20), // Consistent spacing
      _buildTextFormField(...),
    ],
  ),
)
```

### 4. Penyesuaian Warna Tema untuk Identitas Visual

**Primary Color Scheme:**
- Menggunakan gradient biru sebagai warna utama (Colors.blue.shade700 ke Colors.blue.shade500)
- Konsisten di AppBar, drawer header, dan tombol utama

**Secondary Colors:**
- Hijau untuk menu "My Products" dan "All Products"
- Merah untuk tombol "Tambah Produk"
- Abu-abu untuk menu sekunder seperti Settings dan About

**Material 3 Design:**
- Menggunakan `useMaterial3: true` untuk adopsi design system terbaru
- `ColorScheme.fromSeed(seedColor: Colors.blue)` untuk harmoni warna otomatis

**Konsistensi Visual:**
- Semua container menggunakan `BorderRadius.circular(16)` untuk rounded corners
- BoxShadow dengan opacity rendah untuk depth yang subtle
- White background dengan blue accent untuk clean look

```dart
theme: ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
),
```

Implementasi ini memastikan aplikasi Anchora Mall memiliki identitas visual yang kuat dan konsisten di seluruh app.

---

## Tugas 9: Integrasi Layanan Web Django dengan Aplikasi Flutter

### 1. Pentingnya Model Dart dalam Pengambilan/Pengiriman Data JSON

**Mengapa perlu membuat model Dart?**

Model Dart memberikan struktur yang jelas dan type-safe untuk data yang diterima atau dikirim dalam format JSON. Beberapa alasan:

**Type Safety:**
- Model Dart memastikan setiap field memiliki tipe data yang benar (String, int, bool, dll.)
- Compiler dapat mendeteksi kesalahan tipe saat development, bukan saat runtime
- Mencegah bug seperti mengakses field yang tidak ada atau salah tipe

**Null Safety:**
- Dart menggunakan sound null safety, memaksa developer mendeklarasikan field yang bisa null dengan `?`
- Model memastikan field yang wajib diisi tidak null, mencegah null pointer exceptions
- Contoh: `String? discountedPrice` vs `String price` - jelas mana yang boleh null

**Maintainability:**
- Perubahan struktur data terdeteksi di compile-time, bukan saat app crash
- IDE dapat memberikan auto-complete dan refactoring support
- Dokumentasi implisit - developer tahu struktur data tanpa melihat API docs

**Konsekuensi jika langsung memetakan Map<String, dynamic>:**

```dart
// Tanpa model - rawan error
final product = jsonData as Map<String, dynamic>;
final price = product['price']; // Tipe apa? String? int? bisa null?
final name = product['nama']; // Typo! seharusnya 'name' - error runtime

// Dengan model - aman
final product = ProductEntry.fromJson(jsonData);
final price = product.price; // Jelas String, tidak null
final name = product.name; // Auto-complete, typo terdeteksi compile-time
```

Tanpa model:
- Tidak ada validasi tipe, semua data adalah `dynamic`
- Typo pada key tidak terdeteksi hingga runtime
- Null safety tidak terjamin, bisa crash
- Sulit di-maintain saat struktur data berubah
- Tidak ada code completion dari IDE

### 2. Fungsi Package http dan CookieRequest

**Package http:**
- Library standar Dart untuk HTTP requests (GET, POST, PUT, DELETE)
- Stateless - setiap request independen, tidak menyimpan session
- Cocok untuk API call sederhana yang tidak memerlukan autentikasi session

```dart
// http - stateless request
import 'package:http/http.dart' as http;

final response = await http.get(
  Uri.parse('http://localhost:8000/api/products/')
);
final data = jsonDecode(response.body);
```

**CookieRequest (dari pbp_django_auth):**
- Wrapper khusus untuk integrasi dengan Django authentication
- Stateful - menyimpan cookies dan session setelah login
- Otomatis mengirim cookies pada setiap request
- Menyediakan method khusus untuk Django (login, logout, postJson)

```dart
// CookieRequest - stateful dengan session
final request = context.watch<CookieRequest>();

// Login - menyimpan session cookie
await request.login('http://localhost:8000/auth/login/', {
  'username': username,
  'password': password,
});

// Request berikutnya otomatis membawa session cookie
final products = await request.get('http://localhost:8000/json/');
```

**Perbedaan Peran:**

| Aspek | http | CookieRequest |
|-------|------|---------------|
| Session Management | Tidak ada | ✅ Otomatis handle cookies |
| Authentication | Manual header | ✅ Built-in Django auth |
| Use Case | Public API, REST | Django session-based auth |
| State | Stateless | Stateful |

Dalam aplikasi Anchora Mall, CookieRequest digunakan karena menggunakan Django session authentication - setelah login, semua request otomatis authenticated tanpa perlu manual menambahkan token/header.

### 3. Mengapa Instance CookieRequest Perlu Dibagikan ke Semua Komponen

**Alasan Teknis:**

**1. Konsistensi Session:**
- User login hanya sekali, session harus tersedia di seluruh aplikasi
- Jika setiap widget membuat CookieRequest baru, session tidak terbagi
- Semua request harus menggunakan cookies yang sama untuk authenticated requests

**2. Shared State:**
- Authentication state (logged in/out) perlu diakses dari berbagai halaman
- Menggunakan Provider pattern untuk state management
- Semua widget mendapatkan instance yang sama dari context

**Implementasi di Anchora Mall:**

```dart
// main.dart - Membungkus app dengan Provider
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) {
        CookieRequest request = CookieRequest();
        return request;
      },
      child: MaterialApp(...),
    );
  }
}

// Di halaman manapun - akses instance yang sama
class ProductListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    // request ini sama dengan yang digunakan di login, homepage, dll.
  }
}
```

**Konsekuensi jika tidak dibagikan:**
- User harus login ulang di setiap halaman
- Data tidak konsisten antar halaman
- Session cookies hilang saat pindah halaman
- Tidak efisien - multiple connections ke server

### 4. Konfigurasi Konektivitas Flutter dengan Django

**A. Menambahkan 10.0.2.2 ke ALLOWED_HOSTS**

```python
# Django settings.py
ALLOWED_HOSTS = ["localhost", "127.0.0.1", "10.0.2.2"]
```

**Mengapa?**
- `10.0.2.2` adalah IP address khusus untuk mengakses localhost dari Android Emulator
- Android Emulator berjalan dalam VM terpisah, tidak bisa menggunakan `localhost`
- `10.0.2.2` di-route ke host machine's localhost

**Jika tidak dikonfigurasi:**
- Android Emulator tidak bisa connect ke Django server
- Error: "Connection refused" atau "Bad Request (400)"

**B. Mengaktifkan CORS (Cross-Origin Resource Sharing)**

```python
# Django settings.py
INSTALLED_APPS = [
    'corsheaders',
    ...
]

MIDDLEWARE = [
    'corsheaders.middleware.CorsMiddleware',
    ...
]

CORS_ALLOW_ALL_ORIGINS = True
CORS_ALLOW_CREDENTIALS = True
```

**Mengapa?**
- Flutter web (Chrome) dan Django server berjalan di origin berbeda
- Browser memblokir request cross-origin untuk keamanan
- CORS headers memberi izin explicit untuk cross-origin requests

**Jika tidak dikonfigurasi:**
- Flutter web error: "CORS policy: No 'Access-Control-Allow-Origin' header"
- Request diblokir oleh browser

**C. Pengaturan SameSite/Cookie**

```python
# Django settings.py
SESSION_COOKIE_SAMESITE = 'None'
SESSION_COOKIE_SECURE = True
CSRF_COOKIE_SAMESITE = 'None'
CSRF_COOKIE_SECURE = True
```

**Mengapa?**
- Modern browsers memblokir cookies cross-site secara default
- `SameSite='None'` mengizinkan cookies dikirim cross-origin
- `Secure=True` required jika `SameSite='None'` (harus HTTPS di production)

**Jika tidak dikonfigurasi:**
- Cookies tidak tersimpan/terkirim
- User tidak bisa stay logged in
- Session tidak persistent antar requests

**D. Izin Akses Internet di Android**

```xml
<!-- android/app/src/main/AndroidManifest.xml -->
<manifest ...>
    <uses-permission android:name="android.permission.INTERNET" />
    ...
</manifest>
```

**Mengapa?**
- Android memerlukan explicit permission untuk network access
- Keamanan - prevent unauthorized network access

**Jika tidak dikonfigurasi:**
- App tidak bisa melakukan network requests sama sekali
- Error: "SocketException: OS Error: Permission denied"

**Summary Konsekuensi:**

| Konfigurasi | Jika Tidak Dikonfigurasi |
|-------------|--------------------------|
| 10.0.2.2 in ALLOWED_HOSTS | Android emulator tidak bisa connect |
| CORS | Flutter web diblokir browser |
| SameSite/Cookie | Session tidak persist, logout otomatis |
| Internet Permission | Android app tidak bisa network request |

### 5. Mekanisme Pengiriman Data dari Input hingga Ditampilkan

**Flow Lengkap:**

**1. Input Data di Flutter (Product Form)**

```dart
// user mengisi form
final _nameController = TextEditingController();
final _priceController = TextEditingController();
final _descriptionController = TextEditingController();

// user menekan tombol submit
ElevatedButton(
  onPressed: () async {
    if (_formKey.currentState!.validate()) {
      // Data dikumpulkan dari controllers
      String name = _nameController.text;
      String price = _priceController.text;
      String description = _descriptionController.text;
      
      // ... (lanjut ke step 2)
    }
  }
)
```

**2. Encoding dan Pengiriman ke Django**

```dart
// Data di-encode ke JSON
final response = await request.postJson(
  "http://localhost:8000/create-flutter/",
  jsonEncode({
    "name": name,
    "price": price,
    "description": description,
    "category": category,
    "thumbnail": thumbnail,
    "is_featured": isFeatured,
  })
);
```

**3. Penerimaan di Django Backend**

```python
# main/views.py
@csrf_exempt
@require_POST
def create_product_flutter(request):
    # Parse JSON body
    data = json.loads(request.body)
    
    # Validasi dan create object
    new_product = Product.objects.create(
        user=request.user,
        name=data["name"],
        price=data["price"],
        description=data["description"],
        category=data["category"],
        thumbnail=data["thumbnail"],
        is_featured=data.get("is_featured", False),
    )
    
    new_product.save()
    
    # Return response
    return JsonResponse({"status": "success"}, status=200)
```

**4. Response Handling di Flutter**

```dart
if (response['status'] == 'success') {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text("Product created successfully!"))
  );
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => const AnchoraMallHome()),
  );
}
```

**5. Menampilkan Data (Fetch dari Django)**

```dart
// Fetch products dari Django
Future<List<ProductEntry>> fetchProducts(CookieRequest request) async {
  final response = await request.get('http://localhost:8000/api/products/');
  
  // Parse JSON response
  List<ProductEntry> listProducts = [];
  for (var d in response) {
    if (d != null) {
      listProducts.add(ProductEntry.fromJson(d));
    }
  }
  return listProducts;
}
```

**6. Render di UI dengan FutureBuilder**

```dart
FutureBuilder(
  future: fetchProducts(request),
  builder: (context, AsyncSnapshot snapshot) {
    if (snapshot.data == null) {
      return const CircularProgressIndicator();
    } else {
      return ListView.builder(
        itemCount: snapshot.data!.length,
        itemBuilder: (_, index) => ProductEntryCard(
          product: snapshot.data![index],
        ),
      );
    }
  },
)
```

**Diagram Flow:**
```
[Flutter Form] 
    ↓ (User Input)
[TextController.text] 
    ↓ (jsonEncode)
[HTTP POST Request] 
    ↓ (Network)
[Django View] 
    ↓ (JSON Parse)
[Database Save] 
    ↓ (JsonResponse)
[Flutter Response Handler] 
    ↓ (Navigate)
[Product List Page] 
    ↓ (GET Request)
[Django Serializer] 
    ↓ (JSON Response)
[ProductEntry.fromJson()] 
    ↓ (Parse)
[FutureBuilder] 
    ↓ (Render)
[UI Display]
```

### 6. Mekanisme Autentikasi: Login, Register, hingga Logout

**A. REGISTER FLOW**

**1. Input di Flutter (register.dart)**

```dart
// User mengisi username, password1, password2
ElevatedButton(
  onPressed: () async {
    String username = _usernameController.text;
    String password1 = _passwordController.text;
    String password2 = _confirmPasswordController.text;
    
    // Kirim ke Django
    final response = await request.postJson(
      "http://localhost:8000/auth/register/",
      jsonEncode({
        "username": username,
        "password1": password1,
        "password2": password2,
      })
    );
    // ... (lanjut step 2)
  }
)
```

**2. Proses di Django (authentication/views.py)**

```python
@csrf_exempt
def register(request):
    data = json.loads(request.body)
    username = data['username']
    password1 = data['password1']
    password2 = data['password2']
    
    # Validasi
    if password1 != password2:
        return JsonResponse({
            "status": False,
            "message": "Passwords do not match."
        }, status=400)
    
    if User.objects.filter(username=username).exists():
        return JsonResponse({
            "status": False,
            "message": "Username already exists."
        }, status=400)
    
    # Create user
    user = User.objects.create_user(
        username=username,
        password=password1
    )
    user.save()
    
    return JsonResponse({
        "username": user.username,
        "status": True,
        "message": "User created successfully!"
    }, status=200)
```

**3. Response Handling di Flutter**

```dart
if (response['status'] == true) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Successfully registered as ${response['username']}!'))
  );
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => const LoginPage()),
  );
}
```

**B. LOGIN FLOW**

**1. Input di Flutter (login.dart)**

```dart
ElevatedButton(
  onPressed: () async {
    String username = _usernameController.text;
    String password = _passwordController.text;
    
    // Login via CookieRequest
    final response = await request.login(
      "http://localhost:8000/auth/login/",
      {
        'username': username,
        'password': password,
      }
    );
    // ... (lanjut step 2)
  }
)
```

**2. Autentikasi di Django (authentication/views.py)**

```python
@csrf_exempt
def login(request):
    username = request.POST['username']
    password = request.POST['password']
    
    # Authenticate user
    user = authenticate(username=username, password=password)
    
    if user is not None:
        if user.is_active:
            # Create session
            auth_login(request, user)
            
            return JsonResponse({
                "username": user.username,
                "status": True,
                "message": "Login successful!"
            }, status=200)
        else:
            return JsonResponse({
                "status": False,
                "message": "Account disabled."
            }, status=401)
    else:
        return JsonResponse({
            "status": False,
            "message": "Invalid username or password."
        }, status=401)
```

**3. Session Cookie Disimpan**

- Django mengirim `Set-Cookie` header dengan `sessionid`
- CookieRequest menyimpan cookie ini
- Semua request berikutnya otomatis membawa cookie ini

**4. Navigate ke Homepage**

```dart
if (request.loggedIn) {
  String message = response['message'];
  String uname = response['username'];
  
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => const AnchoraMallHome()),
  );
  
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text("$message Welcome, $uname."))
  );
}
```

**C. AUTHENTICATED REQUESTS**

Setelah login, setiap request membawa session cookie:

```dart
// Otomatis authenticated karena cookie tersimpan
final products = await request.get('http://localhost:8000/json/');
final myProducts = await request.get('http://localhost:8000/api/products/?source=my_products');
```

Django menerima cookie dan identify user:

```python
def show_json(request):
    # request.user otomatis terisi dari session
    products = Product.objects.filter(user=request.user)
    return HttpResponse(serializers.serialize("json", products))
```

**D. LOGOUT FLOW**

**1. Trigger Logout di Flutter**

```dart
ElevatedButton(
  onPressed: () async {
    final response = await request.logout(
      "http://localhost:8000/auth/logout/"
    );
    // ... (lanjut step 2)
  }
)
```

**2. Destroy Session di Django**

```python
@csrf_exempt
def logout(request):
    username = request.user.username
    
    # Destroy session
    auth_logout(request)
    
    return JsonResponse({
        "username": username,
        "status": True,
        "message": "Logged out successfully!"
    }, status=200)
```

**3. Clear Cookie dan Navigate**

```dart
if (response['status']) {
  String message = response["message"];
  String uname = response["username"];
  
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text("$message Goodbye, $uname."))
  );
  
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => const LoginPage()),
  );
}
```

**Diagram Autentikasi Lengkap:**

```
[Register Form] → [Django Create User] → [Login Page]
                                               ↓
[Login Form] → [Django Authenticate] → [Session Created] 
                                               ↓
                                    [Set-Cookie: sessionid]
                                               ↓
                                        [CookieRequest stores cookie]
                                               ↓
                                        [Navigate to Homepage]
                                               ↓
[Authenticated Requests] ← [Cookie sent automatically] → [Django recognizes user]
                                               ↓
[Logout Button] → [Django Destroy Session] → [Clear Cookie] → [Back to Login]
```

**Key Points:**
- Session berbasis cookies, bukan token
- CookieRequest handle cookie storage otomatis
- Django `request.user` otomatis terisi setelah login
- Logout menghapus session di server dan cookie di client

### 7. Implementasi Checklist Step-by-Step

**Step 1: Setup Django Authentication App**

```bash
# Di Django project
python manage.py startapp authentication
```

Tambahkan ke `INSTALLED_APPS` dan buat views untuk login, register, logout:

```python
# authentication/views.py
from django.contrib.auth import authenticate, login as auth_login, logout as auth_logout
from django.contrib.auth.models import User
import json
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt

@csrf_exempt
def login(request):
    username = request.POST['username']
    password = request.POST['password']
    user = authenticate(username=username, password=password)
    if user is not None:
        if user.is_active:
            auth_login(request, user)
            return JsonResponse({
                "username": user.username,
                "status": True,
                "message": "Login successful!"
            }, status=200)
    return JsonResponse({
        "status": False,
        "message": "Invalid credentials."
    }, status=401)

@csrf_exempt
def register(request):
    data = json.loads(request.body)
    username = data['username']
    password1 = data['password1']
    password2 = data['password2']
    
    if password1 != password2:
        return JsonResponse({"status": False, "message": "Passwords do not match."}, status=400)
    
    if User.objects.filter(username=username).exists():
        return JsonResponse({"status": False, "message": "Username exists."}, status=400)
    
    user = User.objects.create_user(username=username, password=password1)
    user.save()
    return JsonResponse({"username": user.username, "status": True, "message": "User created!"}, status=200)

@csrf_exempt
def logout(request):
    username = request.user.username
    auth_logout(request)
    return JsonResponse({"username": username, "status": True, "message": "Logged out!"}, status=200)
```

**Step 2: Konfigurasi CORS dan Cookie Settings**

```python
# settings.py
INSTALLED_APPS = [
    'corsheaders',
    'authentication',
    'main',
    ...
]

MIDDLEWARE = [
    'corsheaders.middleware.CorsMiddleware',
    ...
]

CORS_ALLOW_ALL_ORIGINS = True
CORS_ALLOW_CREDENTIALS = True
SESSION_COOKIE_SAMESITE = 'None'
SESSION_COOKIE_SECURE = True
CSRF_COOKIE_SAMESITE = 'None'
CSRF_COOKIE_SECURE = True
ALLOWED_HOSTS = ["localhost", "127.0.0.1", "10.0.2.2"]
```

**Step 3: Buat API Endpoint untuk Products**

```python
# main/views.py
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from django.views.decorators.http import require_POST
from main.models import Product
import json

@csrf_exempt
@require_POST
def create_product_flutter(request):
    data = json.loads(request.body)
    new_product = Product.objects.create(
        user=request.user,
        name=data["name"],
        price=data["price"],
        description=data["description"],
        category=data["category"],
        thumbnail=data["thumbnail"],
        is_featured=data.get("is_featured", False),
    )
    new_product.save()
    return JsonResponse({"status": "success"}, status=200)

def show_json(request):
    data = Product.objects.all()
    return HttpResponse(serializers.serialize("json", data), content_type="application/json")

def show_json_by_user(request):
    data = Product.objects.filter(user=request.user)
    return HttpResponse(serializers.serialize("json", data), content_type="application/json")
```

**Step 4: Setup Flutter Dependencies**

```yaml
# pubspec.yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.5+1
  pbp_django_auth: ^0.4.0
  http: ^1.6.0
```

```bash
flutter pub get
```

**Step 5: Tambahkan Internet Permission (Android)**

```xml
<!-- android/app/src/main/AndroidManifest.xml -->
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <uses-permission android:name="android.permission.INTERNET" />
    <application ...>
```

**Step 6: Buat Model Dart untuk Product**

```dart
// lib/models/product_entry.dart
class ProductEntry {
    int id;
    String name;
    String price;
    String? discountedPrice;
    String description;
    String thumbnail;
    String category;
    bool isFeatured;
    bool isOfficialStore;
    bool isBlacklisted;
    String user;
    String createdAt;

    ProductEntry({
        required this.id,
        required this.name,
        required this.price,
        this.discountedPrice,
        required this.description,
        required this.thumbnail,
        required this.category,
        required this.isFeatured,
        required this.isOfficialStore,
        required this.isBlacklisted,
        required this.user,
        required this.createdAt,
    });

    factory ProductEntry.fromJson(Map<String, dynamic> json) {
        // Handle Django serializer format with "pk" and "fields"
        if (json.containsKey("model") && json.containsKey("fields")) {
            final fields = json["fields"];
            return ProductEntry(
                id: json["pk"],
                name: fields["name"],
                price: fields["price"],
                discountedPrice: fields["discounted_price"],
                description: fields["description"],
                thumbnail: fields["thumbnail"] ?? "",
                category: fields["category"],
                isFeatured: fields["is_featured"],
                isOfficialStore: fields["is_official_store"],
                isBlacklisted: fields["is_blacklisted"],
                user: fields["user"].toString(),
                createdAt: fields["created_at"],
            );
        }
        // Handle flat JSON format
        return ProductEntry(
            id: json["id"],
            name: json["name"],
            price: json["price"],
            discountedPrice: json["discounted_price"],
            description: json["description"],
            thumbnail: json["thumbnail"] ?? "",
            category: json["category"],
            isFeatured: json["is_featured"],
            isOfficialStore: json["is_official_store"],
            isBlacklisted: json["is_blacklisted"],
            user: json["user"].toString(),
            createdAt: json["created_at"],
        );
    }
}
```

**Step 7: Setup Provider untuk CookieRequest**

```dart
// lib/main.dart
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) {
        CookieRequest request = CookieRequest();
        return request;
      },
      child: MaterialApp(
        title: 'Anchora Mall',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        home: const LoginPage(),
      ),
    );
  }
}
```

**Step 8: Buat Halaman Login**

```dart
// lib/screens/login.dart
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const Text('Login', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 30),
                  TextField(
                    controller: _usernameController,
                    decoration: const InputDecoration(labelText: 'Username'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _passwordController,
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () async {
                      String username = _usernameController.text;
                      String password = _passwordController.text;

                      final response = await request.login(
                        "http://localhost:8000/auth/login/",
                        {'username': username, 'password': password}
                      );

                      if (request.loggedIn) {
                        String message = response['message'];
                        String uname = response['username'];
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const AnchoraMallHome()),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("$message Welcome, $uname."))
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Login Failed'),
                            content: Text(response['message']),
                            actions: [
                              TextButton(
                                child: const Text('OK'),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                    child: const Text('Login'),
                  ),
                  const SizedBox(height: 36),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RegisterPage()),
                      );
                    },
                    child: Text(
                      'Don\'t have an account? Register',
                      style: TextStyle(color: Theme.of(context).colorScheme.primary),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
```

**Step 9: Buat Halaman Register**

```dart
// lib/screens/register.dart
// Similar structure dengan login, tapi POST ke /auth/register/
// dengan username, password1, password2
```

**Step 10: Integrasi Product Form dengan Django**

```dart
// lib/screens/product_form.dart
ElevatedButton(
  onPressed: () async {
    if (_formKey.currentState!.validate()) {
      final response = await request.postJson(
        "http://localhost:8000/create-flutter/",
        jsonEncode({
          "name": _name,
          "price": _price,
          "description": _description,
          "category": _category,
          "thumbnail": _thumbnail,
          "is_featured": _isFeatured,
        })
      );
      
      if (response['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Product created!"))
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AnchoraMallHome()),
        );
      }
    }
  },
  child: const Text("Save"),
)
```

**Step 11: Buat Halaman Daftar Produk**

```dart
// lib/screens/product_entry_list.dart
class ProductEntryListPage extends StatefulWidget {
  final bool showMyProducts;
  const ProductEntryListPage({super.key, this.showMyProducts = false});

  @override
  State<ProductEntryListPage> createState() => _ProductEntryListPageState();
}

class _ProductEntryListPageState extends State<ProductEntryListPage> {
  Future<List<ProductEntry>> fetchProducts(CookieRequest request) async {
    final url = widget.showMyProducts 
        ? 'http://localhost:8000/api/products/?source=my_products'
        : 'http://localhost:8000/api/products/';
    
    final response = await request.get(url);
    
    List<ProductEntry> listProducts = [];
    for (var d in response) {
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
        title: Text(widget.showMyProducts ? 'My Products' : 'All Products'),
      ),
      drawer: const LeftDrawer(),
      body: FutureBuilder(
        future: fetchProducts(request),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (!snapshot.hasData || snapshot.data!.length == 0) {
              return Center(
                child: Text(
                  widget.showMyProducts 
                      ? 'You have no products yet.'
                      : 'No products available.',
                ),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (_, index) => ProductEntryCard(
                  product: snapshot.data![index],
                  onTap: () {
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
```

**Step 12: Buat Product Card Widget**

```dart
// lib/widgets/product_entry_card.dart
class ProductEntryCard extends StatelessWidget {
  final ProductEntry product;
  final VoidCallback onTap;

  const ProductEntryCard({required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thumbnail dengan image proxy untuk CORS
              if (product.thumbnail.isNotEmpty)
                Image.network(
                  'http://localhost:8000/image-proxy/?url=${Uri.encodeComponent(product.thumbnail)}',
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              const SizedBox(height: 8),
              Text(product.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text('\$${product.price}'),
              Text(product.description, maxLines: 2, overflow: TextOverflow.ellipsis),
              if (product.isFeatured)
                Chip(label: Text('Featured'), backgroundColor: Colors.amber),
            ],
          ),
        ),
      ),
    );
  }
}
```

**Step 13: Buat Halaman Detail Produk**

```dart
// lib/screens/product_detail.dart
class ProductDetailPage extends StatelessWidget {
  final ProductEntry product;

  const ProductDetailPage({required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product Detail')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (product.thumbnail.isNotEmpty)
              Image.network(
                'http://localhost:8000/image-proxy/?url=${Uri.encodeComponent(product.thumbnail)}',
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Text('\$${product.price}', style: TextStyle(fontSize: 22, color: Colors.blue)),
                  const SizedBox(height: 12),
                  Text('Category: ${product.category}'),
                  const Divider(height: 32),
                  const Text('Description', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(product.description, style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

**Step 14: Implementasi Logout**

```dart
// Di homepage.dart atau drawer
ElevatedButton(
  onPressed: () async {
    final response = await request.logout("http://localhost:8000/auth/logout/");
    String message = response["message"];
    if (response['status']) {
      String uname = response["username"];
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("$message Goodbye, $uname."))
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("$message"))
      );
    }
  },
  child: const Text('Logout'),
)
```

**Step 15: Filter Products by User**

Di Django, buat endpoint yang filter berdasarkan query parameter:

```python
# main/views.py
def api_products(request):
    source = request.GET.get('source', 'all')
    
    if source == 'my_products':
        products = Product.objects.filter(user=request.user)
    else:
        products = Product.objects.all()
    
    return HttpResponse(serializers.serialize("json", products), content_type="application/json")
```

Di Flutter, gunakan parameter `showMyProducts`:

```dart
final url = widget.showMyProducts 
    ? 'http://localhost:8000/api/products/?source=my_products'
    : 'http://localhost:8000/api/products/';
```

**Step 16: Handling CORS untuk External Images**

Buat image proxy di Django untuk load external images:

```python
# main/views.py
import requests
from django.http import HttpResponse

def image_proxy(request):
    url = request.GET.get('url', '')
    if url:
        response = requests.get(url)
        return HttpResponse(response.content, content_type=response.headers['Content-Type'])
    return HttpResponse(status=400)
```

Di Flutter, gunakan proxy URL:

```dart
Image.network(
  'http://localhost:8000/image-proxy/?url=${Uri.encodeComponent(product.thumbnail)}',
)
```

**Testing Checklist:**
- ✅ Register akun baru
- ✅ Login dengan akun yang dibuat
- ✅ Lihat semua products (All Products)
- ✅ Lihat products milik user (My Products)
- ✅ Tambah product baru via form
- ✅ Lihat detail product
- ✅ Logout dan redirect ke login page
- ✅ Session persistent saat navigate antar halaman
- ✅ Images load correctly dengan proxy
- ✅ Filter by user works correctly

**Catatan Penting:**
- Gunakan `http://localhost:8000` untuk Flutter web (Chrome)
- Gunakan `http://10.0.2.2:8000` untuk Android Emulator
- Django server harus running saat testing Flutter app
- Install `django-cors-headers` di Django untuk CORS support
- Pastikan semua konfigurasi CORS dan cookies sudah benar

---