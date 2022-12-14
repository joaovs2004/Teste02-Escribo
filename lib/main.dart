import 'package:flutter/material.dart';
import 'package:bonfire/bonfire.dart';
import 'package:labirinto_escribo/controller/game_controller.dart';
import 'package:labirinto_escribo/ghosts/ghosts.dart';
import 'package:labirinto_escribo/player/player.dart';
import 'package:labirinto_escribo/points/points.dart';
import 'package:labirinto_escribo/points/points_interface.dart';
import 'package:labirinto_escribo/power/power.dart';
import 'package:labirinto_escribo/teleports/teleports.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pacman Escribo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Game(),
    );
  }
}

class Game extends StatefulWidget {
  const Game({Key? key}) : super(key: key);

  @override
  State<Game> createState() => _Game();
}

class _Game extends State<Game> {
  @override
  Widget build(BuildContext context) {
    Pacman pacman = Pacman(Vector2(27 * 7, 45 * 7));

    return BonfireTiledWidget(
      joystick: Joystick(
        keyboardConfig: KeyboardConfig(
            keyboardDirectionalType: KeyboardDirectionalType.wasdAndArrows),
        directional: JoystickDirectional(),
      ),
      map: TiledWorldMap(
        'map/map.json',
        objectsBuilder: {
          'points': (properties) => Points(properties.position),
          'power': (properties) => Power(properties.position),
          'ghosts': (properties) => Ghost(properties.position, pacman),
          'teleports': (properties) =>
              Teleport(properties.position, properties.id)
        },
        forceTileSize: const Size(7, 7),
      ),
      overlayBuilderMap: {
        'points': (context, game) => PointsInterface(
              game: game,
              pacman: pacman,
            )
      },
      components: [MyGameController()],
      initialActiveOverlays: const [PointsInterface.overlaykey],
      player: pacman,
      cameraConfig: CameraConfig(
        moveOnlyMapArea: false,
        zoom: 1.02,
        sizeMovementWindow: Vector2(1000, 1000),
      ),
    );
  }
}
