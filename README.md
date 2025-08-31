# Progamon — Team Builder (Flutter + GetX)

แอปคล้ายๆโปรเกม่อน
เกมสำหรับสร้าง “ทีมสมาชิก 3 คน” 
จากรายชื่ออย่างน้อย 20 คน  
มีตัวละคร 30 ตัว 

## ฟีเจอร์
- เลือก/ยกเลิกเลือกสมาชิกได้ (แตะซ้ำ)
- แถบ **พรีวิวรูปสมาชิกที่เลือก** อยู่กึ่งกลางใต้ช่อง “ชื่อทีม”
- จำกัดสมาชิกทีมได้ 3 คนต่อทีม พร้อมตัวนับแบบเรียลไทม์
- ค้นหาตัวละครได้
- สร้าง/แก้ไข/ลบทีม

---

## สิ่งที่ต้องติดตั้งก่อนเริ่ม

### ทุกแพลตฟอร์ม
1) **Flutter SDK (stable)**  
   https://flutter.dev/docs/get-started/install  
   ตรวจสอบ:
   ```bash
   flutter doctor -v

การติดตั้งแพ็กเกจ (pubspec.yaml)
dependencies:
  flutter:
    sdk: flutter
  get: ^4.7.2
  get_storage: ^2.1.1
  cached_network_image: ^3.4.1
  characters: ^1.3.0
  cupertino_icons: ^1.0.8

การรัน/บิลด์

ติดตั้งแพ็กเกจ:

flutter clean
flutter pub get

//แสดงผลหน้าจอ

# Web
flutter run -d chrome

# Windows
flutter config --enable-windows-desktop
flutter run -d windows

# Android (ต้องมีอีมูเลเตอร์/มือถือเสียบอยู่)
flutter devices
flutter run -d <deviceId>

แหล่งรูปภาพ

HybridShivam/Pokemon (001–030):
รูปดึงผ่าน URL https://raw.githubusercontent.com/HybridShivam/Pokemon/master/assets/images/XYZ.png