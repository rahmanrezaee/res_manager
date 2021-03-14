import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ResponsiveScaffold extends StatelessWidget {
  const ResponsiveScaffold({
    this.scaffoldKey,
    this.drawer,
    this.endDrawer,
    // this.title,
    this.body,
    // this.trailing,
    this.floatingActionButton,
    // this.menuIcon,
    // this.endIcon,
    this.kTabletBreakpoint = 720.0,
    this.kDesktopBreakpoint = 1440.0,
    // this.appBarElevation,
    this.appBar,
  });

  final Widget drawer, endDrawer;
  final Widget appBar;
  // final Widget title;

  final Widget body;

  // final Widget trailing;

  final Widget floatingActionButton;

  final kTabletBreakpoint;
  final kDesktopBreakpoint;
  final _drawerWidth = 200.0;

  // final IconData menuIcon, endIcon;

  // final double appBarElevation;

  final Key scaffoldKey;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        if (constraints.maxWidth >= kDesktopBreakpoint) {
          return Material(
            child: Stack(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    if (drawer != null) ...[
                      SizedBox(
                        width: _drawerWidth,
                        child: Drawer(
                          child: SafeArea(
                            child: drawer,
                          ),
                        ),
                      ),
                    ],
                    Expanded(
                      child: Scaffold(
                        key: scaffoldKey,
                        appBar: appBar,
                        body: Row(
                          children: <Widget>[
                            Expanded(
                              child: body ?? Container(),
                            ),
                            if (endDrawer != null) ...[
                              Container(
                                width: _drawerWidth,
                                child: Drawer(
                                  elevation: 3.0,
                                  child: SafeArea(
                                    child: endDrawer,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                if (floatingActionButton != null) ...[
                  Positioned(
                    top: 100.0,
                    left: _drawerWidth - 30,
                    child: floatingActionButton,
                  )
                ],
              ],
            ),
          );
        }
        if (constraints.maxWidth >= kTabletBreakpoint) {
          return Scaffold(
            key: scaffoldKey,
            drawer: drawer == null
                ? null
                : Drawer(
                    child: SafeArea(
                      child: drawer,
                    ),
                  ),
            appBar: appBar,
            // appBar: AppBar(
            //   elevation: appBarElevation,
            //   automaticallyImplyLeading: false,
            //   title: title,
            //   leading: _MenuButton(iconData: menuIcon),
            //   actions: <Widget>[
            //     if (trailing != null) ...[
            //       trailing,
            //     ],
            //   ],
            // ),
            body: SafeArea(
              right: false,
              bottom: false,
              child: Stack(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: body ?? Container(),
                      ),
                      if (endDrawer != null) ...[
                        Container(
                          width: _drawerWidth,
                          child: Drawer(
                            elevation: 3.0,
                            child: SafeArea(
                              child: endDrawer,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (floatingActionButton != null) ...[
                    Positioned(
                      top: 10.0,
                      left: 10.0,
                      child: floatingActionButton,
                    )
                  ],
                ],
              ),
            ),
          );
        }
        return OrientationBuilder(
            builder: (BuildContext context, Orientation orientation) {
          if (orientation == Orientation.landscape) {
            SystemChrome.setEnabledSystemUIOverlays([]);
          } else {
            SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
          }
          return Scaffold(
            key: scaffoldKey,
            drawer: drawer == null
                ? null
                : Drawer(
                    child: SafeArea(
                      child: drawer,
                    ),
                  ),
            endDrawer: endDrawer == null
                ? null
                : Drawer(
                    child: SafeArea(
                      child: endDrawer,
                    ),
                  ),
            appBar: appBar,
            // appBar: AppBar(
            //   elevation: appBarElevation,
            //   automaticallyImplyLeading: false,
            //   leading: _MenuButton(iconData: menuIcon),
            //   title: title,
            //   actions: <Widget>[
            //     if (trailing != null) ...[
            //       trailing,
            //     ],
            //     if (endDrawer != null) ...[
            //       _OptionsButton(iconData: endIcon),
            //     ]
            //   ],
            // ),
            body: AnnotatedRegion<SystemUiOverlayStyle>(
                value: SystemUiOverlayStyle.light, child: body),
            floatingActionButton: floatingActionButton,
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          );
        });
      },
    );
  }
}

class _OptionsButton extends StatelessWidget {
  const _OptionsButton({
    Key key,
    @required this.iconData,
  }) : super(key: key);

  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(iconData ?? Icons.more_vert),
      onPressed: () {
        Scaffold.of(context).openEndDrawer();
      },
    );
  }
}

class _MenuButton extends StatelessWidget {
  const _MenuButton({
    Key key,
    @required this.iconData,
  }) : super(key: key);

  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(iconData ?? Icons.menu),
      onPressed: () {
        Scaffold.of(context).openDrawer();
      },
    );
  }
}
