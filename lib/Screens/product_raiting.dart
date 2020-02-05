import 'package:flutter/material.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pfe/Component/horisontale_list.dart';
import 'package:pfe/Screens/Home.dart';
import 'package:pfe/Screens/logIn_screen.dart';
import 'package:pfe/api/like_api.dart';
import 'package:pfe/api/reviews.dart';
import 'package:pfe/like/like.dart';
import 'package:pfe/main.dart';
import 'package:pfe/review/product_review.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:titled_navigation_bar/titled_navigation_bar.dart';
import 'package:rating_bar/rating_bar.dart';
import 'package:pfe/api/cart_api.dart';
class ProductRaiting extends StatefulWidget {
   final productId ;

   ProductRaiting(this.productId);

   @override
  _ProductRaitingState createState() => _ProductRaitingState();
}

class _ProductRaitingState extends State<ProductRaiting> {

  ReviewApi reviewApi = ReviewApi();
  bool isExpandedreview = false ;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: FutureBuilder(
          future: reviewApi.fetchReviews(widget.productId, 10),
            builder: (BuildContext context, AsyncSnapshot<List<ProductReview>> snapShot) {
              switch (snapShot.connectionState) {
                case ConnectionState.none:
                  __error('no connection!!!');
                  break;
                case ConnectionState.waiting:
                case ConnectionState.active:
                  return _showLoading();
                  break;
                case ConnectionState.done:
                  if (snapShot.hasError) {
                    return __error(snapShot.error.toString());
                  } else {
                    return ListView.builder(
                      itemCount: snapShot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return _review(snapShot.data[index]);
                      },
                    );
                  }
                  break;
              }
              return Container();
            },
        )
      ),
      );
  }


  __error(String error) {
    return Container(
      child: Center(
        child: Text(error),
      ),
    );
  }
  Widget _showLoading(){
    return Container(
      child:Center(
        child: CircularProgressIndicator(),
      ) ,
    );
  }

  _review(ProductReview productReview ){
    String st = productReview.stars.toString();
    String review = productReview.review ;
    return Container(
      //  height: 150.0,
      child: Card(
        child:ListTile(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: RatingBar.readOnly(
                      initialRating: double.parse(st),
                      isHalfAllowed: true,
                      halfFilledIcon: Icons.star_half,
                      filledIcon: Icons.star,
                      emptyIcon: Icons.star_border,
                      size: 15.0,
                      filledColor: Colors.amber,
                      emptyColor: Colors.grey.shade300,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: 8.0,
                    right: 8.0),
                child: AnimatedCrossFade(
                  firstChild: Text(
                    review,
                    maxLines: 1,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 13.0
                      //    fontSize: screenAwareSize(10.0, context),
                      //  fontFamily: "Montserrat-Medium"
                    ),
                  ),
                  secondChild: Text(
                    review,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.0
                      // fontFamily: "Montserrat-Medium"
                    ),
                  ),
                  crossFadeState: isExpandedreview
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: kThemeAnimationDuration,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: 8.0,
                    right: 8.0),
                child: GestureDetector(
                    onTap: _expandReview,
                    child: Text(
                      isExpandedreview ? "less" : "more..",
                      style: TextStyle(
                          color: Color(0xFF01B2C4), fontWeight: FontWeight.w700),
                    )),
              ),
            ],
          ),
          subtitle: Padding(
            padding:  EdgeInsets.only(
                left: 8.0,
                right: 8.0 ),
            child: Text('By  '+ productReview.reviewer.last_name),
          ),
        ) ,
      ),
    );
  }

  void _expandReview() {
    setState(() {
      isExpandedreview ? isExpandedreview = false : isExpandedreview = true;
    });
  }

}