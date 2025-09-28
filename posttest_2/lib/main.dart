import 'package:flutter/material.dart';

void main() {
  runApp(const RestaurantApp()); // jalankan aplikasi dengan widget utama
}

// Root Aplikasi
class RestaurantApp extends StatelessWidget {
  const RestaurantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Aplikasi Menu Restoran",
      debugShowCheckedModeBanner: false, // hilangkan banner "debug"
      home: const LoadingScreen(), // halaman pertama adalah LoadingScreen
    );
  }
}

// Loading Screen 
class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    // pindah dari Loading Screen ke HomePage setelah 4 detik
    Future.delayed(const Duration(seconds: 4), () {
      if (!mounted) return; // cek apakah widget masih ada di tree
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300], // warna abu-abu muda
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            SizedBox(height: 20),
            Text(
              "Aplikasi Menu Restoran", // judul aplikasi
              style: TextStyle(
                fontSize: 26, // ukuran font
                fontWeight: FontWeight.bold, // teks tebal
                color: Colors.black87, // warna teks
              ),
            )
          ],
        ),
      ),
    );
  }
}

// Home Page (Wireframe)
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, dynamic>> menus = []; // list menu disimpan di memori

  void addMenu(Map<String, dynamic> menu) {
    setState(() {
      menus.add(menu); // tambahkan menu baru ke list
    });
  }

  void deleteMenu(int index) {
    setState(() {
      menus.removeAt(index); // hapus menu dari list
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // latar belakang putih
      appBar: AppBar(
        title: const Text(
          "Aplikasi Menu Restoran",
          style: TextStyle(color: Colors.black), // teks appbar hitam
        ),
        backgroundColor: Colors.grey[300], // warna abu-abu
        centerTitle: true, // teks judul di tengah
      ),
      body: Column(
        children: [
          // Banner sambutan di atas
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            color: Colors.grey[200], // abu-abu lebih muda
            child: const Text(
              "Selamat Datang di Restoran Kami", // teks banner
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),

          // Grid Navigasi (menu ke halaman lain)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: GridView.count(
                crossAxisCount: 2, // jumlah kolom = 2
                crossAxisSpacing: 15, // jarak horizontal antar card
                mainAxisSpacing: 15, // jarak vertikal antar card
                children: [
                  // card menuju Daftar Menu
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              MenuListPage(menus: menus, onDelete: deleteMenu),
                        ),
                      );
                    },
                    child: _menuCard("Daftar Menu", Colors.grey[200]),
                  ),
                  // card menuju Tambah Menu
                  GestureDetector(
                    onTap: () async {
                      final newMenu = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AddMenuPage(),
                        ),
                      );
                      if (newMenu != null) {
                        addMenu(newMenu); // tambah menu baru
                      }
                    },
                    child: _menuCard("Tambah Menu", Colors.grey[200]),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget Card sederhana (hanya teks judul)
  Widget _menuCard(String title, Color? bg) {
    return Card(
      elevation: 2, // efek bayangan tipis
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      color: bg,
      child: Center(
        child: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

// Daftar Menu (Wireframe)
class MenuListPage extends StatefulWidget {
  final List<Map<String, dynamic>> menus; // list menu dari HomePage
  final Function(int) onDelete; // fungsi hapus menu

  const MenuListPage({super.key, required this.menus, required this.onDelete});

  @override
  State<MenuListPage> createState() => _MenuListPageState();
}

class _MenuListPageState extends State<MenuListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Daftar Menu",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.grey[300],
        centerTitle: true,
      ),
      body: widget.menus.isEmpty
          ? const Center(
              child: Text("Belum Ada Menu, Silakan Tambah Dulu !"),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: widget.menus.length, // jumlah item menu
              itemBuilder: (context, index) {
                var menu = widget.menus[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  elevation: 1,
                  child: ListTile(
                    title: Text(menu["name"],
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    subtitle: Text("Rp ${menu["price"]} • ${menu["category"]}"),
                    trailing: TextButton(
                      onPressed: () {
                        widget.onDelete(index); // hapus item
                        setState(() {}); // refresh UI
                      },
                      child: const Text(
                        "Hapus",
                        style: TextStyle(color: Colors.red), // tombol hapus merah
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

// Form Tambah Menu (Wireframe)
class AddMenuPage extends StatefulWidget {
  const AddMenuPage({super.key});

  @override
  State<AddMenuPage> createState() => _AddMenuPageState();
}

class _AddMenuPageState extends State<AddMenuPage> {
  final TextEditingController nameController = TextEditingController(); // input nama
  final TextEditingController priceController = TextEditingController(); // input harga
  String? kategori; // kategori menu

  @override
  void dispose() {
    nameController.dispose(); // hapus controller nama
    priceController.dispose(); // hapus controller harga
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Tambah Menu",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.grey[300],
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController, // input nama menu
              decoration: const InputDecoration(labelText: "Nama Menu"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: priceController, // input harga menu
              decoration: const InputDecoration(labelText: "Harga"),
              keyboardType: TextInputType.number, // hanya angka
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: "Kategori"),
              initialValue: kategori,
              items: const [
                DropdownMenuItem(value: "Makanan", child: Text("Makanan")),
                DropdownMenuItem(value: "Minuman", child: Text("Minuman")),
              ],
              onChanged: (value) {
                setState(() {
                  kategori = value; // simpan pilihan kategori
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty &&
                    priceController.text.isNotEmpty &&
                    kategori != null) {
                  final menu = {
                    "name": nameController.text,
                    "price": int.tryParse(priceController.text) ?? 0,
                    "category": kategori,
                  };
                  Navigator.pop(context, menu); // kirim data balik ke HomePage
                }
              },
              child: const Text("Simpan"), // tombol simpan
            ),
          ],
        ),
      ),
    );
  }
}
