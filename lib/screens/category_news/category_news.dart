import 'package:flutter/material.dart';
import 'package:swipe_up/swipe_up.dart';
import 'package:tech_two_stop_v2/screens/news/article_view.dart';
import '../../common_widgets/article_card.dart';
import '../../helper/news_article_api.dart';
import '../../helper/resources.dart';
import '../../models/article_model.dart';

class CategoryNews extends StatefulWidget {
  CategoryNews({this.categoryId, this.categoryName});
  final int categoryId;
  final String categoryName;
  @override
  _CategoryNewsState createState() => _CategoryNewsState();
}

class _CategoryNewsState extends State<CategoryNews> {
  Resources r = new Resources();
  bool _loading = true;
  List<ArticleModel> articles = new List<ArticleModel>();

  int pageIndex = 0;

  @override
  void initState() {
    super.initState();
    getCategoryNews();
  }

  getCategoryNews() async {
    CategoryNewsArticle news = CategoryNewsArticle();
    await news.getCategoryNews(widget.categoryId);
    articles = news.categoryNews;
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: r.bgColor,
      appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  //color: Colors.black,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
          ),
          //backgroundColor: r.bgColor,
          backgroundColor: Colors.black,
          elevation: 0.0,
          title: Image.asset('images/tech2stop_header_logo.jpeg',
              fit: BoxFit.contain, height: 20)),
      body: Container(
        child: _loading
            ? Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: 20, top: 20),
                      child: Text(
                        '${widget.categoryName} News',
                        style: TextStyle(
                            fontSize: 22.0,
                            //color: Colors.black,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontFamily: r.f1),
                      ),
                    ),
                    SizedBox(height: 20),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(top: 0.0),
                        child: PageView.builder(
                          onPageChanged: (index) {
                            setState(() {
                              pageIndex = index;
                            });
                          },
                          physics: BouncingScrollPhysics(),
                          itemCount: articles.length,
                          itemBuilder: (context, index) => ArticleCard(
                            imageUrl: articles[index].imageUrl,
                            title: articles[index].title,
                            description: articles[index].description,
                            url: articles[index].url,
                          ),
                        ),
                      ),
                    ),
                    SwipeUp(
                      onSwipe: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ArticleView(
                                articleUrl: articles[pageIndex].url)));
                      },
                      child: Container(child: Text('Swipe Up')),
                      body: Container(
                        alignment: Alignment.bottomCenter,
                        width: MediaQuery.of(context).size.width,
                        height: 80,
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
