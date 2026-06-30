import 'package:flutter/material.dart';

/// Parámetros de navegación para la vista secundaria de Contactos.
/// Define qué evento inicial dispara el Bloc creado para esa ruta.
class ContactsSecondaryParams {
  const ContactsSecondaryParams({
    this.relatedToContactId,
    this.searchQuery,
  });

  /// Si viene seteado, la lista se filtra por contactos relacionados a este id.
  final String? relatedToContactId;

  final String? searchQuery;
}

/// Parámetros de navegación para la vista secundaria de Transacciones.
class TransactionsSecondaryParams {
  const TransactionsSecondaryParams({
    this.contactId,
    this.dateRange,
  });

  /// Si viene seteado, la lista se filtra por transacciones de este contacto.
  final String? contactId;

  final DateTimeRange? dateRange;
}