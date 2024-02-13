enum ModalResults { ok, cancel }

class DialogResult<T> {
  T? value;

  final ModalResults result;

  DialogResult({this.value, required this.result});
  
}
