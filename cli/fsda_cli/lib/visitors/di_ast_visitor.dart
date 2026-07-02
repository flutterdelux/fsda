import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

import '../enums/di_class_type.dart';
import '../models/di_class_info.dart';
import '../models/di_param.dart';

class DiAstVisitor extends RecursiveAstVisitor<void> {
  final List<DiClassInfo> classes = [];

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    // Lewati class abstract (interface)
    if (node.abstractKeyword != null) {
      super.visitClassDeclaration(node);
      return;
    }

    final className = node.name.lexeme;
    final type = DiClassType.fromValue(className);

    if (type == null) {
      super.visitClassDeclaration(node);
      return;
    }

    // Cari interface yang di-implement atau di-extend
    String? interfaceName;
    if (node.implementsClause != null &&
        node.implementsClause!.interfaces.isNotEmpty) {
      interfaceName = node.implementsClause!.interfaces.first.name.name;
    } else if (node.extendsClause != null) {
      interfaceName = node.extendsClause!.superclass.name.name;
    }

    // 🔥 FIX FINAL: Bypass 'members' yang dihilangkan di Analyzer 12+
    // Gunakan childEntities untuk mengekstrak langsung node ConstructorDeclaration
    final parameters = <DiParam>[];
    for (final entity in node.childEntities) {
      if (entity is ConstructorDeclaration) {
        // Cari yang main constructor (bukan named constructor)
        if (entity.name == null) {
          for (final param in entity.parameters.parameters) {
            parameters.add(
              DiParam(name: param.name!.lexeme, isNamed: param.isNamed),
            );
          }
        }
      }
    }

    classes.add(
      DiClassInfo(
        className: className,
        interfaceName: interfaceName,
        parameters: parameters,
        type: type,
      ),
    );

    super.visitClassDeclaration(node);
  }
}
