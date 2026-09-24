import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// Modelo para mantener sincronizados el título y estado de la tarea
class Tarea {
  String titulo;
  bool completada;

  Tarea({
    required this.titulo,
    this.completada = false,
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lista de tareas',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ListaTareas(title: 'Lista de tareas'),
    );
  }
}

class ListaTareas extends StatefulWidget {
  const ListaTareas({super.key, required this.title});
  final String title;

  @override
  State<ListaTareas> createState() => ListaTareasState();
}

class ListaTareasState extends State<ListaTareas> {
  // Lista de objetos Tarea
  final List<Tarea> _tareas = [
    Tarea(titulo: 'Tarea1'),
    Tarea(titulo: 'Tarea2'),
    Tarea(titulo: 'Tarea3'),
    Tarea(titulo: 'Tarea4'),
    Tarea(titulo: 'Tarea5'),
  ];

  // Estado del filtro
  bool _verSoloPendientes = false;

  // Agregar nueva tarea
  void _agregar() {
    setState(() {
      _tareas.add(Tarea(titulo: 'Tarea${_tareas.length + 1}'));
    });
  }

  // Marcar/desmarcar tarea
  void _toggleTarea(Tarea tarea) {
    setState(() {
      tarea.completada = !tarea.completada;
    });
  }

  // Eliminar tarea
  void _eliminarTarea(Tarea tarea) {
    setState(() {
      _tareas.remove(tarea);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Contador de completadas vs total
    final int completadas = _tareas.where((t) => t.completada).length;

    // Lista filtrada según el estado del chip
    final listaFiltrada = _verSoloPendientes
        ? _tareas.where((t) => !t.completada).toList()
        : _tareas;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          // Encabezado con contador y filtro
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Completadas: $completadas de ${_tareas.length}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),

                Switch(
                    value: _verSoloPendientes,

                    onChanged: (bool valor) {
                      setState(() {
                        _verSoloPendientes = valor;
                      });
                    },
                )
              ],
            ),
          ),

          const Divider(height: 1),

          // Lista de tareas con ListView.builder dentro de Expanded
          Expanded(
            child: listaFiltrada.isEmpty
                ? const Center(
              child: Text(
                'No hay tareas para mostrar',
                style: TextStyle(color: Colors.grey),
              ),
            )
                : ListView.builder(
              itemCount: listaFiltrada.length,
              itemBuilder: (context, index) {
                final tarea = listaFiltrada[index];

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: ListTile(
                    // Checkbox para marcar/desmarcar
                    leading: Checkbox(
                      value: tarea.completada,
                      onChanged: (_) => _toggleTarea(tarea),
                    ),
                    // Texto con tachado dinámico si está completada
                    title: Text(
                      tarea.titulo,
                      style: TextStyle(
                        decoration: tarea.completada
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        color: tarea.completada
                            ? Colors.grey
                            : Colors.black,
                      ),
                    ),
                    // Botón de eliminación
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.redAccent,
                      ),
                      onPressed: () => _eliminarTarea(tarea),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      // Botón flotante para agregar tareas
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _agregar,
        icon: const Icon(Icons.add),
        label: const Text('Agregar'),
      ),
    );
  }
}