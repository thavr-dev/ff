import 'package:flutter/material.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'auth/firebase_auth/firebase_user_provider.dart';
import 'auth/firebase_auth/auth_util.dart';

import 'backend/firebase/firebase_config.dart';
import 'flutter_flow/flutter_flow_theme.dart';
import 'flutter_flow/flutter_flow_util.dart';
import 'flutter_flow/nav/nav.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GoRouter.optionURLReflectsImperativeAPIs = true;
  usePathUrlStrategy();
  await initFirebase();

  await FlutterFlowTheme.initialize();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = FlutterFlowTheme.themeMode;

  late Stream<BaseAuthUser> userStream;

  late AppStateNotifier _appStateNotifier;
  late GoRouter _router;

  final authUserSub = authenticatedUserStream.listen((_) {});

  @override
  void initState() {
    super.initState();

    _appStateNotifier = AppStateNotifier.instance;
    _router = createRouter(_appStateNotifier);
    userStream = placementFirebaseUserStream()
      ..listen((user) => _appStateNotifier.update(user));
    jwtTokenStream.listen((_) {});
    Future.delayed(
      const Duration(milliseconds: 1000),
      () => _appStateNotifier.stopShowingSplashImage(),
    );
  }

  @override
  void dispose() {
    authUserSub.cancel();

    super.dispose();
  }

  void setThemeMode(ThemeMode mode) => setState(() {
        _themeMode = mode;
        FlutterFlowTheme.saveThemeMode(mode);
      });

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Placement',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en', '')],
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: false,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: false,
      ),
      themeMode: _themeMode,
      routerConfig: _router,
    );
  }
}

class Cargo {
  String cargoId;
  double cargoWidth;
  double cargoLength;
  double cargoHeight;
  String cargoCategory; // e.g., 'heavy', 'medium,' 'light'
  String cargoType; // This will now represent the grade (e.g., Grade 3, Grade 2, Grade 1)
  String cargoDurability;
  List<double> cargoDimensions; // [x, y, z]
  int cargoPlaceCubeId; // ID of the cube where the cargo is placed

  int startX, endX, startY, endY, startZ, endZ;

  Cargo({
    required this.cargoId,
    required this.cargoWidth,
    required this.cargoLength,
    required this.cargoHeight,
    required this.cargoCategory,
    required this.cargoType,
    required this.cargoDurability,
    this.cargoDimensions = const [0, 0, 0],
    this.cargoPlaceCubeId = -1, // Default to -1, meaning not placed in any cube yet
  }) {
    updateGridIndices(10); // Initialize grid indices with default grid resolution
  }

  // Update the grid indices based on the current position
  void updateGridIndices(int gridResolution) {
    startX = (cargoDimensions[0] / gridResolution).floor();
    endX = ((cargoDimensions[0] + cargoWidth) / gridResolution).ceil();
    startY = (cargoDimensions[1] / gridResolution).floor();
    endY = ((cargoDimensions[1] + cargoLength) / gridResolution).ceil();
    startZ = (cargoDimensions[2] / gridResolution).floor();
    endZ = ((cargoDimensions[2] + cargoHeight) / gridResolution).ceil();
  }
}

import 'cargo.dart';
import 'utility.dart';

class Truck {
  String truckId;
  double truckWidth;
  double truckLength;
  double truckHeight;
  List<Cargo> cargos;
  List<Map<String, List<int>>> passes; // Store the pass system
  bool pass1Handled = false; // Flag to track Pass 1 handling
  bool pass2Handled = false; // Flag to track Pass 2 special handling
  bool pass3Handled = false; // Flag to track Pass 3 special handling
  List<Map<String, dynamic>> cubes; // List of cubes with coordinates

  Truck({
    required this.truckId,
    required this.truckWidth,
    required this.truckLength,
    required this.truckHeight,
    this.cargos = const [],
  }) : cubes = initializeCubes(truckWidth, truckLength, truckHeight),
       passes = generatePasses();

  static List<Map<String, dynamic>> initializeCubes(double width, double length, double height) {
    List<Map<String, dynamic>> cubes = [];
    double cubeWidth = width / 3;
    double cubeLength = length / 4;
    double cubeHeight = height / 3; // Assume 3 layers

    for (int z = 0; z < 3; z++) { // 3 layers
      for (int y = 0; y < 4; y++) {
        for (int x = 0; x < 3; x++) {
          int cubeId = z * 12 + y * 3 + x + 1;
          cubes.add({
            'id': cubeId,
            'bottomLeft': [x * cubeWidth, y * cubeLength, z * cubeHeight],
            'topRight': [(x + 1) * cubeWidth, (y + 1) * cubeLength, (z + 1) * cubeHeight],
            'grid': List.generate((cubeWidth / 10).ceil(), (_) => List.generate((cubeLength / 10).ceil(), (_) => List.generate((cubeHeight / 10).ceil(), (_) => false))),
            'occupied': false,
            'occupiedSpaces': [], // To keep track of occupied spaces within the cube
            'startPoint': [0, 0, 0], // Initialize the starting point for the cube
          });
        }
      }
    }
    return cubes;
  }

  static List<Map<String, List<int>>> generatePasses() {
    List<Map<String, List<int>>> passes = [];

    // Define the passes with hardcoded cube IDs
    passes.add({
      'Grade 3': [1, 2, 3, 4, 6], // Pass 1
      'Grade 2': [7, 9, 19, 21, 31, 33],
      'Grade 1': [10, 12, 22, 24, 34, 36]
    });

    passes.add({
      'Grade 3': [7, 9], // Pass 2
      'Grade 2': [13, 14, 15, 16, 18],
      'Grade 1': [10, 12, 22, 24, 34, 36]
    });

    passes.add({
      'Grade 3': [5], // Pass 3
      'Grade 2': [19, 21],
      'Grade 1': [25, 26, 27, 28, 30]
    });

    passes.add({
      'Grade 3': [10, 12], // Pass 4
      'Grade 2': [17],
      'Grade 1': [31, 33]
    });

    passes.add({
      'Grade 3': [8], // Pass 5
      'Grade 2': [22, 24],
      'Grade 1': [29]
    });

    passes.add({
      'Grade 3': [11], // Pass 6
      'Grade 2': [20],
      'Grade 1': [34, 36]
    });

    passes.add({
      'Grade 2': [23], // Pass 7
      'Grade 1': [32]
    });

    passes.add({
      'Grade 1': [35], // Pass 8
    });

    return passes;
  }

  // Method for special handling in Pass 2
  void specialHandlingPass2() {
    moveCargosToPriorityCubes(this, [7, 9], [1, 2, 3, 4, 6], 'Grade 2');
  }

  // Method for special handling in Pass 3
  void specialHandlingPass3() {
    moveCargosToPriorityCubes(this, [10, 12], [1, 2, 3, 4, 6], 'Grade 1');
  }
}

import 'cargo.dart';
import 'truck.dart';

void moveCargosToPriorityCubes(Truck truck, List<int> fromCubes, List<int> toCubes, String grade) {
  List<Cargo> cargosToMove = [];

  // Collect cargos to move
  for (var cubeId in fromCubes) {
    var cube = truck.cubes.firstWhere((cube) => cube['id'] == cubeId, orElse: () => throw Exception('Cube not found'));
    for (var cargo in cube['occupiedSpaces']) {
      if (cargo.cargoType == grade) {
        cargosToMove.add(cargo);
      }
    }
  }

  // Try to move cargos to priority cubes
  for (var cargo in cargosToMove) {
    for (var cubeId in toCubes) {
      var currentCube = truck.cubes.firstWhere((cube) => cube['id'] == cubeId, orElse: () => throw Exception('Cube not found'));
      if (canFitCargoInCube(cargo, currentCube, truck)) {
        placeCargoInCube(truck, cargo, currentCube);
        break;
      }
    }
  }

  // Remove moved cargos from original cubes
  for (var cargo in cargosToMove) {
    for (var cubeId in fromCubes) {
      var cube = truck.cubes.firstWhere((cube) => cube['id'] == cubeId, orElse: () => throw Exception('Cube not found'));
      cube['occupiedSpaces'].removeWhere((c) => c.cargoId == cargo.cargoId);
      checkAndMarkCubeOccupied(cube);
    }
  }
}

bool placeCargoInTruck(Truck truck, Cargo cargo) {
  // Special handling for Pass 1
  if (!truck.pass1Handled) {
    var pass1Cubes = truck.passes[0][cargo.cargoType];
    if (pass1Cubes != null) {
      for (var cubeId in pass1Cubes) {
        var cube = truck.cubes.firstWhere((c) => c['id'] == cubeId, orElse: () => <String, dynamic>{});
        if (cube.isNotEmpty && !cube['occupied']) {
          if (canFitCargoInCube(cargo, cube, truck)) {
            placeCargoInCube(truck, cargo, cube);
            return true; // Cargo placed successfully
          }
        }
      }
    }
    truck.pass1Handled = true;
  }

  // Special handling for Pass 2 if Pass 1 fails
  if (!truck.pass2Handled) {
    truck.specialHandlingPass2();
    truck.pass2Handled = true;

    // Try to place in Pass 2 after special handling
    var pass2Cubes = truck.passes[1][cargo.cargoType];
    if (pass2Cubes != null) {
      for (var cubeId in pass2Cubes) {
        var cube = truck.cubes.firstWhere((c) => c['id'] == cubeId, orElse: () => <String, dynamic>{});
        if (cube.isNotEmpty && !cube['occupied']) {
          if (canFitCargoInCube(cargo, cube, truck)) {
            placeCargoInCube(truck, cargo, cube);
            return true; // Cargo placed successfully
          }
        }
      }
    }
  }

  // From Pass 3 onwards
  for (int passIndex = 2; passIndex < truck.passes.length; passIndex++) {
    var currentPass = truck.passes[passIndex];
    var gradeCubes = currentPass[cargo.cargoType];

    if (gradeCubes != null) {
      for (var cubeId in gradeCubes) {
        var cube = truck.cubes.firstWhere((c) => c['id'] == cubeId, orElse: () => <String, dynamic>{});

        if (cube.isNotEmpty && !cube['occupied']) {
          if (passIndex == 2 && !truck.pass3Handled) {
            truck.specialHandlingPass3();
            truck.pass3Handled = true;
            return placeCargoInTruck(truck, cargo); // Try placing the cargo again after special handling
          } else {
            if (canFitCargoInCube(cargo, cube, truck)) {
              placeCargoInCube(truck, cargo, cube);
              return true; // Cargo placed successfully
            }
          }
        }
      }
    }
  }
  return false; // No suitable cube found
}

bool canFitCargoInCube(Cargo cargo, Map<String, dynamic> cube, Truck truck) {
  int gridResolution = 10;

  // Get the starting point for the cube
  List<int> startPoint = cube['startPoint'];

  // Try to place the cargo at the current starting point
  if (isConsecutiveSpaceAvailable(cube, startPoint[0], startPoint[1], startPoint[2], cargo, gridResolution) && hasStructuralSupport(truck, cargo, startPoint)) {
    cargo.cargoDimensions = [
      (startPoint[0] * gridResolution + cube['bottomLeft'][0]).toDouble(),
      (startPoint[1] * gridResolution + cube['bottomLeft'][1]).toDouble(),
      (startPoint[2] * gridResolution + cube['bottomLeft'][2]).toDouble()
    ];
    cargo.updateGridIndices(gridResolution);
    // Update the startPoint for the next cargo
    updateCubeStartPoint(cube, cargo, gridResolution);
    return true; // Space found
  }

  // If the starting point approach fails, start searching from (0, 0, 0)
  for (int x = 0; x <= (cube['topRight'][0] - cube['bottomLeft'][0]) / gridResolution - cargo.cargoWidth / gridResolution; x++) {
    for (int y = 0; y <= (cube['topRight'][1] - cube['bottomLeft'][1]) / gridResolution - cargo.cargoLength / gridResolution; y++) {
      for (int z = 0; z <= (cube['topRight'][2] - cube['bottomLeft'][2]) / gridResolution - cargo.cargoHeight / gridResolution; z++) {
        if (isConsecutiveSpaceAvailable(cube, x, y, z, cargo, gridResolution) && hasStructuralSupport(truck, cargo, [x, y, z])) {
          cargo.cargoDimensions = [
            (x * gridResolution + cube['bottomLeft'][0]).toDouble(),
            (y * gridResolution + cube['bottomLeft'][1]).toDouble(),
            (z * gridResolution + cube['bottomLeft'][2]).toDouble()
          ];
          cargo.updateGridIndices(gridResolution);
          // Update the startPoint for the next cargo
          updateCubeStartPoint(cube, cargo, gridResolution);
          return true; // Space found
        }
      }
    }
  }

  return false; // No fitting space found
}

bool isConsecutiveSpaceAvailable(Map<String, dynamic> cube, int startX, int startY, int startZ, Cargo cargo, int gridResolution) {
  for (int x = startX; x < startX + cargo.cargoWidth / gridResolution; x++) {
    for (int y = startY; y < startY + cargo.cargoLength / gridResolution; y++) {
      for (int z = startZ; z < startZ + cargo.cargoHeight / gridResolution; z++) {
        if (x >= cube['grid'].length || y >= cube['grid'][0].length || z >= cube['grid'][0][0].length || cube['grid'][x][y][z]) {
          return false; // Space is occupied or out of bounds
        }
      }
    }
  }
  return true; // Space is available
}

void updateCubeStartPoint(Map<String, dynamic> cube, Cargo cargo, int gridResolution) {
  // Update the starting point to the bottom-right-back corner of the placed cargo
  cube['startPoint'] = [
    cargo.startX + ((cargo.cargoWidth / gridResolution).ceil()),
    cargo.startY,
    cargo.startZ
  ];

  // Check if the updated start point exceeds cube boundaries
  if (cube['startPoint'][0] >= cube['grid'].length) {
    cube['startPoint'][0] = 0;
    cube['startPoint'][1] += ((cargo.cargoLength / gridResolution).ceil());
    if (cube['startPoint'][1] >= cube['grid'][0].length) {
      cube['startPoint'][1] = 0;
      cube['startPoint'][2] += ((cargo.cargoHeight / gridResolution).ceil());
    }
  }
}

bool hasStructuralSupport(Truck truck, Cargo cargo, List<int> startPoint) {
  // Check if the cube is on the bottom layer (cubes 1 to 12)
  if (cargo.cargoDimensions[2] == 0) {
    return true; // No support needed for bottom layer
  }

  List<Cargo> supportingCargos = truck.cargos.where((c) =>
      c.cargoDimensions[2] + c.cargoHeight <= cargo.cargoDimensions[2] &&
      ((cargo.cargoDimensions[0] >= c.cargoDimensions[0] && cargo.cargoDimensions[0] < c.cargoDimensions[0] + c.cargoWidth) ||
       (cargo.cargoDimensions[0] + c.cargoWidth > c.cargoDimensions[0] && cargo.cargoDimensions[0] + c.cargoWidth <= c.cargoDimensions[0] + c.cargoWidth)) &&
      ((cargo.cargoDimensions[1] >= c.cargoDimensions[1] && cargo.cargoDimensions[1] < c.cargoDimensions[1] + c.cargoLength) ||
       (cargo.cargoDimensions[1] + cargo.cargoLength > c.cargoDimensions[1] && cargo.cargoDimensions[1] + cargo.cargoLength <= c.cargoDimensions[1] + c.cargoLength))
  ).toList();

  return supportingCargos.isNotEmpty;
}

void placeCargoInCube(Truck truck, Cargo cargo, Map<String, dynamic> cube) {
  cargo.cargoPlaceCubeId = cube['id'];
  cube['occupiedSpaces'].add(cargo);
  updateCubeGrid(cube, cargo);
  truck.cargos.add(cargo);
  checkAndMarkCubeOccupied(cube);
}

void updateCubeGrid(Map<String, dynamic> cube, Cargo cargo) {
  for (int i = cargo.startX; i < cargo.endX; i++) {
    for (int j = cargo.startY; j < cargo.endY; j++) {
      for (int k = cargo.startZ; j < cargo.endZ; k++) {
        if (i >= cube['grid'].length || j >= cube['grid'][0].length || k >= cube['grid'][0][0].length) {
          throw Exception('Grid index out of bounds');
        }
        cube['grid'][i][j][k] = true;
      }
    }
  }
}

void checkAndMarkCubeOccupied(Map<String, dynamic> cube) {
  int gridResolution = 10;
  int hypotheticalCargoSize = 2; // 2x2x2 grid cells represent 20x20x20 cm

  // Iterate over the cube to check for a 2x2x2 space
  for (int x = 0; x <= cube['grid'].length - hypotheticalCargoSize; x++) {
    for (int y = 0; y <= cube['grid'][0].length - hypotheticalCargoSize; y++) {
      for (int z = 0; z <= cube['grid'][0][0].length - hypotheticalCargoSize; z++) {
        bool spaceAvailable = true;

        // Check for 2x2x2 space
        for (int dx = 0; dx < hypotheticalCargoSize; dx++) {
          for (int dy = 0; dy < hypotheticalCargoSize; dy++) {
            for (int dz = 0; dz < hypotheticalCargoSize; dz++) {
              if (cube['grid'][x + dx][y + dy][z + dz]) {
                spaceAvailable = false;
                break;
              }
            }
            if (!spaceAvailable) break;
          }
          if (!spaceAvailable) break;
        }

        if (spaceAvailable) {
          return; // Found a 2x2x2 space, so the cube is not fully occupied
        }
      }
    }
  }

  // If no 2x2x2 space is found, mark the cube as occupied
  cube['occupied'] = true;
}

// New function to calculate the grade of a cargo
String calculateCargoGrade(Cargo cargo) {
  int categoryValue;
  int durabilityValue;

  // Determine the value for the cargo category
  switch (cargo.cargoCategory) {
    case 'heavy':
      categoryValue = 6;
      break;
    case 'medium':
      categoryValue = 4;
      break;
    case 'light':
      categoryValue = 2;
      break;
    default:
      throw Exception('Unknown cargo category: ${cargo.cargoCategory}');
  }

  // Determine the value for the cargo durability
  switch (cargo.cargoDurability) {
    case 'durable':
      durabilityValue = 3;
      break;
    case 'standard':
      durabilityValue = 2;
      break;
    case 'fragile':
      durabilityValue = 1;
      break;
    default:
      throw Exception('Unknown cargo durability: ${cargo.cargoDurability}');
  }

  // Calculate the total grade value
  int totalValue = categoryValue + durabilityValue;

  // Determine the grade based on the total value
  if (totalValue >= 7) {
    return 'Grade 3';
  } else if (totalValue >= 5) {
    return 'Grade 2';
  } else {
    return 'Grade 1';
  }
}

