# BlindIdTask
# 🎬 MoviesApp

> **MoviesApp**, SwiftUI ve MVVM mimarisiyle geliştirilmiş, kullanıcıların kayıt olup giriş yapabildiği, filmleri görüntüleyebildiği, detay sayfasına erişip favorilere ekleyip çıkardığı bir iOS uygulamasıdır.

---

## 📋 Özellikler

- **Kullanıcı Kimlik Doğrulama**  
  - Kayıt olma (`Register`)  
  - Giriş yapma (`Login`)
  - Çıkış yapma  (`Logout`)  
  - Token yönetimi / Keychain saklama  
- **Film Listesi**  
  - Tüm filmlerin asenkron olarak çekilmesi  
  - Arama ve kategori bazlı filtreleme  
  - Güncelleme (pull-to-refresh)  
- **Film Detay Sayfası**  
  - Poster, başlık, yıl, kategori, rating, açıklama  
  - Oyuncu kadrosu  
  - Favorirlere ekleme/çıkarma  
- **Favoriler**  
  - Kullanıcının beğendiği filmlerin listelenmesi  
  - Favoriden çıkarma  
- **Profil Yönetimi**  
  - `/auth/me` ile mevcut profil bilgisinin görüntülenmesi  
  - `/users/profile` üzerinden ad, soyad, e-posta güncelleme

---

## 🛠️ Teknolojiler

- Swift 5.7+, SwiftUI  
- MVVM (Model-View-ViewModel)  
- Combine / async-await  
- URLSession ile REST API  
- KeychainService (token saklama)  
- Xcode 15 / iOS 17  




