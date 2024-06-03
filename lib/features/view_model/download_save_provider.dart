import 'dart:convert';
import 'dart:developer';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:social_downloader/core/utils/utils.dart';

class DownloadSaveProvider extends ChangeNotifier {

  bool _isDownloading = false;
  bool _isLoading = false;
  double _progress = 0;

  bool get isDownloading => _isDownloading;
  double get progress => _progress;
  bool get isLoading => _isLoading;

  String videoLink = '';

  //tiktok video
  String id = '';
  String link = '';
  String linkrwm = '';

  //instagram video
  String media = '';


  setVideoLink(String link) {
    videoLink = link;
    notifyListeners();
  }

  String get getVideoLink => videoLink;

  //List<VideoItem> oldDownloads = [];

  //get tiktok video
  Future<void> getTikTokVideo(BuildContext context, String videoUrl) async {

    _isLoading = true;
    notifyListeners();

    String completeUrl = 'https://tiktok-download-video-no-watermark.p.rapidapi.com/tiktok/info?url=$videoUrl';
    log('complete tiktok url: $completeUrl');

    try {

      var headers = {
        'Content-Type': 'application/json',
        'X-RapidAPI-Key': 'a09e00bb8emshae3d0d11f6dbce6p18e256jsnf3453565a6b9',
        'X-RapidAPI-Host': 'tiktok-download-video-no-watermark.p.rapidapi.com'
      };
      var dio = Dio();
      var response = await dio.request(
        'https://tiktok-download-video-no-watermark.p.rapidapi.com/tiktok/info?url=$videoUrl',
        options: Options(
          method: 'GET',
          headers: headers,
        ),
      );

      print('status code: ${response.statusCode}');

      if (response.statusCode == 200) {

        if(response.data.containsKey('code')) {

          if(response.data['code'] == -1) {

            Utils.showCustomSnackBar(
              context,
              response.data['message'],
              ContentType.failure,
            );
            _isLoading = false;
            notifyListeners();
            return;
          }

        }


        log(json.encode(response.data));

        print('link: ${response.data['link']}');
        print('id: ${response.data['data']['id']}');

        link = response.data['link'];
        id = response.data['data']['id'];
        linkrwm = response.data['data']['video_link_nwm'];

        _isLoading = false;
        notifyListeners();

      }
      else {
        print(response.statusMessage);
      }

    }
    catch(e) {

      Utils.showCustomSnackBar(
        context,
        'Failed to get video !',
        ContentType.failure,
      );

      _isLoading = false;
      notifyListeners();
      throw Exception('Failed to get video: $e');

    }


  }

  Future<void> downloadTikTokVideo(BuildContext context, String url, String fileName) async {
    _isDownloading = true;
    _progress = 0;
    notifyListeners();

    try {
      Dio dio = Dio();

      dio.options.receiveDataWhenStatusError = true;

      await dio.download(
        url,
        fileName,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            _progress = received / total;
            notifyListeners();
          }
        },
        options: Options(
          headers: {
            'X-RapidAPI-Key': 'a09e00bb8emshae3d0d11f6dbce6p18e256jsnf3453565a6b9',
            'X-RapidAPI-Host': 'tiktok-download-video-no-watermark.p.rapidapi.com',
          },

        ),
      );

      await GallerySaver.saveVideo(fileName);

      Utils.showCustomSnackBar(
        context,
        'Download Completed',
        ContentType.success,
      );



      _isDownloading = false;
      notifyListeners();
    } catch (e) {
      _isDownloading = false;
      notifyListeners();
      throw Exception('Failed to download video: $e');
    }
  }

  //get instagram video
  Future<void> getInstagramVideo(BuildContext context, String videoUrl) async {

    _isLoading = true;
    notifyListeners();


    String completeUrl = 'https://instagram-downloader-download-instagram-videos-stories.p.rapidapi.com/index?url=$videoUrl';

    log('complete insta url: $completeUrl');


    try {

      var headers = {
        'Content-Type': 'application/json',
        'X-RapidAPI-Key': 'a09e00bb8emshae3d0d11f6dbce6p18e256jsnf3453565a6b9',
        'X-RapidAPI-Host': 'instagram-downloader-download-instagram-videos-stories.p.rapidapi.com'
      };
      var dio = Dio();
      var response = await dio.request(
        'https://instagram-downloader-download-instagram-videos-stories.p.rapidapi.com/index?url=$videoUrl',
        options: Options(
          method: 'GET',
          headers: headers,
        ),
      );

      log('status code: ${response.statusCode}');
      log('get insta video response: ${response.data}');

      if (response.statusCode == 200) {
        log(json.encode(response.data));

        if(response.data.containsKey('story_by_id') && response.data['story_by_id'] != null) {
          print('media inside story by id: ${response.data['story_by_id']['media']}');
          media = response.data['story_by_id']['media'];
        }
        else if(response.data.containsKey('stories') && response.data['stories'] != null) {

          print('media inside stories: ${response.data['stories'][0]['media']}');
          media = response.data['stories'][0]['media'];

        }
        else {

          print('media: ${response.data['media']}');
          media = response.data['media'];

        }

        _isLoading = false;
        notifyListeners();

      }
      else {
        print(response.statusMessage);

        _isLoading = false;
        notifyListeners();

      }

    }
    catch(e) {

      Utils.showCustomSnackBar(
        context,
        'Failed to get video !',
        ContentType.failure,
      );

      _isLoading = false;
      notifyListeners();

      throw Exception('Failed to get video: $e');
    }

  }

  Future<void> downloadInstagramVideo(BuildContext context, String url, String fileName) async {

    _isDownloading = true;
    _progress = 0;
    notifyListeners();

    try {
      Dio dio = Dio();

      dio.options.receiveDataWhenStatusError = true;

      await dio.download(
        url,
        fileName,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            _progress = received / total;
            notifyListeners();
          }
        },
        options: Options(
          headers: {
            'X-RapidAPI-Key': 'a09e00bb8emshae3d0d11f6dbce6p18e256jsnf3453565a6b9',
            'X-RapidAPI-Host': 'instagram-downloader.p.rapidapi.com',
          },
        ),
      );

      await GallerySaver.saveVideo(fileName);

      Utils.showCustomSnackBar(
        context,
        'Download Completed',
        ContentType.success,
      );


      _isDownloading = false;
      notifyListeners();
    } catch (e) {
      _isDownloading = false;
      notifyListeners();
      throw Exception('Failed to download video: $e');
    }
  }

  Future<void> getTwitterVideo(BuildContext context, String videoUrl) async {

    _isLoading = true;
    notifyListeners();


    String completeUrl = 'https://twitter-downloader1.p.rapidapi.com/twitter?twitterUrl=$videoUrl';
    log('complete twitter url: $completeUrl');

    try {

      var headers = {
        'Content-Type': 'application/json',
        'X-RapidAPI-Key': 'a09e00bb8emshae3d0d11f6dbce6p18e256jsnf3453565a6b9',
        'X-RapidAPI-Host': 'twitter-downloader1.p.rapidapi.com'
      };
      var dio = Dio();
      var response = await dio.request(
        'https://twitter-downloader1.p.rapidapi.com/twitter?twitterUrl=$videoUrl',
        options: Options(
          method: 'GET',
          headers: headers,
        ),
      );

      log('status code: ${response.statusCode}');
      log('get twitter video response: ${response.data}');

      if (response.statusCode == 200) {
        log(json.encode(response.data));

        print('media: ${response.data['media'][0][0]}');
        media = response.data['media'][0][0];

        _isLoading = false;
        notifyListeners();

      }
      else {
        print(response.statusMessage);

        _isLoading = false;
        notifyListeners();

      }

    }
    catch(e) {

      Utils.showCustomSnackBar(
        context,
        'Failed to get video !',
        ContentType.failure,
      );

      _isLoading = false;
      notifyListeners();
      throw Exception('Failed to get video: $e');

    }



  }

  Future<void> downloadTwitterVideo(BuildContext context, String url, String fileName) async {

    _isDownloading = true;
    _progress = 0;
    notifyListeners();

    try {
      Dio dio = Dio();

      dio.options.receiveDataWhenStatusError = true;

      await dio.download(
        url,
        fileName,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            _progress = received / total;
            notifyListeners();
          }
        },
        options: Options(
          headers: {
            'X-RapidAPI-Key': 'a09e00bb8emshae3d0d11f6dbce6p18e256jsnf3453565a6b9',
            'X-RapidAPI-Host': 'twitter-downloader1.p.rapidapi.com',
          },
        ),
      );

      await GallerySaver.saveVideo(fileName);

      Utils.showCustomSnackBar(
        context,
        'Download Completed',
        ContentType.success,
      );


      _isDownloading = false;
      notifyListeners();

    } catch (e) {
      _isDownloading = false;
      notifyListeners();
      throw Exception('Failed to download video: $e');
    }
  }



}
