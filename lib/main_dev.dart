import 'firebase_options/dev.dart';
import 'main.dart' as source;

void main() => source.main(firebaseOptions: DefaultFirebaseOptions.currentPlatform);
