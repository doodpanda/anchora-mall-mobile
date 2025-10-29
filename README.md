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