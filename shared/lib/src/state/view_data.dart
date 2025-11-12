enum ViewState { initial, loading, error, hasData, noData }

extension ViewStateExtension on ViewState {
  bool get isInitial => this == ViewState.initial;
  bool get isLoading => this == ViewState.loading;
  bool get isError => this == ViewState.error;
  bool get isHasData => this == ViewState.hasData;
  bool get isNoData => this == ViewState.noData;
}

class ViewData<T> {
  final ViewState state;
  final T? data;
  final String? message;

  const ViewData._({required this.state, this.data, this.message});

  factory ViewData.initial() => const ViewData._(state: ViewState.initial);
  factory ViewData.loading() => const ViewData._(state: ViewState.loading);
  factory ViewData.error(String message) =>
      ViewData._(state: ViewState.error, message: message);
  factory ViewData.noData([String? message]) =>
      ViewData._(state: ViewState.noData, message: message);
  factory ViewData.hasData(T data) =>
      ViewData._(state: ViewState.hasData, data: data);
}
