import 'package:flutter/material.dart';
import '../core/theme/theme_extensions.dart';
import 'CardboardWaterfall.dart';

// Importe cada página de trilha aqui conforme for criando os arquivos
// (mesma estrutura do ItineraryPage.dart, textos/fotos/coordenadas trocados):
//
// import 'CachoeiraPapelaoPage.dart';
// import 'SalaoAtiradoresPage.dart';
// import 'AtafonaRodaDaguaPage.dart';
// import 'CachoeiraSerrariaPage.dart';
// import 'TrekkingSteinWasserfallPage.dart';
// import 'Trilha1Page.dart';
// import 'Cachoeira1Page.dart';

class RoadPage extends StatelessWidget {
  const RoadPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    final trails = <TrailData>[
      TrailData(
        title: 'Cachoeira do Papelão',
        imagePath: 'lib/image/trails/cachoeira_papelao.jpg',
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CardboardWaterfall()),
        ),
      ),
      TrailData(
        title: 'Salão de Atiradores',
        imagePath: 'lib/image/trails/salao_atiradores.jpg',
        // onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SalaoAtiradoresPage())),
      ),
      TrailData(
        title: "Atafona Roda d'Água",
        imagePath: 'lib/image/trails/atafona_roda_dagua.jpg',
        // onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AtafonaRodaDaguaPage())),
      ),
      TrailData(
        title: 'Cachoeira da Serraria',
        imagePath: 'lib/image/trails/cachoeira_serraria.jpg',
        // onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CachoeiraSerrariaPage())),
      ),
      TrailData(
        title: 'Trilha 1',
        imagePath: 'lib/image/trails/trilha_1.jpg',
        // onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const Trilha1Page())),
      ),
      TrailData(
        title: 'Cachoeira 1',
        imagePath: 'lib/image/trails/cachoeira_1.jpg',
        // onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const Cachoeira1Page())),
      ),
    ];

    return Scaffold(
      backgroundColor: colors.fundoTela,
      appBar: AppBar(
        backgroundColor: colors.fundoTela,
        elevation: 0,
        foregroundColor: colors.fonteDefault,
        title: Text(
          'Trilhas',
          style: TextStyle(
            color: colors.fonteDefault,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: trails.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) => TrailListCard(data: trails[index]),
        ),
      ),
    );
  }
}

class TrailData {
  final String title;
  final String imagePath;
  final VoidCallback? onTap;

  const TrailData({
    required this.title,
    required this.imagePath,
    this.onTap,
  });
}

class TrailListCard extends StatelessWidget {
  final TrailData data;

  const TrailListCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Material(
      color: colors.cinzaTerciario,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: data.onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  data.imagePath,
                  width: 72,
                  height: 72,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 72,
                    height: 72,
                    color: colors.barra,
                    child: Icon(
                      Icons.image_not_supported_outlined,
                      color: colors.cinzaSecundaria,
                      size: 28,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  data.title,
                  style: TextStyle(
                    color: colors.branco,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: colors.icones,
              ),
            ],
          ),
        ),
      ),
    );
  }
}