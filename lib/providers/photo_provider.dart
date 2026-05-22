import 'package:flutter/material.dart';
import '../models/photo_model.dart';
import '../services/photo_service.dart';

class PhotoProvider extends ChangeNotifier {
  // inisialisasi variabel photo list berdasarkan model
  List<PhotoModel> photos = [];

  // state default
  bool isLoading = false;
  String errorMessage = '';

  Future<void> fetchPhotos() async {
    try {
      isLoading = true;
      errorMessage = '';
      notifyListeners();

      photos = await PhotoService.getPhotos();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}