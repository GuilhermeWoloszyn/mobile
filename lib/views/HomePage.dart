import 'package:flutter/material.dart';
import '../core/theme/theme_extensions.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: HomePage());
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Scaffold(
      backgroundColor: colors.fundoTela,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                HomeHeader(),
                SizedBox(height: 24),
                ResearchArea(),
                SizedBox(height: 24),
                Category(),
                SizedBox(height: 24),
                Attraction(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Olá',
              style: TextStyle(fontSize: 20, color: colors.fonteDefault),
            ),
            Text(
              'Analice',
              style: TextStyle(
                fontSize: 32,
                color: colors.fonteDestaque,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const Spacer(),
        Icon(Icons.wifi, color: colors.icones, size: 24),
      ],
    );
  }
}

class ResearchArea extends StatelessWidget {
  const ResearchArea({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Row(
      children: [
        Expanded(
          child: Container(
            height: 36,
            padding: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: colors.barra,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Encontrar trilhas',
                style: TextStyle(
                  fontSize: 15,
                  color: colors.cinzaSecundaria,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 8),
        Container(
          height: 36,
          width: 36,
          decoration: BoxDecoration(
            color: colors.barra,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Icon(Icons.filter_alt_outlined, color: colors.cinzaSecundaria),
        ),
      ],
    );
  }
}

class Category extends StatelessWidget {
  const Category({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Categorias',
          style: TextStyle(
            fontSize: 24,
            color: colors.cinzaPrincipal,
            fontWeight: FontWeight.w500,
          ),
        ),

        const SizedBox(height: 16),

        SizedBox(
          height: 150,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: const [
              CategoryCard(
                imagePath: 'lib/image/category/trilhas.png',
                title: 'Trilhas',
              ),

              SizedBox(width: 10),

              CategoryCard(
                imagePath: 'lib/image/category/cachoeiras.png',
                title: 'Cachoeiras',
              ),

              SizedBox(width: 10),

              CategoryCard(
                imagePath: 'lib/image/category/museus.png',
                title: 'Museus',
              ),

              SizedBox(width: 10),

              CategoryCard(
                imagePath: 'lib/image/category/eventos.png',
                title: 'Eventos',
              ),

              SizedBox(width: 10),

              CategoryCard(
                imagePath: 'lib/image/category/natureza.png',
                title: 'Natureza',
              ),

              SizedBox(width: 10),

              CategoryCard(
                imagePath: 'lib/image/category/acao_comunitaria.png' ,
                title: 'Ação comunitária',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String imagePath;
  final String title;

  const CategoryCard({super.key, required this.imagePath, required this.title});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return SizedBox(
      width: 100,
      height: 120,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              imagePath,
              height: 89,
              width: 100,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(height: 8),

          SizedBox(
            width: 100,
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: colors.fonteDefault,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Attraction extends StatelessWidget {
  const Attraction({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Atrações em destaque',
          style: TextStyle(
            fontSize: 24,
            color: colors.cinzaPrincipal,
            fontWeight: FontWeight.w500,
          ),
        ),

        const SizedBox(height: 16),

        LayoutBuilder(
          builder: (context, constraints) {
            final cardWidth = constraints.maxWidth * 0.78;
            final cardHeight = cardWidth * 0.82;

            return SizedBox(
              height: cardHeight,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: 3,
                separatorBuilder: (context, index) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
                  final attractions = [
                    {
                      'image': 'lib/image/attraction/tirolesa.png',
                      'title': 'Tirolesa',
                    },
                    {
                      'image': 'lib/image/attraction/cachoeira.png',
                      'title': 'Cachoeira Degrau',
                    },
                    {
                      'image': 'lib/image/attraction/museu.png',
                      'title': 'Museu Municipal',
                    },
                    {
                      'image': 'lib/image/attraction/hospital.png',
                      'title': 'Hospital Habsahoehe',
                    },
                  ];

                  return AttractionCard(
                    imagePath: attractions[index]['image']!,
                    title: attractions[index]['title']!,
                    width: cardWidth,
                    height: cardHeight,
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}

class AttractionCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final double width;
  final double height;

  const AttractionCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return SizedBox(
      width: width,
      height: height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              imagePath,
              fit: BoxFit.cover,
            ),

            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.56),
                  ],
                ),
              ),
            ),

            Positioned(
              left: 20,
              right: 20,
              bottom: 18,
              child: Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 28,
                  color: colors.branco,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
