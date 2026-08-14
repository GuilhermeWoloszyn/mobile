import 'package:flutter/material.dart';
import '../core/theme/theme_extensions.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ItineraryPage(),
    );
  }
}

class ItineraryPage extends StatelessWidget {
  const ItineraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Scaffold(
      backgroundColor: colors.fundoTela,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: const [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  ItineraryHeader(),

                  Positioned(
                    left: 16,
                    right: 16,
                    bottom: -48,
                    child: InfoItinerary(),
                  ),
                ],
              ),

              SizedBox(height: 62),

              AssessmentStar(),

              PhotoItinerary(),

              DescriptionItinerary(),

              BtnActionItinerary(),
            ],
          ),
        ),
      ),
    );
  }
}

class ItineraryHeader extends StatelessWidget {
  const ItineraryHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return SizedBox(
      height: 274,
      width: double.infinity,
      child: Stack(
        children: [
          Image.asset(
            'lib/image/itinerary/imagem_trilha.png',
            height: 274,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Container(
            height: 274,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, colors.sombra],
              ),
            ),
          ),
          Positioned(
            left: 16,
            bottom: 50,
            child: Text(
              'Tirolesa\nIbirama - SC',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                color: colors.branco,
                fontSize: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class InfoItinerary extends StatelessWidget {

  final List<InfoItem> items;

  const InfoItinerary({
    super.key,
    this.items = const [
      InfoItem(
        icon: Icons.hiking,
        label: 'Trilha',
        value: 'Fácil',

      ),
      InfoItem(
        icon: Icons.add_location_rounded,
        label: 'Distância',
        value: '1,7 km',
      ),
      InfoItem(
        icon: Icons.terrain,
        label: 'Elevação',
        value: '170 m',
      ),
    ],
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      height: 86,
      width: double.infinity,
      decoration: BoxDecoration(
        color: colors.cinzaTerciario,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: _buildItems(),
      ),
    );
  }

  List<Widget> _buildItems() {
    final widgets = <Widget>[];

    for (int i = 0; i < items.length; i++) {
      if (i > 0) {
        widgets.add(const Divider());
      }

      widgets.add(
        Expanded(
          child: IndividualItem(
            data: items[i],
          ),
        ),
      );
    }

    return widgets;
  }
}

class InfoItem {
  final IconData? icon;
  final String label;
  final String? value;
  final InfoIconType iconType;

  const InfoItem({
    this.icon,
    required this.label,
    this.value,
    this.iconType = InfoIconType.facil,
  });
}

class IndividualItem extends StatelessWidget {
  final InfoItem data;

  const IndividualItem({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    Color getIconColor() {
      switch (data.value) {
        case 'Fácil':
          return colors.dificuldadeFacil;
        case 'Médio':
          return colors.dificuldadeMedio;
        case 'Difícil':
          return colors.dificuldadeDificil;
        case 'Extremo':
          return colors.dificuldadeExtremo;
        case 'Kids':
          return colors.dificuldadeKids;
        default:
          return colors.icones;
      }
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (data.icon != null) ...[
          Icon(
            data.icon,
            color: getIconColor(),
            size: 28,
          ),
          const SizedBox(height: 4),
        ],

        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            data.label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: colors.fonteDefault,
              fontSize: 13,
            ),
          ),
        ),

        if (data.value != null) ...[
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              data.value!,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colors.branco,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class Divider extends StatelessWidget {
  const Divider({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      width: 1,
      height: 44,
      color: colors.barra,
    );
  }
}

class AssessmentStar extends StatelessWidget{
  const AssessmentStar({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Row(
              children: [
                Icon(
                  Icons.star,
                  color: Colors.amberAccent,
                  size: 20,
                ),
                Icon(
                  Icons.star,
                  color: Colors.amberAccent,
                  size: 20,
                ),
                Icon(
                  Icons.star,
                  color: Colors.amberAccent,
                  size: 20,
                ),
                Icon(
                  Icons.star,
                  color: Colors.amberAccent,
                  size: 20,
                ),
                Icon(
                  Icons.star,
                  color: Colors.white,
                  size: 20,
                ),
              ],
            ),

            SizedBox(width: 10),

            Text(
              '4,0 (21)',
              style: TextStyle(
                color: colors.fonteDefault,
                fontWeight: FontWeight.w800,
                fontSize: 10,
              ),
            )
          ],
        )
    );
  }
}

class PhotoItinerary extends StatelessWidget{
  const PhotoItinerary({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: 16, vertical: 24),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: ImageConf(
                image: 'lib/image/itinerary/tirolesa_01.jpg',
                height: 200,
            ),
          ),

          const SizedBox(width: 6),

          Expanded(
            flex: 2,
            child: Column(
              children: const [
                ImageConf(
                  image: 'lib/image/itinerary/tirolesa_02.jpg',
                  height: 97,
                ),

                SizedBox(height: 6),

                ImageConf(
                  image: 'lib/image/itinerary/tirolesa_03.jpg',
                  height: 97,
                ),
              ],
            ),
          ),
        ],
      )
    );
  }
}

class ImageConf extends StatelessWidget{
  final String image;
  final double height;

  const ImageConf({
    super.key,
    required this.image,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadiusGeometry.circular(3),
      child: Image.asset(
        image,
        height: height,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }

}

class DescriptionItinerary extends StatelessWidget{
  const DescriptionItinerary({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Padding(padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Informações',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: colors.fonteDefault
              ),
            ),

            SizedBox(height: 18),

            Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas semper nisl ut arcu rhoncus, eu gravida odio varius. Fusce suscipit condimentum rhoncus. Mauris lacinia iaculis urna a congue. Nulla porta metus erat, a pretium orci pulvinar sit amet. Vivamus vel bibendum ante. Nam fermentum nulla mi, id feugiat quam blandit id. Sed ultricies tincidunt viverra. ',
              textAlign: TextAlign.justify,
              softWrap: true,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: colors.fonteDefault,
              ),
            ),
          ],
      )
    );
  }
}

class BtnActionItinerary extends StatelessWidget{
  const BtnActionItinerary({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ActionBtn(icon: Icons.favorite_border),
          SizedBox(width: 51),
          ActionBtn(icon: Icons.add),
          SizedBox(width: 51),
          ActionBtn(icon: Icons.mode_comment_outlined),
        ],
      ),
    );
  }

}

class ActionBtn extends StatelessWidget{
  final IconData icon;

  const ActionBtn({
    super.key,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      width: 44,
      height: 44,
      decoration:  BoxDecoration(
        color: colors.cinzaPrincipal,
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: colors.icones,
        size: 24,
      ),
    );
  }


}

enum InfoIconType {
  facil,
  medio,
  dificil,
  extremo,
  kids,
}

