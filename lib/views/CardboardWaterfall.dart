import 'package:flutter/material.dart';
import '../core/theme/theme_extensions.dart';
import '../features/trail_map/presentation/trail_map_page.dart';

// TODO: quando tiver o PDF georreferenciado + .geo.json dessa trilha,
// importe o TrailMapPage aqui e reative o onTap de "Distância" lá embaixo
// (mesmo esquema usado no ItineraryPage.dart da tirolesa).
// import '../features/trail_map/presentation/trail_map_page.dart';

class CardboardWaterfall extends StatelessWidget {
  const CardboardWaterfall({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Scaffold(
      backgroundColor: colors.fundoTela,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: const [
                  _WaterfallHeader(),
                  Positioned(
                    left: 16,
                    right: 16,
                    bottom: -48,
                    child: _WaterfallInfo(),
                  ),
                ],
              ),
              const SizedBox(height: 62),
              const _WaterfallRating(),
              const _WaterfallPhotos(),
              const _WaterfallDescription(),
              const _WaterfallActions(),
            ],
          ),
        ),
      ),
    );
  }
}

class _WaterfallHeader extends StatelessWidget {
  const _WaterfallHeader();

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return SizedBox(
      height: 274,
      width: double.infinity,
      child: Stack(
        children: [
          // reaproveitando a mesma imagem usada na miniatura do RoadPage
          Image.asset(
            'lib/image/trails/cachoeira_papelao.jpg',
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
              'Cachoeira do Papelão\nIbirama - SC',
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

class _WaterfallInfo extends StatelessWidget {
  const _WaterfallInfo();

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    final items = const [
      _InfoItem(icon: Icons.hiking, label: 'Trilha', value: 'Fácil'),
      _InfoItem(icon: Icons.add_location_rounded, label: 'Distância', value: '—'),
      _InfoItem(icon: Icons.terrain, label: 'Elevação', value: '—'),
    ];

    return Container(
      height: 86,
      width: double.infinity,
      decoration: BoxDecoration(
        color: colors.cinzaTerciario,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: _buildItems(context, items),
      ),
    );
  }

  List<Widget> _buildItems(BuildContext context, List<_InfoItem> items) {
    final widgets = <Widget>[];
    for (int i = 0; i < items.length; i++) {
      if (i > 0) widgets.add(const _InfoDivider());
      widgets.add(
        Expanded(
          child: _IndividualInfoItem(
            data: items[i],
            onTap: items[i].label == 'Distância'
                ? () => _openMap(context)
                : null,
          ),
        ),
      );
    }
    return widgets;
  }

  void _openMap(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TrailMapPage(
          pdfAsset: 'assets/maps/ibirama_tirolesa.pdf',
          geoJsonAsset: 'assets/maps/ibirama_tirolesa.geo.json',
          targetLat: -27.01509835795048,
          targetLon: -49.5177473566006,
        ),
      ),
    );
  }
}

class _InfoItem {
  final IconData? icon;
  final String label;
  final String? value;

  const _InfoItem({this.icon, required this.label, this.value});
}

class _IndividualInfoItem extends StatelessWidget {
  final _InfoItem data;
  final VoidCallback? onTap;

  const _IndividualInfoItem({required this.data, this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (data.icon != null) ...[
            Icon(data.icon, color: colors.icones, size: 28),
            const SizedBox(height: 4),
          ],
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              data.label,
              textAlign: TextAlign.center,
              style: TextStyle(color: colors.fonteDefault, fontSize: 13),
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
      ),
    );
  }
}

class _InfoDivider extends StatelessWidget {
  const _InfoDivider();

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(width: 1, height: 44, color: colors.barra);
  }
}

class _WaterfallRating extends StatelessWidget {
  const _WaterfallRating();

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    // TODO: trocar pela avaliação real dessa trilha quando tiver.
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Row(
            children: const [
              Icon(Icons.star, color: Colors.amberAccent, size: 20),
              Icon(Icons.star, color: Colors.amberAccent, size: 20),
              Icon(Icons.star, color: Colors.amberAccent, size: 20),
              Icon(Icons.star, color: Colors.white, size: 20),
              Icon(Icons.star, color: Colors.white, size: 20),
            ],
          ),
          const SizedBox(width: 10),
          Text(
            '—',
            style: TextStyle(
              color: colors.fonteDefault,
              fontWeight: FontWeight.w800,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

class _WaterfallPhotos extends StatelessWidget {
  const _WaterfallPhotos();

  @override
  Widget build(BuildContext context) {
    // Reaproveitando a mesma foto nas 3 posições por enquanto.
    // Assim que tiver mais fotos dessa cachoeira, troque os paths abaixo.
    const image = 'lib/image/trails/cachoeira_papelao.jpg';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: _ImageConf(image: image, height: 200),
          ),
          const SizedBox(width: 6),
          Expanded(
            flex: 2,
            child: Column(
              children: const [
                _ImageConf(image: image, height: 97),
                SizedBox(height: 6),
                _ImageConf(image: image, height: 97),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ImageConf extends StatelessWidget {
  final String image;
  final double height;

  const _ImageConf({required this.image, required this.height});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(3),
      child: Image.asset(
        image,
        height: height,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }
}

class _WaterfallDescription extends StatelessWidget {
  const _WaterfallDescription();

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    // TODO: trocar pela descrição real da Cachoeira do Papelão.
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Informações',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: colors.fonteDefault,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas semper nisl ut arcu rhoncus, eu gravida odio varius. Fusce suscipit condimentum rhoncus. Mauris lacinia iaculis urna a congue.',
            textAlign: TextAlign.justify,
            softWrap: true,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: colors.fonteDefault,
            ),
          ),
        ],
      ),
    );
  }
}

class _WaterfallActions extends StatelessWidget {
  const _WaterfallActions();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          _ActionBtn(icon: Icons.favorite_border),
          SizedBox(width: 51),
          _ActionBtn(icon: Icons.add),
          SizedBox(width: 51),
          _ActionBtn(icon: Icons.mode_comment_outlined),
        ],
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;

  const _ActionBtn({required this.icon});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: colors.cinzaPrincipal,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: colors.icones, size: 24),
    );
  }
}