import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
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

  //get tiktok video
  Future<void> getTikTokVideo(BuildContext context, String videoUrl) async {

    linkrwm = '';
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

        link = response.data['link'];
        id = response.data['data']['id'];
        linkrwm = response.data['data']['video_link_nwm'];

        _isLoading = false;
        notifyListeners();

      }
      else {
        _isLoading = false;
        notifyListeners();
      }

    }
    on DioException catch(e) {

      if(e is DioExceptionType) {
        if(e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.sendTimeout ||
            e.type == DioExceptionType.receiveTimeout) {

          if(context.mounted) {
            Utils.showCustomSnackBar(
              context,
              'Time out error, Try again later',
              ContentType.failure,
            );
          }

          _isLoading = false;
          notifyListeners();
        }
        else if(e.type == DioExceptionType.cancel) {

          if(context.mounted) {
            Utils.showCustomSnackBar(
              context,
              'Request was cancelled, Try again later',
              ContentType.failure,
            );
          }

          _isLoading = false;
          notifyListeners();
        }
        else if(e.type == DioExceptionType.unknown) {
          if(context.mounted) {
            Utils.showCustomSnackBar(
              context,
              'Failed to get video!',
              ContentType.failure,
            );
          }

          _isLoading = false;
          notifyListeners();
        }

      }
      else if(e is SocketException) {

        if(context.mounted) {
          Utils.showCustomSnackBar(
            context,
            'Not connected to internet',
            ContentType.failure,
          );
        }

        _isLoading = false;
        notifyListeners();

      }
      else {

        if(context.mounted) {
          Utils.showCustomSnackBar(
            context,
            'Failed to get video !',
            ContentType.failure,
          );
        }

        _isLoading = false;
        notifyListeners();

      }


    }


  }

  //download tiktok video
  Future<void> downloadTikTokVideo(BuildContext context, String url, String fileName) async {

    _isDownloading = true;
    _progress = 0;

    notifyListeners();

    try {
      Dio dio = Dio();

      await dio.download(
        url,
        fileName,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            _progress = received / total;
            notifyListeners();
          }
          else {
            _isDownloading = false;
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

      if(context.mounted) {
        Utils.showCustomSnackBar(
          context,
          'Download Completed',
          ContentType.success,
        );
      }

      _isDownloading = false;
      notifyListeners();

    }
    on DioException catch(e) {

      if(e is DioExceptionType) {
        if(e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.sendTimeout ||
            e.type == DioExceptionType.receiveTimeout ) {

          if(context.mounted) {
            Utils.showCustomSnackBar(
              context,
              'Time out error, Try again later',
              ContentType.failure,
            );
          }

          _isDownloading = false;
          notifyListeners();
        }
        else if(e.type == DioExceptionType.cancel) {

          if(context.mounted) {
            Utils.showCustomSnackBar(
              context,
              'Request was cancelled, Try again later',
              ContentType.failure,
            );
          }

          _isDownloading = false;
          notifyListeners();
        }

      }
      else if(e.error is SocketException) {

        if(context.mounted) {
          Utils.showCustomSnackBar(
            context,
            'Not connected to internet',
            ContentType.failure,
          );
        }

        _isDownloading = false;
        notifyListeners();

      }
      else {

        print('dio error: ${e.toString()}');

        if(context.mounted) {
          Utils.showCustomSnackBar(
            context,
            'Failed to download video!',
            ContentType.failure,
          );
        }

        _isDownloading = false;
        notifyListeners();

      }
    }

  }

  //get instagram video
  Future<void> getInstagramVideo(BuildContext context, String videoUrl) async {

    media = '';
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
    on DioException catch(e) {

      if(e is DioExceptionType) {
        if(e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.sendTimeout ||
            e.type == DioExceptionType.receiveTimeout) {

          if(context.mounted) {
            Utils.showCustomSnackBar(
              context,
              'Time out error, Try again later',
              ContentType.failure,
            );
          }

          _isLoading = false;
          notifyListeners();
        }
        else if(e.type == DioExceptionType.cancel) {

          if(context.mounted) {
            Utils.showCustomSnackBar(
              context,
              'Request was cancelled, Try again later',
              ContentType.failure,
            );
          }

          _isLoading = false;
          notifyListeners();
        }
        else if(e.type == DioExceptionType.unknown) {
          if(context.mounted) {
            Utils.showCustomSnackBar(
              context,
              'Failed to get video!',
              ContentType.failure,
            );
          }

          _isLoading = false;
          notifyListeners();
        }

      }
      else if(e is SocketException) {

        if(context.mounted) {
          Utils.showCustomSnackBar(
            context,
            'Not connected to internet',
            ContentType.failure,
          );
        }

        _isLoading = false;
        notifyListeners();

      }
      else {

        if(context.mounted) {
          Utils.showCustomSnackBar(
            context,
            'Failed to get video !',
            ContentType.failure,
          );
        }

        _isLoading = false;
        notifyListeners();
      }
    }

  }

  //download instagram video
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
    }
    on DioException catch(e) {

      if(e is DioExceptionType) {
        if(e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.sendTimeout ||
            e.type == DioExceptionType.receiveTimeout ) {

          if(context.mounted) {
            Utils.showCustomSnackBar(
              context,
              'Time out error, Try again later',
              ContentType.failure,
            );
          }

          _isDownloading = false;
          notifyListeners();
        }
        else if(e.type == DioExceptionType.cancel) {

          if(context.mounted) {
            Utils.showCustomSnackBar(
              context,
              'Request was cancelled, Try again later',
              ContentType.failure,
            );
          }

          _isDownloading = false;
          notifyListeners();
        }

      }
      else if(e.error is SocketException) {

        if(context.mounted) {
          Utils.showCustomSnackBar(
            context,
            'Not connected to internet',
            ContentType.failure,
          );
        }

        _isDownloading = false;
        notifyListeners();

      }
      else {

        print('dio error: ${e.toString()}');

        if(context.mounted) {
          Utils.showCustomSnackBar(
            context,
            'Failed to download video!',
            ContentType.failure,
          );
        }

        _isDownloading = false;
        notifyListeners();

      }

    }

  }

  //get twitter video
  Future<void> getTwitterVideo(BuildContext context, String videoUrl) async {

    media = '';
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
    on DioException catch(e) {

      if(e is DioExceptionType) {
        if(e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.sendTimeout ||
            e.type == DioExceptionType.receiveTimeout) {

          if(context.mounted) {
            Utils.showCustomSnackBar(
              context,
              'Time out error, Try again later',
              ContentType.failure,
            );
          }

          _isLoading = false;
          notifyListeners();
        }
        else if(e.type == DioExceptionType.cancel) {

          if(context.mounted) {
            Utils.showCustomSnackBar(
              context,
              'Request was cancelled, Try again later',
              ContentType.failure,
            );
          }

          _isLoading = false;
          notifyListeners();
        }
        else if(e.type == DioExceptionType.unknown) {
          if(context.mounted) {
            Utils.showCustomSnackBar(
              context,
              'Failed to get video!',
              ContentType.failure,
            );
          }

          _isLoading = false;
          notifyListeners();
        }

      }
      else if(e is SocketException) {

        if(context.mounted) {
          Utils.showCustomSnackBar(
            context,
            'Not connected to internet',
            ContentType.failure,
          );
        }

        _isLoading = false;
        notifyListeners();

      }
      else {

        if(context.mounted) {
          Utils.showCustomSnackBar(
            context,
            'Failed to get video !',
            ContentType.failure,
          );
        }

        _isLoading = false;
        notifyListeners();

      }
    }


  }

  //download twitter video
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

    }
    on DioException catch(e) {

      if(e is DioExceptionType) {
        if(e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.sendTimeout ||
            e.type == DioExceptionType.receiveTimeout ) {

          if(context.mounted) {
            Utils.showCustomSnackBar(
              context,
              'Time out error, Try again later',
              ContentType.failure,
            );
          }

          _isDownloading = false;
          notifyListeners();
        }
        else if(e.type == DioExceptionType.cancel) {

          if(context.mounted) {
            Utils.showCustomSnackBar(
              context,
              'Request was cancelled, Try again later',
              ContentType.failure,
            );
          }

          _isDownloading = false;
          notifyListeners();
        }

      }
      else if(e.error is SocketException) {

        if(context.mounted) {
          Utils.showCustomSnackBar(
            context,
            'Not connected to internet',
            ContentType.failure,
          );
        }

        _isDownloading = false;
        notifyListeners();

      }
      else {

        print('dio error: ${e.toString()}');

        if(context.mounted) {
          Utils.showCustomSnackBar(
            context,
            'Failed to download video!',
            ContentType.failure,
          );
        }

        _isDownloading = false;
        notifyListeners();
      }

    }



  }



}
