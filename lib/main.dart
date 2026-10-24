import 'package:flutter/material.dart';

void main() {
  runApp(const EMILabApp());
}

class EMILabApp extends StatelessWidget {
  const EMILabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EMI Sistema de Gestión de Laboratorios',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: const Color(0xFF004080),
        scaffoldBackgroundColor: const Color(0xFFF4F6F9),
      ),
      home: const LoginScreen(),
    );
  }
}

// ==========================================
// PANTALLA DE LOGIN Y VERIFICACIÓN
// ==========================================
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isStudent = true;
  final TextEditingController _sagaController = TextEditingController(text: "A34554-5");
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _adminCodeController = TextEditingController();
  final TextEditingController _adminPassController = TextEditingController();
  
  bool codeSent = false;
  String errorMessage = "";

  void _handleStudentSubmit() {
    if (!codeSent) {
      if (_sagaController.text.trim() == "A34554-5") {
        setState(() {
          codeSent = true;
          errorMessage = "";
        });
      } else {
        setState(() {
          errorMessage = "Código SAGA no registrado. Usa: A34554-5";
        });
      }
    } else {
      if (_codeController.text.trim() == "482169") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const StudentMainScreen()),
        );
      } else {
        setState(() {
          errorMessage = "Código no válido o vencido. Usa: 482169";
        });
      }
    }
  }

  void _handleAdminSubmit() {
    if (_adminCodeController.text.trim() == "ADM-2026" &&
        _adminPassController.text.trim() == "admin123") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AdminMainScreen()),
      );
    } else {
      setState(() {
        errorMessage = "Credenciales incorrectas. Usa ADM-2026 / admin123";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const Text("EMI", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF004080))),
              const Text("ESCUELA MILITAR DE INGENIERÍA", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
              const Text("PORTAL UNIVERSITARIO - FACULTAD DE INGENIERÍA", style: TextStyle(fontSize: 10, color: Colors.grey)),
              const SizedBox(height: 20),
              
              // Selector Rol
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isStudent ? const Color(0xFF004080) : Colors.grey[200],
                        foregroundColor: isStudent ? Colors.white : Colors.black,
                      ),
                      onPressed: () => setState(() { isStudent = true; codeSent = false; errorMessage = ""; }),
                      child: const Text("Estudiante"),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: !isStudent ? const Color(0xFF004080) : Colors.grey[200],
                        foregroundColor: !isStudent ? Colors.white : Colors.black,
                      ),
                      onPressed: () => setState(() { isStudent = false; errorMessage = ""; }),
                      child: const Text("Administrador"),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: isStudent ? _buildStudentForm() : _buildAdminForm(),
                ),
              ),

              if (errorMessage.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(errorMessage, style: const TextStyle(color: Colors.red, fontSize: 13)),
              ],

              const SizedBox(height: 40),
              const Text("EMI Sistema de gestión de laboratorios", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              const Text("Soporte: laboratorio@adm.emi.edu.bo", style: TextStyle(fontSize: 11, color: Colors.grey)),
              const Text("Semestre 2026-II | Lun-vie 08:00-18:00", style: TextStyle(fontSize: 11, color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStudentForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(codeSent ? "Revisa tu correo institucional" : "Acceso del estudiante",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        if (!codeSent) ...[
          const Text("Ingresa tu código SAGA para acceder a las reservas.", style: TextStyle(fontSize: 13)),
          const SizedBox(height: 15),
          TextField(
            controller: _sagaController,
            decoration: const InputDecoration(labelText: "Código SAGA", border: OutlineInputBorder()),
          ),
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF004080)),
              onPressed: _handleStudentSubmit,
              child: const Text("Enviar código de verificación", style: TextStyle(color: Colors.white)),
            ),
          ),
        ] else ...[
          const Text("Enviamos un código de 6 dígitos a:", style: TextStyle(fontSize: 12)),
          const Text("lreyesr@est.emi.edu.bo", style: TextStyle(fontWeight: FontWeight.bold)),
          const Text("Código SAGA: A34554-5", style: TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 15),
          TextField(
            controller: _codeController,
            keyboardType: TextInputType.number,
            maxLength: 6,
            decoration: const InputDecoration(labelText: "Código predeterminado: 482169", border: OutlineInputBorder()),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF004080)),
              onPressed: _handleStudentSubmit,
              child: const Text("Verificar", style: TextStyle(color: Colors.white)),
            ),
          ),
        ]
      ],
    );
  }

  Widget _buildAdminForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Acceso del administrador", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        const Text("Ingresa tus credenciales institucionales.", style: TextStyle(fontSize: 13)),
        const SizedBox(height: 15),
        TextField(
          controller: _adminCodeController,
          decoration: const InputDecoration(labelText: "Código de administrador (ADM-2026)", border: OutlineInputBorder()),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _adminPassController,
          obscureText: true,
          decoration: const InputDecoration(labelText: "Contraseña (admin123)", border: OutlineInputBorder()),
        ),
        const SizedBox(height: 15),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF004080)),
            onPressed: _handleAdminSubmit,
            child: const Text("Ingresar", style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    );
  }
}

// ==========================================
// VISTA ESTUDIANTE (Catálogo, Reservas, Perfil)
// ==========================================
class StudentMainScreen extends StatefulWidget {
  const StudentMainScreen({super.key});

  @override
  State<StudentMainScreen> createState() => _StudentMainScreenState();
}

class _StudentMainScreenState extends State<StudentMainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const StudentCatalogPage(),
    const StudentReservationsPage(),
    const StudentProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ESPACIO DEL ESTUDIANTE", style: TextStyle(fontSize: 16)),
        backgroundColor: const Color(0xFF004080),
        foregroundColor: Colors.white,
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.build), label: 'Equipos'),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: 'Reservas'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}

class StudentCatalogPage extends StatelessWidget {
  const StudentCatalogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text("Catálogo de equipos", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const Text("Retira y devuelve equipos al aula correspondiente.", style: TextStyle(color: Colors.grey)),
        const SizedBox(height: 15),
        _buildEquipmentItem(
          context,
          code: "OSC-014",
          title: "Osciloscopio digital",
          subtitle: "Rigol DS1054Z. 4 canales",
          location: "Aula 418 - Disponible para reservar",
          status: "Disponible",
          statusColor: Colors.green,
        ),
        _buildEquipmentItem(
          context,
          code: "MIC-008",
          title: "Microscopio binocular",
          subtitle: "Olympus CX23-40x-1000x",
          location: "Aula 119 - Disponible para reservar",
          status: "Disponible",
          statusColor: Colors.green,
        ),
        _buildEquipmentItem(
          context,
          code: "MUL-021",
          title: "Multímetro digital",
          subtitle: "Fluke 87V True RMS",
          location: "Aula 119 - Devolución: hoy, 16:00",
          status: "Prestado",
          statusColor: Colors.orange,
        ),
        const SizedBox(height: 20),
        const Divider(),
        const Center(
          child: Text("Soporte: laboratorio@adm.emi.edu.bo", style: TextStyle(fontSize: 11, color: Colors.grey)),
        )
      ],
    );
  }

  Widget _buildEquipmentItem(BuildContext context, {
    required String code, required String title, required String subtitle,
    required String location, required String status, required Color statusColor
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text("$title ($code)", style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(subtitle),
            Text(location, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            Container(
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(color: statusColor.withOpacity(0.2), borderRadius: BorderRadius.circular(4)),
              child: Text(status, style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.bold)),
            )
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          if (code == "OSC-014") {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const EquipmentDetailPage()));
          }
        },
      ),
    );
  }
}

class EquipmentDetailPage extends StatelessWidget {
  const EquipmentDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detalle del equipo"), backgroundColor: const Color(0xFF004080), foregroundColor: Colors.white),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("ELECTRÓNICA OSC-014", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
            const Text("Osciloscopio digital", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const Text("Rigol DS1054Z - Aula 418", style: TextStyle(fontSize: 14, color: Colors.grey)),
            const SizedBox(height: 15),
            const Card(
              child: Padding(
                padding: EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Especificaciones:", style: TextStyle(fontWeight: FontWeight.bold)),
                    Text("• Ancho de banda: 50 MHz"),
                    Text("• Canales: 4 analógicos"),
                    Text("• Muestreo: 1 GSa/s"),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
            const Text("Solicitar reserva", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const TextField(decoration: InputDecoration(labelText: "Estudiante", hintText: "Lucía Reyes Ramírez (A34554-5)", enabled: false)),
            const SizedBox(height: 8),
            const TextField(decoration: InputDecoration(labelText: "Asignatura", hintText: "FÍSICA III")),
            const SizedBox(height: 8),
            const TextField(decoration: InputDecoration(labelText: "Motivo de uso", hintText: "Medición de señales y circuito RLC")),
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF004080)),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Solicitud enviada con éxito")));
                  Navigator.pop(context);
                },
                child: const Text("Enviar solicitud", style: TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(height: 20),
            const Center(child: Text("Soporte: laboratorio@adm.emi.edu.bo", style: TextStyle(fontSize: 11, color: Colors.grey))),
          ],
        ),
      ),
    );
  }
}

class StudentReservationsPage extends StatelessWidget {
  const StudentReservationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        Text("Mis reservas", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        SizedBox(height: 12),
        Card(
          child: ListTile(
            title: Text("Osciloscopio digital OSC-014"),
            subtitle: Text("R-0261 | 07 oct 14:00-16:00\nUbicación: Aula 418"),
            trailing: Text("Pendiente", style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
          ),
        ),
        Card(
          child: ListTile(
            title: Text("Multímetro digital MUL-021"),
            subtitle: Text("06 oct 08:00 - Devolver antes de las 16:00"),
            trailing: Text("En tu poder", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
          ),
        ),
        SizedBox(height: 20),
        Center(child: Text("Soporte: laboratorio@adm.emi.edu.bo", style: TextStyle(fontSize: 11, color: Colors.grey))),
      ],
    );
  }
}

class StudentProfilePage extends StatelessWidget {
  const StudentProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Mi Perfil", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Lucía Reyes Ramírez", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text("Código SAGA: A34554-5", style: TextStyle(color: Colors.grey)),
                  Divider(),
                  Text("Carrera: Ingeniería de Sistemas"),
                  Text("Semestre: 3º semestre"),
                  Text("Correo: lreyesr@est.emi.edu.bo"),
                  Text("Estado: Habilitada para reservar"),
                ],
              ),
            ),
          ),
          const Spacer(),
          const Center(child: Text("Soporte: laboratorio@adm.emi.edu.bo", style: TextStyle(fontSize: 11, color: Colors.grey))),
        ],
      ),
    );
  }
}

// ==========================================
// VISTA ADMINISTRADOR
// ==========================================
class AdminMainScreen extends StatelessWidget {
  const AdminMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PANEL DE ADMINISTRACIÓN"),
        backgroundColor: const Color(0xFF004080),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text("Resumen de gestión", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const Text("Hola, Carlos. Estado del laboratorio hoy.", style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 15),
          Row(
            children: [
              _buildStatCard("24", "Equipos", Colors.blue),
              _buildStatCard("6", "Prestados", Colors.orange),
              _buildStatCard("2", "Vencidos", Colors.red),
            ],
          ),
          const SizedBox(height: 20),
          const Text("Solicitudes pendientes", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              title: const Text("Osciloscopio OSC-014 - Aula 418"),
              subtitle: const Text("Lucía Reyes (A34554-5)\n07 oct 14:00-16:00"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(icon: const Icon(Icons.check, color: Colors.green), onPressed: () {}),
                  IconButton(icon: const Icon(Icons.close, color: Colors.red), onPressed: () {}),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Center(child: Text("Soporte: laboratorio@adm.emi.edu.bo", style: TextStyle(fontSize: 11, color: Colors.grey))),
        ],
      ),
    );
  }

  Widget _buildStatCard(String value, String label, Color color) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
              Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}
