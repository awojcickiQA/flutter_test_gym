import 'package:flutter/material.dart';

/// Uniwersalny komponent opakowujący elementy interfejsu zarówno w `Key`,
/// jak i w semantyczne drzewo dostępności (`Semantics`), co umożliwia testowanie
/// przez flutter_test, Patrol, Maestro oraz Appium.
class TestableWidget extends StatelessWidget {
  final String keyId;
  final String? semanticLabel;
  final String? semanticHint;
  final bool container;
  final Widget child;

  const TestableWidget({
    super.key,
    required this.keyId,
    this.semanticLabel,
    this.semanticHint,
    this.container = false,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: Key(keyId),
      child: Semantics(
        identifier: keyId,
        label: semanticLabel,
        hint: semanticHint,
        container: container,
        child: child,
      ),
    );
  }
}

