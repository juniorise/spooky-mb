part of sound_list_view;

class _SoundTile extends StatelessWidget {
  const _SoundTile({
    Key? key,
    required this.sound,
    required this.downloaded,
    required this.index,
    required this.onTap,
    required this.viewModel,
  }) : super(key: key);

  final void Function() onTap;
  final SoundModel sound;
  final bool downloaded;
  final int index;
  final SoundListViewModel viewModel;

  double get fileSize => (sound.fileSize / 100000).roundToDouble() / 10;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Stack(
        children: [
          CircleAvatar(
            backgroundColor: M3Color.dayColorsOf(context)[index % 6 + 1],
            child: Consumer<MiniSoundPlayerProvider>(
              builder: (context, provider, child) {
                bool playing = provider.currentSound(sound.type)?.fileName == sound.fileName;
                return SpAnimatedIcons(
                  firstChild: Icon(Icons.pause, color: M3Color.of(context).onPrimary),
                  secondChild: Icon(Icons.music_note, color: M3Color.of(context).onPrimary),
                  showFirst: playing,
                );
              },
            ),
          ),
          Positioned.fill(
            child: ValueListenableBuilder<Set<String>>(
              valueListenable: viewModel.downloadingSoundsNotifier,
              builder: (context, loadings, child) {
                return AnimatedOpacity(
                  duration: ConfigConstant.fadeDuration,
                  opacity: viewModel.loading(sound) ? 1.0 : 0.0,
                  child: child!,
                );
              },
              child: Transform.scale(
                scale: 1.1,
                child: const CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          ),
        ],
      ),
      title: Text(sound.soundName.capitalize),
      subtitle: Text(plural("plural.file_size_mb", fileSize)),
      trailing: downloaded ? null : const Icon(Icons.download),
      onTap: onTap,
    );
  }
}
