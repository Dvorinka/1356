import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  final String? title;
  final Widget body;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final Widget? bottomNavigationBar;

  const AppScaffold({
    super.key,
    this.title,
    required this.body,
    this.actions,
    this.floatingActionButton,
    this.showBackButton = false,
    this.onBackPressed,
    this.bottomNavigationBar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: title != null
          ? AppBar(
              title: Text(title!),
              centerTitle: true,
              automaticallyImplyLeading: showBackButton,
              leading: showBackButton
                  ? IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: onBackPressed ?? () => Navigator.pop(context),
                    )
                  : null,
              actions: actions,
            )
          : null,
      body: body,
      extendBodyBehindAppBar: true,
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
