import 'dart:math' as math;

import 'package:flutter/material.dart';

class PageTemplate extends StatefulWidget {
  final String title;
  final Widget body;
  final Widget? floatingActionButton;
  const PageTemplate({
    super.key,
    required this.title,
    required this.body,
    this.floatingActionButton,
  });

  @override
  State<PageTemplate> createState() => _PageTemplateState();
}

class _PageTemplateState extends State<PageTemplate> {
  static const _kBasePadding = 16.0;
  static const kExpandedHeight = 150.0;
  final ValueNotifier<double> _titlePaddingNotifier = ValueNotifier(_kBasePadding);
  final _scrollController = ScrollController();

  double get _horizontalTitlePadding {
    const kCollapsedPadding = 60.0;

    if (_scrollController.hasClients) {
      return math.min(_kBasePadding + kCollapsedPadding,
          _kBasePadding + (kCollapsedPadding * _scrollController.offset) / (kExpandedHeight - kToolbarHeight));
    }

    return _kBasePadding;
  }

  @override
  void initState() {
    super.initState();
    if (Navigator.of(context).canPop()) {
      _scrollController.addListener(() {
        _titlePaddingNotifier.value = _horizontalTitlePadding;
      });
    }
  }

  @override
  void dispose() {
    _titlePaddingNotifier.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: widget.floatingActionButton,
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              pinned: true,
              expandedHeight: kExpandedHeight,
              elevation: 0,
              backgroundColor: Theme.of(context).colorScheme.surface,
              surfaceTintColor: Theme.of(context).colorScheme.surface,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                centerTitle: false,
                expandedTitleScale: 1.5,
                titlePadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                title: ValueListenableBuilder(
                  valueListenable: _titlePaddingNotifier,
                  builder: (context, value, child) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: value),
                      child: Text(widget.title),
                    );
                  },
                ),
              ),
            ),
          ];
        },
        body: widget.body,
      ),
    );
  }
}
