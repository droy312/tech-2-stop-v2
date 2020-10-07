import 'package:flutter/material.dart';
import 'package:flutter_html/style.dart';
import 'package:swipe_up/swipe_up.dart';
import 'package:tech_two_stop_v2/screens/category_news/category_news.dart';
import '../../common_widgets/article_card.dart';
import '../../common_widgets/category_tile.dart';
import '../../helper/category_data.dart';
import '../../helper/news_article_api.dart';
import '../../models/article_model.dart';

import '../../models/category_model.dart';
import '../../helper/resources.dart';
import '../../screens/news/article_view.dart';
import '../../services/auth.dart';

class HomePage extends StatefulWidget {
  final bool isSkip;

  HomePage({this.isSkip = false});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Resources r = new Resources();
  List<CategoryModel> categories = new List<CategoryModel>();
  bool _loading = true;

  List<ArticleModel> articles = new List<ArticleModel>();

  Color upIconColor = Colors.grey;

  int pageIndex = 0;

  @override
  void initState() {
    super.initState();
    categories = getCategories();
    getArticles();
  }

  getArticles() async {
    NewsArticle news = NewsArticle();
    await news.getArticles();
    articles = news.articles;
    setState(() {
      _loading = false;
    });
  }

  //TODO: Links -
  // https://www.tech2stop.com/about-us/
  // https://www.tech2stop.com/contact/
  // https://www.tech2stop.com/solve-your-tech-queries/
  // https://www.tech2stop.com/product-decider/
  // https://www.tech2stop.com/wpautoterms/privacy-policy/

  // ------------- USING -------------------

  Widget listTile({String title, IconData icon, String url}) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[800]),
      title: Text(title, style: r.style(Colors.grey[800], 16, r.f4)),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  url == 'Home' ? HomePage() : ArticleView(articleUrl: url),
            ));
      },
    );
  }

  Widget drawerWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Colors.black12, offset: Offset(0, 5), blurRadius: 10),
            ],
            //color: r.bgColor,
            color: Colors.black,
          ),
          height: 80,
          alignment: Alignment.center,
          child: Image.asset('images/tech2stop_header_logo.jpeg', height: 20),
        ),
        Expanded(
          child: ListView(
            children: <Widget>[
              listTile(
                icon: Icons.home,
                title: 'Home',
                url: 'Home',
              ),
              listTile(
                icon: Icons.people,
                title: 'About us',
                url: 'https://www.tech2stop.com/about-us/',
              ),
              listTile(
                icon: Icons.message,
                title: 'Contact Us',
                url: 'https://www.tech2stop.com/contact/',
              ),
              listTile(
                icon: Icons.help,
                title: 'Solve your Tech queries',
                url: 'https://www.tech2stop.com/solve-your-tech-queries/',
              ),
              listTile(
                icon: Icons.assessment,
                title: 'Product decider',
                url: 'https://www.tech2stop.com/product-decider/',
              ),
              ListTile(
                leading: Icon(Icons.language, color: Colors.grey[800]),
                title: Text('Covid Corner',
                    style: r.style(Colors.grey[800], 16, r.f4)),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CategoryNews(
                                categoryId: 5328,
                                categoryName: 'COVID-19',
                              )));
                },
              ),
              listTile(
                icon: Icons.security,
                title: 'Privacy policy',
                url: 'https://www.tech2stop.com/wpautoterms/privacy-policy/',
              ),
              widget.isSkip
                  ? Container()
                  : ListTile(
                      leading: Icon(Icons.exit_to_app, color: Colors.grey[800]),
                      title: Text('Logout',
                          style: r.style(Colors.grey[800], 16, r.f4)),
                      onTap: () => AuthService().signOut(),
                    ),
            ],
          ),
        ),
      ],
    );
  }

  Widget headerText(String text) {
    return Container(
      margin: EdgeInsets.all(20),
      child: Text(text, style: r.style(r.black, 24, r.f1, isBold: true)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: r.bgColor,
      appBar: AppBar(
        centerTitle: true,
        //backgroundColor: r.bgColor,
        backgroundColor: Colors.black,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        leading: Container(
          child: Builder(
            builder: (context) {
              return IconButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                icon: Icon(Icons.menu, color: Colors.white),
              );
            },
          ),
        ),
        title: Image.asset('images/tech2stop_header_logo.jpeg',
            fit: BoxFit.fitHeight, height: 20),
      ),
      drawer: SafeArea(
        child: Drawer(child: drawerWidget()),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            setState(() {
              _loading = true;
            });
            NewsArticle news = NewsArticle();
            await news.getArticles();
            articles = news.articles;
            setState(() {
              _loading = false;
            });
          },
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 10),
                Container(
                  height: 70.0,
                  //padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length + 1,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return index == 0
                          ? SizedBox(width: 20)
                          : CategoryTile(
                              categoryId: categories[index - 1].id,
                              imageUrl: categories[index - 1].imageUrl,
                              categoryName: categories[index - 1].categoryName,
                            );
                    },
                  ),
                ),
                headerText('Discover Latest Tech News'),
                Expanded(
                  child: _loading
                      ? Container(
                          height: MediaQuery.of(context).size.height - 300.0,
                          width: MediaQuery.of(context).size.width,
                          child: Center(child: CircularProgressIndicator()),
                        )
                      : Container(
                          padding: EdgeInsets.only(top: 16.0),
                          child: PageView.builder(
                            scrollDirection: Axis.horizontal,
                            physics: BouncingScrollPhysics(),
                            itemCount: articles.length,
                            onPageChanged: (index) {  
                              setState(() {
                                pageIndex = index;
                              });
                            },
                            itemBuilder: (context, index) {
                              return ArticleCard(
                                imageUrl: articles[index].imageUrl,
                                title: articles[index].title,
                                description: articles[index].description,
                                url: articles[index].url,
                              );
                            },
                          ),
                        ),
                ),
                SwipeUp(
                  onSwipe: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ArticleView(
                              articleUrl: articles[pageIndex].url,
                            )));
                  },
                  child: Container(child: Text('Swipe Up')),
                  body: Container(  
                    width: MediaQuery.of(context).size.width,
                    height: 80,
                  )
                  // body: Container(
                  //   margin: EdgeInsets.only(top: 40),
                  //   alignment: Alignment.center,
                  //   child: Column(
                  //     children: [
                  //       // Icon(
                  //       //   Icons.keyboard_arrow_up,
                  //       //   color: upIconColor,
                  //       //   size: 40,
                  //       // ),
                  //       Text('Swipe Up',
                  //           style: r.style(upIconColor, 14, 'Poppins')),
                  //     ],
                  //   ),
                  // ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
