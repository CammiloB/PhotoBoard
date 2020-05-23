import 'color/light_color.dart';
import 'utils/margin.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:photoboard/matter/image.dart';
import 'styles.dart';

class GlobalSituationCard extends StatelessWidget {
  final String percentChange;
  final Icon icon;
  final Color color;
  final Color cardColor;
  final String url;


  const GlobalSituationCard(
      {Key key,
      @required this.percentChange,
      this.icon,
      this.cardColor = CardColors.green,
      @required this.color,
      @required this.url})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    DecorationImage backgroundPhoto = new DecorationImage(
      image: new NetworkImage(this.url),
      fit: BoxFit.cover,
    );

    return GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => ImagePage(
                      imageUrl: this.url,
                    )),
          );
        },
        child: Stack(
          children: <Widget>[
            Container(
              child: Column(
                children: <Widget>[
                  Container(
                    width: screenWidth(context),
                    height: screenHeight(context, percent: 0.3),
                    margin: EdgeInsets.symmetric(horizontal: 25),
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      image: backgroundPhoto,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.18),
                            blurRadius: 20,
                            spreadRadius: 3.5,
                            offset: Offset(0, 13)),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              height: 40,
                              margin: EdgeInsets.all(15),
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 17),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: CardColors.transparentBlack,
                                  borderRadius: BorderRadius.circular(5)),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Row(
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  const YMargin(5),
                                ],
                              ),
                              Spacer(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  const YMargin(5),
                                ],
                              ),
                              Spacer(),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Column(
                children: <Widget>[
                  const YMargin(115),
                  Container(
                    width: 58,
                    height: 58,
                    margin: EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 30,
                            spreadRadius: 3.5,
                            offset: Offset(0, 13)),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          percentChange,
                          style: GoogleFonts.cabin(
                            textStyle: TextStyle(
                                color: color,
                                fontWeight: FontWeight.w300,
                                fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
