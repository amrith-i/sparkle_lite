import 'dart:io';

void main(List<String> args) {
  if (args.length < 2) {
    print(
      '❌ Usage: dart run tools/create_feature.dart <feature_name> <base_path>',
    );
    print(
      '   Example: dart run tools/create_feature.dart credit lib/features/central_kitchen/outlet',
    );
    exit(1);
  }

  if (!File('pubspec.yaml').existsSync()) {
    print('❌ Error: Run this script from the project root directory');
    print('   cd /your/project/root');
    print('   dart run tools/create_feature.dart <feature_name> <base_path>');
    exit(1);
  }

  final featureName = args[0].toLowerCase().trim();
  final className = _toPascalCase(featureName);
  final basePath = '${args[1]}/$featureName';

  final packagePath = args[1].replaceFirst('lib/', '');
  final featureImport =
      "import 'package:app/$packagePath/$featureName/$featureName.dart';";

  if (Directory(basePath).existsSync()) {
    print('❌ Error: Feature "$featureName" already exists at $basePath');
    exit(1);
  }

  print('🚀 Creating feature: $featureName');

  _createFile(
    '$basePath/data/datasources/${featureName}_remote_datasource.dart',
    '''import 'package:app/core_import.dart';
$featureImport

abstract class ${className}RemoteDatasource {
  // TODO: define datasource contracts
}
''',
  );

  _createFile(
    '$basePath/data/datasources/${featureName}_remote_datasource_impl.dart',
    '''import 'package:app/core_import.dart';
$featureImport

@LazySingleton(as: ${className}RemoteDatasource)
class ${className}RemoteDatasourceImpl implements ${className}RemoteDatasource {
  final Dio dio;

  ${className}RemoteDatasourceImpl(this.dio);
}
''',
  );

  _createFile(
    '$basePath/data/datasources/datasources.dart',
    '''export '${featureName}_remote_datasource.dart';
export '${featureName}_remote_datasource_impl.dart';
''',
  );

  _createFile('$basePath/data/dto/dto.dart', '// export your dtos here\n');

  _createFile(
    '$basePath/data/repositories/${featureName}_repository_impl.dart',
    '''import 'package:app/core_import.dart';
$featureImport

@LazySingleton(as: ${className}Repository)
class ${className}RepositoryImpl extends BaseRepository
    implements ${className}Repository {
  final ${className}RemoteDatasource remote;

  ${className}RepositoryImpl(super.dio, this.remote);
}
''',
  );

  _createFile(
    '$basePath/data/repositories/repositories.dart',
    "export '${featureName}_repository_impl.dart';\n",
  );

  _createFile(
    '$basePath/data/data.dart',
    '''export 'datasources/datasources.dart';
export 'dto/dto.dart';
export 'repositories/repositories.dart';
''',
  );

  _createFile(
    '$basePath/domain/entities/entities.dart',
    '// export your entities here\n',
  );

  _createFile(
    '$basePath/domain/repositories/${featureName}_repository.dart',
    '''import 'package:app/core_import.dart';
$featureImport

abstract class ${className}Repository {
  // TODO: define repository contracts
}
''',
  );

  _createFile(
    '$basePath/domain/repositories/repositories.dart',
    "export '${featureName}_repository.dart';\n",
  );

  _createFile(
    '$basePath/domain/usecases/params/params.dart',
    '// export your params here\n',
  );

  _createFile(
    '$basePath/domain/usecases/usecases.dart',
    "export 'params/params.dart';\n",
  );

  _createFile(
    '$basePath/domain/domain.dart',
    '''export 'entities/entities.dart';
export 'repositories/repositories.dart';
export 'usecases/usecases.dart';
''',
  );

  _createFile(
    '$basePath/presentation/bloc/${featureName}_event.dart',
    '''import 'package:app/core_import.dart';
$featureImport

abstract class ${className}Event extends Equatable {
  const ${className}Event();

  @override
  List<Object?> get props => [];
}
''',
  );

  _createFile(
    '$basePath/presentation/bloc/${featureName}_state.dart',
    '''import 'package:app/core_import.dart';
$featureImport

abstract class ${className}State extends Equatable {
  const ${className}State();

  @override
  List<Object?> get props => [];
}

class ${className}Initial extends ${className}State {}
''',
  );

  _createFile(
    '$basePath/presentation/bloc/${featureName}_bloc.dart',
    '''import 'package:app/core_import.dart';
$featureImport

@injectable
class ${className}Bloc extends Bloc<${className}Event, ${className}State> {
  ${className}Bloc() : super(${className}Initial()) {
    // TODO: register event handlers
  }
}
''',
  );

  _createFile(
    '$basePath/presentation/bloc/bloc.dart',
    '''export '${featureName}_bloc.dart';
export '${featureName}_event.dart';
export '${featureName}_state.dart';
''',
  );

  _createFile(
    '$basePath/presentation/pages/pages.dart',
    '// export your pages here\n',
  );

  _createFile(
    '$basePath/presentation/widgets/widgets.dart',
    '// export your widgets here\n',
  );

  _createFile(
    '$basePath/presentation/presentation.dart',
    '''export 'bloc/bloc.dart';
export 'pages/pages.dart';
export 'widgets/widgets.dart';
''',
  );

  _createFile('$basePath/$featureName.dart', '''export 'data/data.dart';
export 'domain/domain.dart';
export 'presentation/presentation.dart';
''');

  print('✅ Feature "$featureName" created successfully at $basePath');
  print('');
  print('📝 Next steps:');
  print('   1. Add your DTOs in data/dto/');
  print('   2. Add your entities in domain/entities/');
  print('   3. Add your usecases in domain/usecases/');
  print('   4. Add your pages in presentation/pages/');
  print('   5. Register bloc in your DI');
  print('   6. Add route in app_router.dart');
}

void _createFile(String path, String content) {
  final file = File(path);
  file.createSync(recursive: true);
  file.writeAsStringSync(content);
  print('  📄 $path');
}

String _toPascalCase(String input) {
  return input.split('_').map((word) {
    if (word.isEmpty) return '';
    return word[0].toUpperCase() + word.substring(1);
  }).join();
}
