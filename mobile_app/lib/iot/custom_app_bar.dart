part of 'metrics_page.dart';

class _CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  const _CustomAppBar();

  @override
  Widget build(BuildContext context) => AppBar(
        title: _buildTitle(),
        centerTitle: true,
      );

  Widget _buildTitle() => const Text(_text);

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);
}

const _text = 'Actual Metrics';
