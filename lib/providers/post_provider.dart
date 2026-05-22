import 'package:flutter/material.dart';
import '../models/post_model.dart';
import '../services/post_service.dart';

class PostProvider extends ChangeNotifier{
  //inisialisasi variabel post list berdasarkan dari model
  List<PostModel> posts = [];

  //state default
  bool isLoading = false;
  String errorMessage = '';

  Future<void> fetchPost() async {
    try{
      isLoading =true;
      notifyListeners();
      posts = await PostService.getPosts();
    } catch (e) {
      errorMessage = e.toString();
    } finally{
      isLoading = false;
      notifyListeners();
    }
  }
}