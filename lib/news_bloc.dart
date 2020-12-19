import 'dart:async';
import 'news_info.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

enum NewsAction { FETCH, DELETE }

class NewsBloc {
  final _counterStreamController = StreamController<List<Article>>();
  StreamSink<List<Article>> get newsSink => _counterStreamController.sink;
  Stream<List<Article>> get newsStream => _counterStreamController.stream;

  //event stream controller pipe
  final _eventStreamController = StreamController<NewsAction>();
  StreamSink<NewsAction> get eventSink => _eventStreamController.sink;
  Stream<NewsAction> get _eventStream => _eventStreamController.stream;

  NewsBloc() {
    _eventStream.listen((event) async {
      if (event == NewsAction.FETCH) {
        try {
          var news = await getNews();
          if (news != null)
            newsSink.add(news.articles);
          else
            newsSink.addError('Something goes wrong!');
        } on Exception catch (e) {
          newsSink.addError('Something goes wrong!');
        }
      }
    });
  }

  Future<NewsModel> getNews() async {
    var client = http.Client();
    var newsModel;

    try {
      var response = await client
          .get(' http://newsapi.org/v2/everything?domains=wsj.com&apiKey=API');
      if (response.statusCode == 200) {
        var jsonString = response.body;
        var jsonMap = json.decode(jsonString);

        newsModel = NewsModel.fromJson(jsonMap);
      }
    } catch (Exception) {
      return newsModel;
    }

    return newsModel;
  }

  void dispose() {
    eventSink.close();
    newsSink.close();
  }
}
