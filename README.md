# Responsi Pemrograman Mobile - Aplikasi Cuaca (Flutter)

Aplikasi cuaca modern berbasis Flutter yang mengimplementasikan arsitektur **Model-View-ViewModel (MVVM)**, state management menggunakan **Provider**, integrasi REST API dari **Open-Meteo**, serta penyimpanan lokal (**SharedPreferences**) untuk menyimpan lokasi favorit dan riwayat pencarian.

---

## 📱 Fitur Utama

1. **Home / Weather Screen**:
   - Menampilkan nama kota dan wilayah yang sedang dipilih.
   - Menampilkan kondisi cuaca terkini (kode kondisi cuaca WMO, ikon adaptif, dan gradien warna dinamis).
   - Menampilkan suhu saat ini dalam derajat Celsius.
   - Menampilkan informasi cuaca tambahan:
     - **Kelembapan Udara** (`relative_humidity_2m` dalam %)
     - **Kecepatan Angin** (`wind_speed_10m` dalam km/j)
     - **Suhu Terasa** (`apparent_temperature` dalam °C)
     - **Curah Hujan / Presipitasi** (`precipitation` dalam mm)
   - Menampilkan perkiraan cuaca 7 hari ke depan (suhu minimum/maksimum harian, kondisi cuaca, dan peluang hujan).
   - Tombol toggle untuk menambah/menghapus lokasi saat ini dari daftar **Favorit**.
   - Fitur *Pull-to-Refresh* untuk memperbarui data cuaca terkini.

2. **Search / Location Screen**:
   - Input pencarian kota menggunakan Geocoding REST API Open-Meteo secara dinamis.
   - Menampilkan daftar hasil pencarian lokasi lengkap dengan nama kota, provinsi/negara, dan koordinat.
   - Pengguna dapat memilih lokasi untuk langsung memuat dan menampilkan cuaca di layar utama.
   - Fitur bookmark / favorit pada setiap hasil pencarian (tersimpan di penyimpanan lokal).
   - Menampilkan daftar **Lokasi Favorit** dan **Riwayat Pencarian** tersimpan saat kolom pencarian kosong.
   - Opsi untuk menghapus riwayat pencarian satuan maupun seluruhnya.

3. **Error Handling & State Management**:
   - Penanganan status loading indikator.
   - Penanganan kondisi ketika perangkat tidak memiliki koneksi internet (*SocketException* / timeout).
   - Penanganan kondisi kota tidak ditemukan (*empty state*).
   - Tombol coba lagi (*retry*) jika request API gagal.

---

## 🏗️ Pola Arsitektur MVVM (Model-View-ViewModel)

Aplikasi ini dibangun menggunakan arsitektur MVVM dengan pemisahan tanggung jawab yang jelas:

```
lib/
├── main.dart                       # Entry point aplikasi & konfigurasi MultiProvider
├── models/                         # Data layer (Representasi objek & parsing JSON)
│   ├── location_model.dart         # Model data lokasi geocoding
│   └── weather_model.dart          # Model cuaca saat ini & perkiraan 7 hari
├── services/                       # Data Source & Networking layer
│   ├── weather_api_service.dart    # Komunikasi HTTP GET ke Open-Meteo REST API
│   └── storage_service.dart        # Penyimpanan lokal SharedPreferences (favorit, history, last location)
├── utils/                          # Utility & Styling
│   ├── app_theme.dart              # Konfigurasi Material 3 Theme
│   └── weather_helper.dart         # Helper pemetaan WMO code, format tanggal & ikon
├── viewmodels/                     # ViewModel layer (Business Logic & State)
│   ├── weather_viewmodel.dart      # Mengelola state data cuaca, lokasi aktif, & status favorit
│   └── search_viewmodel.dart       # Mengelola pencarian kota, daftar favorit, & riwayat
└── views/                          # View / UI layer
    ├── home_screen.dart            # Tampilan utama cuaca
    ├── search_screen.dart          # Tampilan pencarian kota, favorit, & history
    └── widgets/                    # Reusable UI widgets
        ├── current_weather_card.dart
        ├── daily_forecast_list.dart
        ├── search_location_tile.dart
        └── weather_metrics_grid.dart
```

### Penjelasan Komponen MVVM:
- **Model**: Merepresentasikan struktur data yang diterima dari API atau penyimpanan lokal. Model memiliki factory method `fromJson` untuk memetakan respons JSON dari API ke objek Dart, serta `toJson` untuk serialisasi ke penyimpanan lokal.
- **View**: Komponen antarmuka pengguna (UI) yang bertugas menampilkan data dan menangani interaksi pengguna. View tidak memproses logika data langsung, melainkan mengamati (*listen*) perubahan state dari ViewModel melalui `Consumer` atau `context.watch/read`.
- **ViewModel**: Bertindak sebagai jembatan antara View dan Model/Services. ViewModel meng-extend `ChangeNotifier` dan memanggil `notifyListeners()` setiap kali terjadi perubahan state (misal: saat data cuaca selesai dimuat atau ketika status loading berubah).
- **Services**: Menangani detail teknis jaringan (HTTP request via package `http`) dan penyimpanan lokal perangkat (via `SharedPreferences`).

---

## 🌐 Implementasi REST API Open-Meteo

Aplikasi menggunakan dua endpoint publik dari [Open-Meteo](https://open-meteo.com/):

1. **Weather Forecast API**:
   - **URL**: `https://api.open-meteo.com/v1/forecast`
   - **Metode**: `GET`
   - **Parameter**:
     - `latitude`: Koordinat lintang lokasi
     - `longitude`: Koordinat bujur lokasi
     - `current`: `temperature_2m,relative_humidity_2m,apparent_temperature,precipitation,weather_code,wind_speed_10m`
     - `daily`: `weather_code,temperature_2m_max,temperature_2m_min,precipitation_probability_max`
     - `timezone`: `auto`

2. **Geocoding API**:
   - **URL**: `https://geocoding-api.open-meteo.com/v1/search`
   - **Metode**: `GET`
   - **Parameter**:
     - `name`: Nama kota / kata kunci pencarian
     - `count`: `10`
     - `language`: `id`
     - `format`: `json`

---

## 📷 Screenshot Aplikasi

| Home / Weather Screen | Search Screen (Pencarian) | Favorit & Riwayat |
|:---:|:---:|:---:|
| *(Tambahkan screenshot Home)* | *(Tambahkan screenshot Search)* | *(Tambahkan screenshot Favorit)* |

---

## ⚙️ Cara Menjalankan Aplikasi

1. Pastikan Flutter SDK sudah terpasang di komputer Anda.
2. Buka terminal pada folder proyek `responsi_flutter`:
   ```bash
   cd responsi_flutter
   ```
3. Unduh seluruh dependensi:
   ```bash
   flutter pub get
   ```
4. Jalankan aplikasi pada emulator atau perangkat fisik Android:
   ```bash
   flutter run
   ```
