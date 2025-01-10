class TabbarState {
  final int selectedIndex;
  final bool isHidden;
  final double bottomPadding;

  const TabbarState({
    this.selectedIndex = 0,
    this.bottomPadding = 24,
    this.isHidden = false,
  });

  TabbarState copyWith(
      {int? selectedIndex, double? bottomPadding, bool? isHidden}) {
    return TabbarState(
        selectedIndex: selectedIndex ?? this.selectedIndex,
        bottomPadding: bottomPadding ?? this.bottomPadding,
        isHidden: isHidden ?? this.isHidden);
  }
}
