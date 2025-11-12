import 'package:flutter/material.dart';
import '../state/view_data.dart';

class AppStateWidget<T> extends StatelessWidget {
  final ViewData<T> viewData;
  final Widget Function(T data) onHasData;
  final VoidCallback? onRetry;
  final Future<void> Function()? onRefresh;

  const AppStateWidget({
    super.key,
    required this.viewData,
    required this.onHasData,
    this.onRetry,
    this.onRefresh,
  });

  bool _isScrollView(Widget w) => w is ScrollView || w is CustomScrollView;

  @override
  Widget build(BuildContext context) {
    switch (viewData.state) {
      case ViewState.loading:
        return const Center(child: CircularProgressIndicator());
      case ViewState.error:
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(viewData.message ?? 'Something went wrong'),
              const SizedBox(height: 8),
              if (onRetry != null)
                ElevatedButton(
                  onPressed: onRetry,
                  child: const Text('Retry'),
                ),
            ],
          ),
        );
      case ViewState.noData:
        return Center(child: Text(viewData.message ?? 'No Data'));
      case ViewState.hasData:
        final data = viewData.data as T;
        final Widget child = onHasData(data);

        if (onRefresh == null) {
          return child;
        }

        if (_isScrollView(child)) {
          return RefreshIndicator(
            onRefresh: onRefresh!,
            child: child,
          );
        }

        return RefreshIndicator(
          onRefresh: onRefresh!,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final minHeight = constraints.maxHeight;
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: minHeight),
                  child: IntrinsicHeight(
                    child: child,
                  ),
                ),
              );
            },
          ),
        );
      case ViewState.initial:
        return const SizedBox.shrink();
    }
  }
}
