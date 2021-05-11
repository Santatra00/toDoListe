
import 'package:flutter/material.dart';

class PageTitle extends StatelessWidget {
  PageTitle({@required this.title, this.subtitle, this.options});
  final String title;
  final String subtitle;

  final Widget options;

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: EdgeInsets.only(top: 30.0, bottom: 10.0, left: 40.0, right: 40.0),
      child: Container(
        // color: Colors.amberAccent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              //Title
              Row(
                mainAxisAlignment: (this.options != null)?MainAxisAlignment.spaceBetween:MainAxisAlignment.start,
                children: [
                  Text(
                      title,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 46.0,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2.0
                      )
                  ),
                  this.options??SizedBox(width: 1.0)
                ],
              ),

              SizedBox(height: 5.0),
              //Subtitle
              (subtitle != null)?
              Text(subtitle,
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600
                ),
              ): SizedBox(height: 18.0)
            ],
          )
      ),
    );

  }
}
