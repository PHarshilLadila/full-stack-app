import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  final VoidCallback? onMenuTap;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onFavouriteTap;

  final bool showMenu;
  final bool showNotification;
  final bool showFavourite;

  final Color backgroundColor;
  final Color iconColor;
  final Color titleColor;

  const CustomAppBar({
    super.key,
    required this.title,
    this.onMenuTap,
    this.onNotificationTap,
    this.onFavouriteTap,
    this.showMenu = true,
    this.showNotification = true,
    this.showFavourite = true,
    this.backgroundColor = Colors.transparent,
    this.iconColor = Colors.black,
    this.titleColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      elevation: 0,
      automaticallyImplyLeading: false,
      leadingWidth: showMenu ? 60 : 0,
      leading:
          showMenu
              ? Builder(
                builder: (context) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 20, top: 20),
                    child: Material(
                      color: Colors.transparent,
                      shape: const CircleBorder(),
                      clipBehavior: Clip.hardEdge,
                      child: InkWell(
                        onTap:
                            onMenuTap ??
                            () {
                              Scaffold.of(context).openDrawer();
                            },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.grey, width: 0.6),
                          ),
                          child: HugeIcon(
                            color: iconColor,
                            icon: HugeIcons.strokeRoundedMenu02,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              )
              : null,
      title: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 26,
            color: titleColor,
          ),
        ),
      ),
      centerTitle: true,
      actions: [
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Row(
            children: [
              if (showNotification)
                IconButton(
                  visualDensity: VisualDensity.compact,
                  hoverColor: Colors.transparent,
                  color: Colors.transparent,
                  focusColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  disabledColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: onNotificationTap,
                  icon: HugeIcon(
                    icon: HugeIcons.strokeRoundedNotification01,
                    color: iconColor,
                  ),
                ),
              if (showNotification && showFavourite) const SizedBox(width: 12),
              if (showFavourite)
                IconButton(
                  visualDensity: VisualDensity.compact,
                  hoverColor: Colors.transparent,
                  color: Colors.transparent,
                  focusColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  disabledColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: onFavouriteTap,
                  icon: HugeIcon(
                    icon: HugeIcons.strokeRoundedFavourite,
                    color: iconColor,
                  ),
                ),
              const SizedBox(width: 16),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(90);
}
