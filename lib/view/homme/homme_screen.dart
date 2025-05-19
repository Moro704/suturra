import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sutura/view/homme/core/appcolor.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HommeScreen extends StatefulWidget {
  const HommeScreen({super.key});

  @override
  State<HommeScreen> createState() => _HommeScreenState();
}

class _HommeScreenState extends State<HommeScreen> {
  List<String> imagesList=[
    'assets/carou_1.jpg',
    'assets/carou_2.jpg',
    //'assets/carou_3.jpg',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
      leading: IconButton(onPressed: (){}, icon: FaIcon(FontAwesomeIcons.alignLeft,color: Appcolor.Secondecolor,),),
      actions: [
        IconButton(onPressed: (){}, icon: FaIcon(FontAwesomeIcons.commentDots,color: Appcolor.Secondecolor),),
        IconButton(onPressed: (){}, icon: FaIcon(FontAwesomeIcons.bell,color: Appcolor.Secondecolor),),
      ],
    ),
    body:Column(
      children: [
        Container(
          //height: 200,
          //width: double.infinity,
          
           child:CarouselSlider(
          options: CarouselOptions(
          height: 130,
            //enlargeCenterPage: true,
           // aspectRatio: 10.0,
            viewportFraction: 0.99,
            autoPlay: true,
      autoPlayInterval: Duration(seconds: 7), // Chaque image reste 5 sec
      autoPlayAnimationDuration: Duration(seconds: 1), // Durée de transition
      autoPlayCurve: Curves.linear,
          ),
          items:imagesList.map((item)=>Container(
          
           margin: EdgeInsets.all(5),
            child: Image.asset(item,fit: BoxFit.cover, width: 1000.0,),
          )).toList(),
        )
        ),
       
      ],
    ) ,
    );
  }
}
