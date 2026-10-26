import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const EmiLabApp());

// ═══════════════════════════ COLORES ═══════════════════════════
class C {
  static const blue = Color(0xFF0B4FA0);
  static const navy = Color(0xFF0A3F7F);
  static const yellow = Color(0xFFFFDD00);
  static const bg = Color(0xFFF4F6FA);
  static const paleBlue = Color(0xFFE4ECF8);
  static const border = Color(0xFFE1E6EF);
  static const text = Color(0xFF1B1F2A);
  static const muted = Color(0xFF6B7385);
  static const red = Color(0xFFC62828);
  static const redBg = Color(0xFFFBE4E4);
  static const amber = Color(0xFF8A6A00);
  static const amberBg = Color(0xFFFFF4C9);
  static const green = Color(0xFF1E7D3A);
  static const greenBg = Color(0xFFDDF3E4);
  static const grayBg = Color(0xFFE9ECF2);
}

// ═══════════════════════════ DATOS ═══════════════════════════
const kNombre = 'Lucía Reyes Ramírez';
const kNombreCorto = 'Lucía Reyes';
const kSaga = 'A34554-5';
const kCarrera = 'Ingeniería de Sistemas';
const kSemestre = '3º semestre';
const kCorreo = 'lreyesr@est.emi.edu.bo';

class Equipo {
  final String code, name, category, spec, place, status;
  const Equipo(this.code, this.name, this.category, this.spec, this.place, this.status);
}

class Reserva {
  final String id, equipo, equipoCode, fecha, estudiante, matricula, carrera, solicitada;
  String status, materia, motivo, docente, nota;
  bool conflicto;
  Reserva({
    required this.id,
    required this.equipo,
    required this.equipoCode,
    required this.fecha,
    required this.estudiante,
    required this.matricula,
    required this.carrera,
    required this.solicitada,
    required this.status,
    this.materia = '',
    this.motivo = '',
    this.docente = '',
    this.nota = '',
    this.conflicto = false,
  });
}

class Prestamo {
  final String code, id, equipo, estudiante, matricula, retiro, devolucion, estado, nota;
  const Prestamo(this.code, this.id, this.equipo, this.estudiante, this.matricula, this.retiro,
      this.devolucion, this.estado, this.nota);
}

class AppState extends ChangeNotifier {
  String? role; // 'student' | 'admin'
  int studentTab = 0;
  int adminTab = 0;
  int _next = 264;

  final List<Equipo> equipos = [
    const Equipo('OSC-014', 'Osciloscopio digital', 'Electrónica', 'Rigol DS1054Z · 4 canales', 'Aula 418', 'Disponible'),
    const Equipo('MIC-008', 'Microscopio binocular', 'Óptica', 'Olympus CX23 · 40×–1000×', 'Aula 119', 'Disponible'),
    const Equipo('MUL-021', 'Multímetro digital', 'Electrónica', 'Fluke 87V · True RMS', 'Aula 119', 'Prestado'),
    const Equipo('BAL-003', 'Balanza analítica', 'Medición', 'Ohaus PX224 · 0,0001 g', 'Laboratorio de Alto Irpavi', 'Disponible'),
    const Equipo('GEN-006', 'Generador de funciones', 'Electrónica', 'Rigol DG1022Z · 25 MHz', 'Aula 418', 'Disponible'),
    const Equipo('CEN-002', 'Centrífuga de mesa', 'Bioprocesos', 'Eppendorf 5702 · 4.400 rpm', 'Laboratorio de Alto Irpavi', 'Mantenimiento'),
  ];

  final List<Reserva> reservas = [
    Reserva(id: 'R-0261', equipo: 'Osciloscopio digital', equipoCode: 'OSC-014', fecha: '07 oct · 14:00–16:00', estudiante: 'Lucía Reyes', matricula: '20210438', carrera: 'Ing. Electrónica', solicitada: 'Solicitada hoy, 08:15', status: 'Pendiente', materia: 'Electrónica II · Grupo A', motivo: 'Medición de señales y respuesta de un circuito RLC.'),
    Reserva(id: 'R-0262', equipo: 'Balanza analítica', equipoCode: 'BAL-003', fecha: '07 oct · 10:00–12:00', estudiante: 'Mateo Ruiz', matricula: '20220317', carrera: 'Ing. Electrónica', solicitada: 'Solicitada hoy, 08:42', status: 'Pendiente', conflicto: true),
    Reserva(id: 'R-0263', equipo: 'Generador de funciones', equipoCode: 'GEN-006', fecha: '07 oct · 16:00–18:00', estudiante: 'Sofía Rojas', matricula: '20230126', carrera: 'Ing. Electrónica', solicitada: 'Solicitada hoy, 09:10', status: 'Pendiente'),
    Reserva(id: 'R-0254', equipo: 'Microscopio binocular', equipoCode: 'MIC-008', fecha: '08 oct · 09:00–11:00', estudiante: 'Lucía Reyes', matricula: '20210438', carrera: 'Ing. Electrónica', solicitada: '', status: 'Aprobada'),
    Reserva(id: 'R-0242', equipo: 'Generador de funciones', equipoCode: 'GEN-004', fecha: '02 oct · 10:00–12:00', estudiante: 'Lucía Reyes', matricula: '20210438', carrera: 'Ing. Electrónica', solicitada: '', status: 'Devuelto'),
    Reserva(id: 'R-0238', equipo: 'Centrífuga de mesa', equipoCode: 'CEN-004', fecha: '30 sept · 14:00–16:00', estudiante: 'Lucía Reyes', matricula: '20210438', carrera: 'Ing. Electrónica', solicitada: '', status: 'Rechazada', nota: 'Equipo en revisión · Busca otra fecha o equipo'),
    Reserva(id: 'R-0230', equipo: 'Balanza analítica', equipoCode: 'BAL-005', fecha: '29 sept · 08:00–10:00', estudiante: 'Lucía Reyes', matricula: '20210438', carrera: 'Ing. Electrónica', solicitada: '', status: 'Devuelto'),
  ];

  final List<Prestamo> prestamos = [
    const Prestamo('OSC-009', 'P-0182', 'Osciloscopio digital', 'Mateo Ruiz', '20220317', '05 oct · 08:00', '05 oct · 10:00', 'Vencido', '18 h de retraso'),
    const Prestamo('CAM-002', 'P-0183', 'Cámara térmica', 'Valentina Torres', '20210562', '05 oct · 10:00', '05 oct · 09:15', 'Vencido', '16 h de retraso'),
    const Prestamo('MUL-021', 'P-0187', 'Multímetro digital', 'Lucía Herrera', '20210438', '06 oct · 08:00', '06 oct · 14:00', 'Vence hoy', 'Hoy a las 14:00'),
    const Prestamo('FUE-005', 'P-0188', 'Fuente de alimentación', 'Diego Salazar', '20220491', '06 oct · 09:00', '06 oct · 17:00', 'Vence hoy', 'Hoy a las 17:00'),
    const Prestamo('MIC-012', 'P-0189', 'Microscopio binocular', 'Sofía Rojas', '20230126', '06 oct · 09:00', '07 oct · 10:00', 'En plazo', 'Mañana a las 10:00'),
    const Prestamo('MUL-018', 'P-0190', 'Multímetro digital', 'Andrés Vega', '20220274', '06 oct · 10:00', '07 oct · 12:00', 'En plazo', 'Mañana a las 12:00'),
  ];

  List<Reserva> get mias => reservas.where((r) => r.estudiante == kNombreCorto).toList();
  List<Reserva> get pendientes => reservas.where((r) => r.status == 'Pendiente').toList();

  void login(String r) {
    role = r;
    studentTab = 0;
    adminTab = 0;
    notifyListeners();
  }

  void logout() {
    role = null;
    notifyListeners();
  }

  void setStudentTab(int i) {
    studentTab = i;
    notifyListeners();
  }

  void setAdminTab(int i) {
    adminTab = i;
    notifyListeners();
  }

  String addReserva(Equipo e, String fecha, String materia, String motivo, String docente) {
    final id = 'R-0${_next++}';
    reservas.insert(
      0,
      Reserva(id: id, equipo: e.name, equipoCode: e.code, fecha: fecha, estudiante: kNombreCorto, matricula: kSaga, carrera: 'Ing. de Sistemas', solicitada: 'Solicitada ahora', status: 'Pendiente', materia: materia, motivo: motivo, docente: docente),
    );
    notifyListeners();
    return id;
  }

  void setStatus(Reserva r, String s, {String nota = ''}) {
    r.status = s;
    r.nota = nota;
    r.conflicto = false;
    notifyListeners();
  }

  void cancelar(Reserva r) {
    reservas.remove(r);
    notifyListeners();
  }

  void recibir(Prestamo p) {
    prestamos.remove(p);
    notifyListeners();
  }
}

final app = AppState();

// ═══════════════════════════ APP ═══════════════════════════
class EmiLabApp extends StatelessWidget {
  const EmiLabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Laboratorios EMI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: C.blue),
        scaffoldBackgroundColor: C.bg,
      ),
      home: AnimatedBuilder(
        animation: app,
        builder: (_, __) {
          if (app.role == 'student') return const StudentShell();
          if (app.role == 'admin') return const AdminShell();
          return const LoginScreen();
        },
      ),
    );
  }
}

// ═══════════════════════════ WIDGETS COMUNES ═══════════════════════════
const kMuted = TextStyle(color: C.muted, fontSize: 12);
const kLabel = TextStyle(color: C.muted, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.4);
const kH2 = TextStyle(color: C.navy, fontSize: 18, fontWeight: FontWeight.w800);

Widget gap(double h) => SizedBox(height: h);
Widget pad(Widget w, {double v = 6}) =>
    Padding(padding: EdgeInsets.symmetric(horizontal: 16, vertical: v), child: w);

void snack(BuildContext context, String msg) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(msg)));
}

class Header extends StatelessWidget {
  final String kicker, title;
  final String? sub;
  final String initials;
  final bool bare;
  const Header({super.key, required this.kicker, required this.title, this.sub, this.initials = 'LR', this.bare = false});

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return Container(
      color: C.blue,
      child: Column(children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16, top + 10, 16, 16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)),
                child: const Text('EMI', style: TextStyle(color: C.blue, fontWeight: FontWeight.w900, fontSize: 18)),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('PORTAL UNIVERSITARIO', style: TextStyle(color: C.yellow, fontWeight: FontWeight.w800, fontSize: 13)),
                  Text('Facultad de Ingeniería', style: TextStyle(color: Colors.white, fontSize: 12)),
                ]),
              ),
              if (!bare) ...[
                Stack(children: [
                  const Icon(Icons.notifications_none, color: Colors.white),
                  Positioned(
                    right: 2,
                    top: 0,
                    child: Container(width: 8, height: 8, decoration: const BoxDecoration(color: C.yellow, shape: BoxShape.circle)),
                  ),
                ]),
                const SizedBox(width: 12),
                CircleAvatar(
                  radius: 17,
                  backgroundColor: C.paleBlue,
                  child: Text(initials, style: const TextStyle(color: C.blue, fontWeight: FontWeight.w800, fontSize: 12)),
                ),
              ],
            ]),
            const SizedBox(height: 16),
            Text(kicker, style: const TextStyle(color: Color(0xFFD6E4F7), fontSize: 11, letterSpacing: 0.5)),
            const SizedBox(height: 4),
            Text(title, style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w800)),
            if (sub != null) ...[
              const SizedBox(height: 2),
              Text(sub!, style: const TextStyle(color: Color(0xFFD6E4F7), fontSize: 13)),
            ],
          ]),
        ),
        Container(height: 3, color: C.yellow),
      ]),
    );
  }
}

class Footer extends StatelessWidget {
  const Footer({super.key});
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(16, 20, 16, 24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('EMI · Sistema de gestión de laboratorios', style: kMuted),
        SizedBox(height: 3),
        Text('Soporte: laboratorio@adm.emi.edu.bo', style: kMuted),
        SizedBox(height: 3),
        Text('Semestre 2026-II · Lun–vie · 08:00–18:00', style: kMuted),
      ]),
    );
  }
}

class ScreenBody extends StatelessWidget {
  final Widget header;
  final List<Widget> children;
  const ScreenBody({super.key, required this.header, required this.children});
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      header,
      Expanded(child: ListView(padding: EdgeInsets.zero, children: [...children, const Footer()])),
    ]);
  }
}

class Box extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final Color color, border;
  final double borderWidth;
  const Box({super.key, required this.child, this.padding = const EdgeInsets.all(14), this.color = Colors.white, this.border = C.border, this.borderWidth = 1});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(color: color, border: Border.all(color: border, width: borderWidth), borderRadius: BorderRadius.circular(12)),
      child: child,
    );
  }
}

class Tag extends StatelessWidget {
  final String text;
  final Color fg, bg;
  final bool dot;
  const Tag(this.text, this.fg, this.bg, {super.key, this.dot = true});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        if (dot) Container(width: 6, height: 6, decoration: BoxDecoration(color: fg, shape: BoxShape.circle)),
        if (dot) const SizedBox(width: 5),
        Text(text, style: TextStyle(color: fg, fontSize: 12, fontWeight: FontWeight.w700)),
      ]),
    );
  }
}

Widget statusTag(String s) {
  switch (s) {
    case 'Vencido':
    case 'Rechazada':
      return Tag(s, C.red, C.redBg);
    case 'Vence hoy':
    case 'Pendiente':
    case 'Mantenimiento':
      return Tag(s, C.amber, C.amberBg);
    case 'En plazo':
    case 'Prestado':
    case 'Activo':
      return Tag(s, C.blue, C.paleBlue);
    case 'Devuelto':
      return Tag(s, C.muted, C.grayBg);
    default:
      return Tag(s, C.green, C.greenBg);
  }
}

enum BKind { primary, yellow, outline, danger, soft }

class Btn extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final BKind kind;
  final IconData? icon;
  final bool dim;
  const Btn(this.label, this.onTap, {super.key, this.kind = BKind.primary, this.icon, this.dim = false});

  @override
  Widget build(BuildContext context) {
    Color bg, fg, bd;
    switch (kind) {
      case BKind.yellow:
        bg = C.yellow; fg = C.navy; bd = C.yellow;
        break;
      case BKind.outline:
        bg = Colors.white; fg = C.blue; bd = C.blue;
        break;
      case BKind.danger:
        bg = Colors.white; fg = C.red; bd = C.red;
        break;
      case BKind.soft:
        bg = C.redBg; fg = C.red; bd = C.redBg;
        break;
      default:
        bg = C.blue; fg = Colors.white; bd = C.blue;
    }
    if (dim) {
      bg = C.grayBg; fg = C.muted; bd = C.grayBg;
    }
    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(color: bg, border: Border.all(color: bd), borderRadius: BorderRadius.circular(10)),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: SizedBox(
            height: 48,
            child: Center(
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                if (icon != null) Icon(icon, size: 18, color: fg),
                if (icon != null) const SizedBox(width: 8),
                Flexible(child: Text(label, overflow: TextOverflow.ellipsis, style: TextStyle(color: fg, fontWeight: FontWeight.w700, fontSize: 15))),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final String value, label;
  final Color color;
  const StatCard(this.value, this.label, {super.key, this.color = C.navy});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 3),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: C.border)),
        child: Column(children: [
          Text(value, style: TextStyle(color: color, fontSize: 24, fontWeight: FontWeight.w800)),
          Text(label, style: kMuted),
        ]),
      ),
    );
  }
}

class ReadField extends StatelessWidget {
  final String label, value;
  final bool auto, lock;
  const ReadField(this.label, this.value, {super.key, this.auto = false, this.lock = false});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: kMuted),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          decoration: BoxDecoration(color: C.paleBlue, border: Border.all(color: C.border), borderRadius: BorderRadius.circular(10)),
          child: Row(children: [
            Expanded(child: Text(value, style: const TextStyle(fontSize: 15, color: C.text))),
            if (auto) const Text('● Autocompletado', style: TextStyle(color: C.green, fontSize: 11, fontWeight: FontWeight.w700)),
            if (lock) const Icon(Icons.lock_outline, size: 16, color: C.muted),
          ]),
        ),
      ]),
    );
  }
}

InputDecoration deco(String hint, {Widget? suffix, bool err = false}) {
  OutlineInputBorder b(Color c, double w) =>
      OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: c, width: w));
  return InputDecoration(
    hintText: hint,
    filled: true,
    fillColor: Colors.white,
    suffixIcon: suffix,
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    border: b(err ? C.red : C.border, 1),
    enabledBorder: b(err ? C.red : C.border, 1),
    focusedBorder: b(err ? C.red : C.blue, 2),
  );
}

class SearchField extends StatelessWidget {
  final String hint;
  final ValueChanged<String> onChanged;
  const SearchField(this.hint, this.onChanged, {super.key});
  @override
  Widget build(BuildContext context) {
    return TextField(onChanged: onChanged, decoration: deco(hint).copyWith(prefixIcon: const Icon(Icons.search, color: C.muted)));
  }
}

class BackLink extends StatelessWidget {
  final String text;
  const BackLink(this.text, {super.key});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).pop(),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
        child: Row(children: [
          const Icon(Icons.arrow_back, size: 18, color: C.blue),
          const SizedBox(width: 6),
          Text(text, style: const TextStyle(color: C.blue, fontWeight: FontWeight.w700)),
        ]),
      ),
    );
  }
}

// Selector genérico (reemplaza a los dropdown)
Future<String?> pickFromList(BuildContext context, String title, List<String> options, {bool search = false}) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (_) => _Picker(title: title, options: options, search: search),
  );
}

class _Picker extends StatefulWidget {
  final String title;
  final List<String> options;
  final bool search;
  const _Picker({required this.title, required this.options, required this.search});
  @override
  State<_Picker> createState() => _PickerState();
}

class _PickerState extends State<_Picker> {
  String q = '';
  @override
  Widget build(BuildContext context) {
    final list = widget.options.where((o) => o.toLowerCase().contains(q.toLowerCase())).toList();
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.7),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(padding: const EdgeInsets.fromLTRB(20, 20, 20, 8), child: Text(widget.title, style: kH2)),
          if (widget.search)
            Padding(padding: const EdgeInsets.fromLTRB(16, 0, 16, 8), child: SearchField('Buscar por nombre...', (v) => setState(() => q = v))),
          Flexible(
            child: ListView(
              shrinkWrap: true,
              children: list.map((o) => ListTile(title: Text(o), onTap: () => Navigator.pop(context, o))).toList(),
            ),
          ),
          const SizedBox(height: 12),
        ]),
      ),
    );
  }
}

class PickerField extends StatelessWidget {
  final String label, placeholder;
  final String? value, errorText;
  final VoidCallback onTap;
  const PickerField({super.key, required this.label, required this.placeholder, required this.value, required this.onTap, this.errorText});
  @override
  Widget build(BuildContext context) {
    final err = errorText != null;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('$label *', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
        const SizedBox(height: 6),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: err ? C.red : C.border, width: err ? 1.5 : 1)),
            child: Row(children: [
              Expanded(child: Text(value ?? placeholder, style: TextStyle(color: value == null ? C.muted : C.text, fontSize: 15))),
              const Icon(Icons.expand_more, color: C.muted),
            ]),
          ),
        ),
        if (err) Padding(padding: const EdgeInsets.only(top: 4), child: Text(errorText!, style: const TextStyle(color: C.red, fontSize: 12))),
      ]),
    );
  }
}

// ═══════════════════════════ LOGIN ═══════════════════════════
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  int role = 0; // 0 estudiante, 1 administrador
  int step = 0; // 0 formulario, 1 verificación
  final saga = TextEditingController(text: kSaga);
  final adminCode = TextEditingController();
  final adminPass = TextEditingController();
  final code = TextEditingController();
  final codeFocus = FocusNode();
  bool showPass = false;
  String? error;
  int seconds = 0;
  Timer? timer;

  @override
  void dispose() {
    timer?.cancel();
    saga.dispose();
    adminCode.dispose();
    adminPass.dispose();
    code.dispose();
    codeFocus.dispose();
    super.dispose();
  }

  void startTimer() {
    timer?.cancel();
    setState(() => seconds = 45);
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (seconds <= 1) {
        t.cancel();
        setState(() => seconds = 0);
      } else {
        setState(() => seconds--);
      }
    });
  }

  void sendCode() {
    if (saga.text.trim().toUpperCase() != kSaga) {
      setState(() => error = 'Código SAGA no encontrado.');
      return;
    }
    code.clear();
    setState(() {
      error = null;
      step = 1;
    });
    startTimer();
  }

  void verify() {
    if (code.text.length < 6 || code.text == '000000') {
      setState(() => error = 'Código no válido o vencido. Solicita uno nuevo.');
      return;
    }
    timer?.cancel();
    app.login('student');
  }

  void adminLogin() {
    if (adminCode.text.trim().toUpperCase() == 'ADM001' && adminPass.text == 'admin123') {
      app.login('admin');
    } else {
      setState(() => error = 'Código de administrador o contraseña incorrectos.');
    }
  }

  Widget roleTab(String label, int i) {
    final sel = role == i;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() {
          role = i;
          step = 0;
          error = null;
        }),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          alignment: Alignment.center,
          decoration: BoxDecoration(color: sel ? C.blue : Colors.transparent, borderRadius: BorderRadius.circular(10)),
          child: Text(label, style: TextStyle(color: sel ? Colors.white : C.muted, fontWeight: FontWeight.w800)),
        ),
      ),
    );
  }

  Widget errorText() => error == null
      ? const SizedBox.shrink()
      : Padding(padding: const EdgeInsets.only(top: 8), child: Text(error!, style: const TextStyle(color: C.red, fontSize: 13)));

  Widget studentForm() {
    return Box(
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Acceso del estudiante', style: TextStyle(color: C.navy, fontSize: 22, fontWeight: FontWeight.w800)),
        gap(8),
        const Text('Ingresa tu código SAGA para acceder a las reservas del laboratorio.', style: TextStyle(color: C.muted, fontSize: 15)),
        gap(16),
        const Text('Código SAGA', style: TextStyle(fontWeight: FontWeight.w700)),
        gap(6),
        TextField(controller: saga, textCapitalization: TextCapitalization.characters, decoration: deco('Ej. A34554-5', err: error != null), onChanged: (_) => setState(() => error = null)),
        gap(8),
        const Text('Te enviaremos un código a tu correo institucional', style: kMuted),
        errorText(),
        gap(14),
        Btn('Enviar código de verificación', sendCode),
      ]),
    );
  }

  Widget codeBoxes() {
    return SizedBox(
      height: 54,
      child: Stack(children: [
        Row(
          children: List.generate(6, (i) {
            final ch = i < code.text.length ? code.text[i] : '';
            final active = i == code.text.length && error == null;
            return Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 3),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: error != null ? C.red : (active ? C.blue : C.border), width: active || error != null ? 2 : 1),
                ),
                child: Text(ch.isEmpty ? '–' : ch, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: ch.isEmpty ? C.muted : (error != null ? C.red : C.text))),
              ),
            );
          }),
        ),
        Positioned.fill(
          child: Opacity(
            opacity: 0,
            child: TextField(
              controller: code,
              focusNode: codeFocus,
              autofocus: true,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(6)],
              onChanged: (_) => setState(() => error = null),
            ),
          ),
        ),
      ]),
    );
  }

  Widget verifyForm() {
    String mm(int s) => '00:${s.toString().padLeft(2, '0')}';
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Box(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Revisa tu correo institucional', style: TextStyle(color: C.navy, fontSize: 22, fontWeight: FontWeight.w800)),
          gap(10),
          const Text('Enviamos un código de 6 dígitos a', style: TextStyle(color: C.muted, fontSize: 15)),
          gap(4),
          const Text(kCorreo, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
          gap(2),
          const Text('Código SAGA: $kSaga', style: kMuted),
          gap(16),
          const Text('Código de 6 dígitos', style: TextStyle(fontWeight: FontWeight.w700)),
          gap(8),
          codeBoxes(),
          errorText(),
          gap(6),
          const Text('Modo demostración: escribe cualquier código de 6 dígitos (000000 falla).', style: kMuted),
          gap(14),
          Btn('Verificar', verify),
          gap(12),
          Center(
            child: seconds > 0
                ? Text('Podrás reenviar en ${mm(seconds)}', style: kMuted)
                : TextButton(onPressed: startTimer, child: const Text('Reenviar código', style: TextStyle(fontWeight: FontWeight.w800))),
          ),
        ]),
      ),
      TextButton.icon(
        onPressed: () {
          timer?.cancel();
          setState(() {
            step = 0;
            error = null;
          });
        },
        icon: const Icon(Icons.arrow_back, size: 18),
        label: const Text('Volver a iniciar sesión', style: TextStyle(fontWeight: FontWeight.w800)),
      ),
    ]);
  }

  Widget adminForm() {
    return Box(
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Acceso del administrador', style: TextStyle(color: C.navy, fontSize: 22, fontWeight: FontWeight.w800)),
        gap(8),
        const Text('Ingresa tus credenciales institucionales para gestionar el laboratorio.', style: TextStyle(color: C.muted, fontSize: 15)),
        gap(16),
        const Text('Código de administrador', style: TextStyle(fontWeight: FontWeight.w700)),
        gap(6),
        TextField(controller: adminCode, textCapitalization: TextCapitalization.characters, decoration: deco('Ingresa tu código'), onChanged: (_) => setState(() => error = null)),
        gap(14),
        const Text('Contraseña', style: TextStyle(fontWeight: FontWeight.w700)),
        gap(6),
        TextField(
          controller: adminPass,
          obscureText: !showPass,
          decoration: deco('Contraseña', suffix: TextButton(onPressed: () => setState(() => showPass = !showPass), child: Text(showPass ? 'Ocultar' : 'Mostrar', style: const TextStyle(fontWeight: FontWeight.w800)))),
          onChanged: (_) => setState(() => error = null),
        ),
        errorText(),
        gap(6),
        const Text('Demo: ADM001 / admin123', style: kMuted),
        gap(14),
        Btn('Ingresar', adminLogin),
        gap(8),
        Center(child: TextButton(onPressed: () => snack(context, 'Contacta a soporte: laboratorio@adm.emi.edu.bo'), child: const Text('¿Olvidaste tu contraseña?', style: TextStyle(fontWeight: FontWeight.w800)))),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final verifying = role == 0 && step == 1;
    return Scaffold(
      backgroundColor: C.bg,
      body: Column(children: [
        Header(kicker: 'SISTEMA DE GESTIÓN DE LABORATORIOS', title: verifying ? 'Verificar código' : 'Iniciar sesión', bare: true),
        Expanded(
          child: ListView(padding: const EdgeInsets.all(16), children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(color: C.paleBlue, borderRadius: BorderRadius.circular(12), border: Border.all(color: C.border)),
              child: Row(children: [roleTab('Estudiante', 0), roleTab('Administrador', 1)]),
            ),
            gap(16),
            if (role == 1) adminForm() else if (step == 0) studentForm() else verifyForm(),
            gap(12),
            Text(role == 1 ? 'Acceso exclusivo para personal autorizado de EMI.' : 'Usa el código que figura en tu credencial universitaria.', style: const TextStyle(color: C.muted)),
            const Footer(),
          ]),
        ),
      ]),
    );
  }
}

// ═══════════════════════════ ESTUDIANTE ═══════════════════════════
class StudentShell extends StatelessWidget {
  const StudentShell({super.key});
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: app,
      builder: (_, __) {
        final pages = <Widget>[const CatalogoPage(), const ReservasPage(), const PerfilPage(), const AyudaPage()];
        return Scaffold(
          backgroundColor: C.bg,
          body: pages[app.studentTab],
          bottomNavigationBar: NavigationBar(
            selectedIndex: app.studentTab,
            onDestinationSelected: app.setStudentTab,
            backgroundColor: Colors.white,
            indicatorColor: C.paleBlue,
            destinations: const [
              NavigationDestination(icon: Icon(Icons.grid_view), label: 'Equipos'),
              NavigationDestination(icon: Icon(Icons.calendar_month_outlined), label: 'Reservas'),
              NavigationDestination(icon: Icon(Icons.person_outline), label: 'Perfil'),
              NavigationDestination(icon: Icon(Icons.help_outline), label: 'Ayuda'),
            ],
          ),
        );
      },
    );
  }
}

IconData catIcon(String c) {
  switch (c) {
    case 'Óptica':
      return Icons.biotech;
    case 'Medición':
      return Icons.scale;
    case 'Bioprocesos':
      return Icons.science;
    default:
      return Icons.memory;
  }
}

class CatalogoPage extends StatefulWidget {
  const CatalogoPage({super.key});
  @override
  State<CatalogoPage> createState() => _CatalogoPageState();
}

class _CatalogoPageState extends State<CatalogoPage> {
  String q = '';
  @override
  Widget build(BuildContext context) {
    final list = app.equipos.where((e) => (e.name + e.code).toLowerCase().contains(q.toLowerCase())).toList();
    return ScreenBody(
      header: const Header(kicker: 'ESPACIO DEL ESTUDIANTE', title: 'Catálogo de equipos'),
      children: [
        Container(
          color: C.paleBlue,
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Todo listo para tu siguiente proyecto', style: TextStyle(color: C.navy, fontWeight: FontWeight.w800)),
            const Text('Retira y devuelve equipos a la aula o laboratorio que corresponda.', style: TextStyle(color: C.blue, fontSize: 13)),
            gap(12),
            const Row(children: [StatCard('24', 'Equipos'), StatCard('16', 'Disponibles', color: C.green), StatCard('6', 'Prestados', color: C.blue), StatCard('2', 'En revisión', color: C.amber)]),
          ]),
        ),
        pad(SearchField('Buscar equipo o código...', (v) => setState(() => q = v)), v: 12),
        pad(Text('${list.length} de 24 equipos', style: kMuted)),
        ...list.map((e) => pad(EquipoCard(e))),
      ],
    );
  }
}

class EquipoCard extends StatelessWidget {
  final Equipo e;
  const EquipoCard(this.e, {super.key});
  @override
  Widget build(BuildContext context) {
    final suffix = e.status == 'Disponible' ? ' · Disponible para reservar' : e.status == 'Prestado' ? ' · Devolución: hoy, 16:00' : ' · Revisión técnica en curso';
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => DetallePage(e))),
      child: Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: C.border)),
        clipBehavior: Clip.antiAlias,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(height: 110, width: double.infinity, color: C.paleBlue, child: Icon(catIcon(e.category), size: 56, color: C.blue)),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [statusTag(e.status), const Spacer(), Text(e.code, style: kMuted)]),
              gap(8),
              Text(e.category.toUpperCase(), style: const TextStyle(color: C.blue, fontSize: 11, fontWeight: FontWeight.w800)),
              Text(e.name, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800)),
              Text(e.spec, style: const TextStyle(color: C.muted)),
              const Divider(height: 22),
              Row(children: [
                const Icon(Icons.place_outlined, size: 16, color: C.muted),
                const SizedBox(width: 4),
                Expanded(child: Text('${e.place}$suffix', style: kMuted)),
                const Text('Ver →', style: TextStyle(color: C.blue, fontWeight: FontWeight.w800)),
              ]),
            ]),
          ),
        ]),
      ),
    );
  }
}

class DetallePage extends StatelessWidget {
  final Equipo e;
  const DetallePage(this.e, {super.key});
  @override
  Widget build(BuildContext context) {
    final cond = ['Uso máximo de 4 horas dentro del horario del laboratorio.', 'Presenta tu credencial y verifica los accesorios al retirar.', 'Devuelve el equipo al aula o laboratorio correspondiente al finalizar tu horario.'];
    return Scaffold(
      backgroundColor: C.bg,
      body: ScreenBody(
        header: const Header(kicker: 'ESPACIO DEL ESTUDIANTE', title: 'Detalle del equipo'),
        children: [
          const BackLink('Volver al catálogo'),
          Container(
            color: C.paleBlue,
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [Text('${e.category.toUpperCase()} · ${e.code}', style: const TextStyle(color: C.blue, fontSize: 12, fontWeight: FontWeight.w700)), const Spacer(), statusTag(e.status)]),
              gap(6),
              Text(e.name, style: const TextStyle(color: C.navy, fontSize: 24, fontWeight: FontWeight.w800)),
              Text('${e.spec} · ${e.place}', style: const TextStyle(color: C.blue, fontSize: 13)),
            ]),
          ),
          Container(height: 150, color: Colors.white, alignment: Alignment.center, child: Icon(catIcon(e.category), size: 80, color: C.blue)),
          pad(
            Box(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('CÓDIGO DE INVENTARIO', style: kLabel),
                Text(e.code, style: const TextStyle(color: C.navy, fontSize: 22, fontWeight: FontWeight.w800)),
                const Divider(height: 24),
                const Text('Condiciones de préstamo', style: kH2),
                gap(8),
                ...cond.map((c) => Padding(padding: const EdgeInsets.only(bottom: 8), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [const Icon(Icons.check_circle_outline, size: 18, color: C.blue), const SizedBox(width: 8), Expanded(child: Text(c))]))),
              ]),
            ),
            v: 12,
          ),
          if (e.status == 'Disponible')
            ReservaForm(e)
          else
            pad(Box(color: C.amberBg, border: C.yellow, child: const Text('Este equipo no está disponible para reservar por ahora. Busca otra fecha o equipo.', style: TextStyle(color: C.amber, fontWeight: FontWeight.w700)))),
        ],
      ),
    );
  }
}

class ReservaForm extends StatefulWidget {
  final Equipo e;
  const ReservaForm(this.e, {super.key});
  @override
  State<ReservaForm> createState() => _ReservaFormState();
}

class _ReservaFormState extends State<ReservaForm> {
  int? day = 7;
  bool blocked = false;
  int? slot = 0;
  String? materia;
  String? docente;
  bool accepted = true;
  bool submitted = false;
  final motivo = TextEditingController();

  static const slotLabels = ['08–10', '10–12', '14–16', '16–18'];
  static const slotStart = [8, 10, 14, 16];
  static const occupied = 1;

  String hh(int h) => '${h.toString().padLeft(2, '0')}:00';

  @override
  void dispose() {
    motivo.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    setState(() => submitted = true);
    final ok = day != null && slot != null && materia != null && motivo.text.trim().isNotEmpty && docente != null && accepted;
    if (!ok) return;
    final s = slotStart[slot!];
    final fecha = '${day.toString().padLeft(2, '0')} oct · ${hh(s)}–${hh(s + 2)}';
    final id = app.addReserva(widget.e, fecha, materia!, motivo.text.trim(), docente!);
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: const CircleAvatar(radius: 28, backgroundColor: C.greenBg, child: Icon(Icons.check, color: C.green, size: 32)),
        title: const Text('¡Solicitud enviada!', textAlign: TextAlign.center),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          Text('$id · ${widget.e.name}', style: const TextStyle(fontWeight: FontWeight.w800)),
          gap(4),
          Text(fecha),
          gap(8),
          const Text('Tu solicitud será revisada por el administrador. Te notificaremos a tu correo institucional.', textAlign: TextAlign.center, style: kMuted),
        ]),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Ver mis reservas', style: TextStyle(fontWeight: FontWeight.w800)))],
      ),
    );
    if (!mounted) return;
    Navigator.of(context).pop();
    app.setStudentTab(1);
  }

  @override
  Widget build(BuildContext context) {
    final faltan = <String>[
      if (materia == null) 'Asignatura',
      if (motivo.text.trim().isEmpty) 'Motivo de uso',
      if (docente == null) 'Docente encargado del laboratorio',
    ];
    final complete = faltan.isEmpty && day != null && slot != null && accepted;
    final s = slot == null ? null : slotStart[slot!];
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      pad(const Text('Solicitar reserva', style: TextStyle(color: C.navy, fontSize: 22, fontWeight: FontWeight.w800)), v: 10),
      pad(const Text('Selecciona fecha y horario. Tu solicitud será revisada por el administrador.', style: TextStyle(color: C.muted))),
      if (submitted && faltan.isNotEmpty)
        pad(Box(color: C.redBg, border: C.red, child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [const Icon(Icons.error_outline, color: C.red, size: 20), const SizedBox(width: 8), Expanded(child: Text('Faltan campos obligatorios: ${faltan.join(', ')}. No puedes enviar la solicitud.', style: const TextStyle(color: C.red)))]))),
      pad(
        Box(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Datos del estudiante', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
            const Text('Registro académico · datos de solo lectura', style: kMuted),
            gap(10),
            const ReadField('Nombre completo', kNombre, auto: true),
            const ReadField('Código SAGA', kSaga, auto: true),
            const ReadField('Carrera', kCarrera, auto: true),
            const ReadField('Semestre', kSemestre, auto: true),
            const ReadField('Correo institucional', kCorreo, auto: true),
          ]),
        ),
      ),
      pad(MiniCalendar(selected: day, onPick: (d) => setState(() { day = d; blocked = false; }), onBlocked: () => setState(() => blocked = true), warning: blocked)),
      if (day != null) ...[
        pad(Row(children: [const Icon(Icons.event, size: 18, color: C.blue), const SizedBox(width: 6), Text('Miércoles, ${day.toString().padLeft(2, '0')} de octubre de 2026', style: const TextStyle(color: C.blue, fontWeight: FontWeight.w800))])),
        pad(const Text('Horario ilustrativo · miércoles · 08:00–10:00', style: kMuted)),
        pad(Row(children: [
          Expanded(child: _TimeBox('Hora de inicio', s == null ? '--:--' : hh(s))),
          const SizedBox(width: 10),
          Expanded(child: _TimeBox('Devolución', s == null ? '--:--' : hh(s + 2))),
        ])),
        pad(Row(children: List.generate(4, (i) {
          final occ = i == occupied;
          final sel = slot == i;
          return Expanded(
            child: GestureDetector(
              onTap: occ ? null : () => setState(() => slot = i),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 3),
                padding: const EdgeInsets.symmetric(vertical: 12),
                alignment: Alignment.center,
                decoration: BoxDecoration(color: sel ? C.blue : (occ ? C.grayBg : C.greenBg), borderRadius: BorderRadius.circular(8)),
                child: Text(slotLabels[i], style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: sel ? Colors.white : (occ ? C.muted : C.green))),
              ),
            ),
          );
        }))),
        pad(const Text('Verde: libre · Gris: ocupado · Azul: tu selección', style: kMuted)),
      ],
      gap(8),
      pad(PickerField(
        label: 'Asignatura',
        placeholder: 'Selecciona una asignatura',
        value: materia,
        errorText: submitted && materia == null ? 'Selecciona una asignatura.' : null,
        onTap: () async {
          final r = await pickFromList(context, 'Asignatura', ['FÍSICA III', 'Electrónica II', 'Cálculo II', 'Programación II', 'Circuitos Eléctricos']);
          if (r != null) setState(() => materia = r);
        },
      )),
      pad(Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Motivo de uso *', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
        gap(6),
        TextField(controller: motivo, maxLines: 3, onChanged: (_) => setState(() {}), decoration: deco('Describe para qué utilizarás el equipo', err: submitted && motivo.text.trim().isEmpty)),
        if (submitted && motivo.text.trim().isEmpty) const Padding(padding: EdgeInsets.only(top: 4), child: Text('Indica el motivo de uso del equipo.', style: TextStyle(color: C.red, fontSize: 12))),
      ])),
      gap(10),
      pad(PickerField(
        label: 'Docente encargado del laboratorio',
        placeholder: 'Selecciona un docente',
        value: docente,
        errorText: submitted && docente == null ? 'Selecciona al docente encargado del laboratorio.' : null,
        onTap: () async {
          final r = await pickFromList(context, 'Docente encargado del laboratorio', ['Ana Torres Mendoza', 'Carlos Rojas Salinas', 'María López Vargas', 'Jorge Pérez Andrade'], search: true);
          if (r != null) setState(() => docente = r);
        },
      )),
      pad(Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Checkbox(value: accepted, onChanged: (v) => setState(() => accepted = v ?? false)),
        const Expanded(child: Padding(padding: EdgeInsets.only(top: 12), child: Text('Acepto las condiciones y me comprometo a devolver el equipo a tiempo.'))),
      ])),
      pad(Box(color: C.paleBlue, child: Row(children: [const Text('Duración total'), const Spacer(), Text(s == null ? '—' : '2 horas', style: const TextStyle(fontWeight: FontWeight.w800, color: C.navy))]))),
      pad(Btn('Enviar solicitud', submit, icon: Icons.send_outlined, dim: !complete), v: 10),
      pad(const Center(child: Text('La reserva se confirma después de su aprobación.', style: kMuted))),
    ]);
  }
}

class _TimeBox extends StatelessWidget {
  final String label, value;
  const _TimeBox(this.label, this.value);
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
      gap(6),
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: Colors.white, border: Border.all(color: C.border), borderRadius: BorderRadius.circular(10)),
        child: Row(children: [const Icon(Icons.access_time, size: 18, color: C.blue), const SizedBox(width: 8), Text(value, style: const TextStyle(fontSize: 15))]),
      ),
    ]);
  }
}

class MiniCalendar extends StatelessWidget {
  final int? selected;
  final ValueChanged<int> onPick;
  final VoidCallback onBlocked;
  final bool warning;
  const MiniCalendar({super.key, required this.selected, required this.onPick, required this.onBlocked, required this.warning});

  @override
  Widget build(BuildContext context) {
    const names = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];
    return Box(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Solo puedes solicitar equipos los días que tienes laboratorio.', style: kMuted),
        gap(8),
        const Row(children: [Icon(Icons.chevron_left, color: C.muted), Expanded(child: Center(child: Text('Octubre 2026', style: TextStyle(color: C.navy, fontWeight: FontWeight.w800)))), Icon(Icons.chevron_right, color: C.blue)]),
        gap(6),
        Row(children: names.map((n) => Expanded(child: Center(child: Text(n, style: kMuted)))).toList()),
        ...List.generate(5, (w) {
          return Row(
            children: List.generate(7, (c) {
              final d = w * 7 + c - 2;
              final inMonth = d >= 1 && d <= 31;
              final label = d <= 0 ? 30 + d : (d > 31 ? d - 31 : d);
              final enabled = inMonth && c == 2;
              final sel = enabled && selected == d;
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (enabled) {
                      onPick(d);
                    } else if (inMonth) {
                      onBlocked();
                    }
                  },
                  child: Container(
                    height: 38,
                    margin: const EdgeInsets.all(2),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: sel ? C.blue : (enabled ? C.paleBlue : C.bg), borderRadius: BorderRadius.circular(8)),
                    child: Text('$label', style: TextStyle(color: sel ? Colors.white : (enabled ? C.blue : const Color(0xFFB4BBC9)), fontWeight: enabled ? FontWeight.w800 : FontWeight.w400)),
                  ),
                ),
              );
            }),
          );
        }),
        gap(8),
        const Row(children: [Icon(Icons.circle, size: 8, color: C.blue), SizedBox(width: 6), Text('Miércoles habilitados: 7, 14, 21 y 28', style: kMuted)]),
        if (warning) ...[
          gap(8),
          Box(color: C.amberBg, border: C.yellow, child: const Row(children: [Icon(Icons.info_outline, color: C.amber, size: 18), SizedBox(width: 8), Expanded(child: Text('No tienes laboratorio este día. Elige un miércoles habilitado.', style: TextStyle(color: C.amber)))])),
        ],
      ]),
    );
  }
}

class ReservasPage extends StatefulWidget {
  const ReservasPage({super.key});
  @override
  State<ReservasPage> createState() => _ReservasPageState();
}

class _ReservasPageState extends State<ReservasPage> {
  int tab = 0;

  Widget tabBtn(String label, int i) {
    final sel = tab == i;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => tab = i),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          alignment: Alignment.center,
          decoration: BoxDecoration(border: Border(bottom: BorderSide(color: sel ? C.blue : Colors.transparent, width: 3))),
          child: Text(label, style: TextStyle(color: sel ? C.blue : C.muted, fontWeight: FontWeight.w800, fontSize: 13)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final todas = app.mias;
    final pend = todas.where((r) => r.status == 'Pendiente').toList();
    final hist = todas.where((r) => r.status == 'Devuelto' || r.status == 'Rechazada').toList();
    final list = tab == 0 ? todas : (tab == 1 ? pend : hist);
    return ScreenBody(
      header: const Header(kicker: 'ESPACIO DEL ESTUDIANTE', title: 'Mis reservas'),
      children: [
        Container(
          color: C.amberBg,
          padding: const EdgeInsets.all(14),
          child: const Row(children: [Icon(Icons.warning_amber_rounded, color: C.amber), SizedBox(width: 10), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Entrega hoy antes de las 16:00', style: TextStyle(color: C.amber, fontWeight: FontWeight.w800)), Text('Devuelve el MUL-021 en laboratorio B-204.', style: TextStyle(color: C.amber, fontSize: 13))]))]),
        ),
        pad(const Text('EN TU PODER', style: TextStyle(color: C.blue, fontWeight: FontWeight.w800, fontSize: 12)), v: 12),
        pad(
          Box(
            color: C.paleBlue,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Container(width: 44, height: 44, decoration: BoxDecoration(color: C.blue, borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.bolt, color: Colors.white)),
                const SizedBox(width: 10),
                const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Multímetro digital', style: TextStyle(color: C.navy, fontWeight: FontWeight.w800, fontSize: 16)), Text('MUL-021 · Fluke 87V', style: kMuted)])),
                statusTag('Activo'),
              ]),
              gap(12),
              const Row(children: [
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('RETIRADO', style: kLabel), Text('06 oct · 08:00', style: TextStyle(fontWeight: FontWeight.w800))])),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('DEVOLVER ANTES DE', style: kLabel), Text('Hoy · 16:00', style: TextStyle(fontWeight: FontWeight.w800, color: C.amber))])),
              ]),
              gap(12),
              Btn('Ver préstamo', () => snack(context, 'Devuelve el MUL-021 en el laboratorio B-204 antes de las 16:00.')),
            ]),
          ),
        ),
        gap(8),
        Container(color: Colors.white, child: Row(children: [tabBtn('Todas (${todas.length})', 0), tabBtn('Pendientes (${pend.length})', 1), tabBtn('Historial (${hist.length})', 2)])),
        gap(8),
        if (list.isEmpty) pad(const Padding(padding: EdgeInsets.all(24), child: Center(child: Text('No hay reservas en esta sección.', style: kMuted)))),
        ...list.map((r) => pad(ReservaCard(r))),
        pad(Btn('Nueva reserva', () => app.setStudentTab(0), icon: Icons.add), v: 12),
      ],
    );
  }
}

class ReservaCard extends StatelessWidget {
  final Reserva r;
  const ReservaCard(this.r, {super.key});
  @override
  Widget build(BuildContext context) {
    Widget action;
    if (r.status == 'Pendiente') {
      action = Btn('Cancelar solicitud', () {
        app.cancelar(r);
        snack(context, 'Solicitud ${r.id} cancelada.');
      }, kind: BKind.outline);
    } else if (r.status == 'Aprobada') {
      action = Btn('Ver comprobante', () => showDialog<void>(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Comprobante de reserva'),
              content: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Reserva: ${r.id}'),
                Text('Equipo: ${r.equipo} (${r.equipoCode})'),
                Text('Fecha y hora: ${r.fecha}'),
                Text('Estudiante: $kNombre'),
                const Text('Estado: Aprobada'),
                gap(8),
                const Text('Presenta tu credencial al retirar el equipo.', style: kMuted),
              ]),
              actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cerrar'))],
            ),
          ));
    } else if (r.status == 'Rechazada') {
      action = Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: C.redBg, borderRadius: BorderRadius.circular(8)),
        child: Text(r.nota.isEmpty ? 'Solicitud rechazada.' : r.nota, style: const TextStyle(color: C.red)),
      );
    } else {
      action = const Text('Ver detalle →', style: TextStyle(color: C.blue, fontWeight: FontWeight.w800));
    }
    return Box(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(r.equipo, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800)), Text(r.equipoCode, style: kMuted)])),
          statusTag(r.status),
        ]),
        gap(10),
        Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('RESERVA', style: kLabel), Text(r.id, style: const TextStyle(fontWeight: FontWeight.w800))])),
          Expanded(flex: 2, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('FECHA Y HORA', style: kLabel), Text(r.fecha, style: const TextStyle(fontWeight: FontWeight.w800))])),
        ]),
        gap(10),
        action,
      ]),
    );
  }
}

class PerfilPage extends StatelessWidget {
  const PerfilPage({super.key});
  Widget row(String l, String v) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(children: [Text(l, style: const TextStyle(color: C.muted)), const Spacer(), Text(v, style: const TextStyle(fontWeight: FontWeight.w800))]),
      );
  @override
  Widget build(BuildContext context) {
    final pend = app.mias.where((r) => r.status == 'Pendiente').length;
    return ScreenBody(
      header: const Header(kicker: 'ESPACIO DEL ESTUDIANTE', title: 'Mi perfil'),
      children: [
        Container(
          color: C.paleBlue,
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          child: Column(children: [
            const CircleAvatar(radius: 38, backgroundColor: Colors.white, child: Text('LR', style: TextStyle(color: C.blue, fontSize: 26, fontWeight: FontWeight.w800))),
            gap(10),
            const Text(kNombre, style: TextStyle(color: C.navy, fontSize: 22, fontWeight: FontWeight.w800)),
            gap(6),
            Tag('Estudiante verificada', C.green, C.greenBg),
            gap(10),
            const Text('CÓDIGO SAGA', style: TextStyle(color: C.blue, fontSize: 11, fontWeight: FontWeight.w800)),
            const Text(kSaga, style: TextStyle(color: C.navy, fontSize: 30, fontWeight: FontWeight.w900)),
            const Text('$kCarrera · $kSemestre', style: kMuted),
            gap(12),
            const Box(child: Row(children: [Icon(Icons.badge_outlined, color: C.blue), SizedBox(width: 10), Expanded(child: Text('Debes presentar tu credencial al retirar o devolver un equipo.', style: TextStyle(color: C.navy)))])),
          ]),
        ),
        pad(const Text('Estado de mi cuenta', style: kH2), v: 12),
        pad(Align(alignment: Alignment.centerLeft, child: Tag('Habilitada para reservar', C.green, C.greenBg))),
        pad(Box(child: Column(children: [row('Préstamo activo', '1'), const Divider(height: 1), row('Reservas pendientes', '$pend'), const Divider(height: 1), row('Próxima reserva', '08 oct · 09:00'), const Divider(height: 1), row('Préstamos vencidos', '0')]))),
        pad(const Text('Datos personales', style: kH2), v: 12),
        pad(const Text('Los datos de identidad, carrera, semestre y correo institucional provienen del registro académico. Solicita cambios en Secretaría.', style: kMuted)),
        pad(const Column(children: [
          ReadField('Nombre completo', kNombre, auto: true),
          ReadField('Código SAGA', kSaga, auto: true),
          ReadField('Documento de identidad', '14304945', lock: true),
          ReadField('Correo institucional', kCorreo, auto: true),
          ReadField('Teléfono de contacto', '+591 45647812', lock: true),
        ])),
        pad(const Text('Información académica', style: kH2), v: 12),
        pad(const Column(children: [
          ReadField('Tipo de carrera', 'Tecnológica', lock: true),
          ReadField('Carrera', kCarrera, auto: true),
          ReadField('Periodo académico', '2026-II', lock: true),
          ReadField('Semestre actual', kSemestre, auto: true),
        ])),
        pad(const Box(color: C.paleBlue, child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(Icons.info_outline, color: C.blue), SizedBox(width: 10), Expanded(child: Text('Tus datos están protegidos. Solo los usamos para verificar tu identidad y controlar reservas del laboratorio.', style: TextStyle(color: C.navy)))]))),
        pad(Btn('Cerrar sesión', app.logout, kind: BKind.danger, icon: Icons.logout), v: 12),
      ],
    );
  }
}

class AyudaPage extends StatelessWidget {
  const AyudaPage({super.key});
  @override
  Widget build(BuildContext context) {
    Widget faq(String q, String a) => pad(Box(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(q, style: const TextStyle(fontWeight: FontWeight.w800)), gap(4), Text(a, style: const TextStyle(color: C.muted))])));
    return ScreenBody(
      header: const Header(kicker: 'ESPACIO DEL ESTUDIANTE', title: 'Ayuda'),
      children: [
        gap(8),
        faq('¿Cuándo puedo reservar un equipo?', 'Solo los días en que, según tu horario, tienes laboratorio.'),
        faq('¿Cuánto tiempo puedo usarlo?', 'Hasta 4 horas dentro del horario del laboratorio.'),
        faq('¿Qué debo llevar al retirar?', 'Tu credencial universitaria. Verifica los accesorios del equipo.'),
        faq('¿Quién aprueba mi reserva?', 'El administrador del laboratorio. Te notificará a tu correo institucional.'),
        pad(const Box(color: C.paleBlue, child: Row(children: [Icon(Icons.mail_outline, color: C.blue), SizedBox(width: 10), Expanded(child: Text('Soporte: laboratorio@adm.emi.edu.bo', style: TextStyle(color: C.navy, fontWeight: FontWeight.w700)))]))),
      ],
    );
  }
}

// ═══════════════════════════ ADMINISTRADOR ═══════════════════════════
class AdminShell extends StatelessWidget {
  const AdminShell({super.key});
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: app,
      builder: (_, __) {
        final np = app.prestamos.length;
        final ns = app.pendientes.length;
        final pages = <Widget>[const ResumenPage(), const PrestamosPage(), const SolicitudesPage(), const AdminPerfilPage()];
        return Scaffold(
          backgroundColor: C.bg,
          body: pages[app.adminTab],
          bottomNavigationBar: NavigationBar(
            selectedIndex: app.adminTab,
            onDestinationSelected: app.setAdminTab,
            backgroundColor: Colors.white,
            indicatorColor: C.paleBlue,
            destinations: [
              const NavigationDestination(icon: Icon(Icons.grid_view), label: 'Resumen'),
              NavigationDestination(icon: Badge(label: Text('$np'), isLabelVisible: np > 0, child: const Icon(Icons.swap_horiz)), label: 'Préstamos'),
              NavigationDestination(icon: Badge(label: Text('$ns'), isLabelVisible: ns > 0, child: const Icon(Icons.event_note)), label: 'Solicitudes'),
              const NavigationDestination(icon: Icon(Icons.person_outline), label: 'Perfil'),
            ],
          ),
        );
      },
    );
  }
}

class ResumenPage extends StatelessWidget {
  const ResumenPage({super.key});

  Widget kpi(IconData i, String v, String l, String s, Color fg, Color bg, Color bd) => Expanded(
        child: Container(
          margin: const EdgeInsets.all(4),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: bg, border: Border.all(color: bd), borderRadius: BorderRadius.circular(12)),
          child: Column(children: [Icon(i, color: fg), Text(v, style: TextStyle(color: fg, fontSize: 30, fontWeight: FontWeight.w900)), Text(l, style: TextStyle(color: fg, fontWeight: FontWeight.w800)), Text(s, style: TextStyle(color: fg, fontSize: 11), textAlign: TextAlign.center)]),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final venc = app.prestamos.where((p) => p.estado == 'Vencido').toList();
    final pend = app.pendientes;
    return ScreenBody(
      header: const Header(kicker: 'PANEL DE ADMINISTRACIÓN', title: 'Resumen de gestión', sub: 'Hola, Carlos. Estado del laboratorio hoy.', initials: 'CM'),
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Column(children: [
            Row(children: [kpi(Icons.bubble_chart, '24', 'Equipos', '16 disp · 2 mant.', C.navy, Colors.white, C.border), kpi(Icons.swap_horiz, '${app.prestamos.length}', 'Prestados', '2 hoy · 2 mañana', C.navy, Colors.white, C.border)]),
            Row(children: [kpi(Icons.warning_amber_rounded, '${venc.length}', 'Vencidos', 'Seguimiento urgente', C.red, C.redBg, const Color(0xFFF0B8B8)), kpi(Icons.event_note, '${pend.length}', 'Solicitudes', pend.isEmpty ? 'Sin pendientes' : 'Revisa hoy', C.amber, C.amberBg, C.yellow)]),
          ]),
        ),
        if (venc.isNotEmpty)
          Container(
            color: C.redBg,
            padding: const EdgeInsets.all(14),
            child: Row(children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('${venc.length} devoluciones vencidas', style: const TextStyle(color: C.red, fontWeight: FontWeight.w800)), Text(venc.map((p) => '${p.code} (${p.estudiante})').join(' y '), style: const TextStyle(color: C.red, fontSize: 13))])),
              const Icon(Icons.arrow_forward, color: C.red),
            ]),
          ),
        pad(Row(children: [const Text('Devoluciones prioritarias', style: kH2), const Spacer(), InkWell(onTap: () => app.setAdminTab(1), child: const Text('Ver todas →', style: TextStyle(color: C.blue, fontWeight: FontWeight.w800)))]), v: 12),
        ...app.prestamos.take(4).map((p) => pad(Box(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [Expanded(child: Text(p.equipo, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16))), statusTag(p.estado)]),
                Text('${p.code} · ${p.id}', style: kMuted),
                gap(6),
                Row(children: [Expanded(child: Text('${p.estudiante} · Mat. ${p.matricula}', style: const TextStyle(fontWeight: FontWeight.w700))), Text(p.devolucion, style: TextStyle(fontWeight: FontWeight.w800, color: p.estado == 'Vencido' ? C.red : (p.estado == 'Vence hoy' ? C.amber : C.navy)))]),
              ]),
            ))),
        pad(const Text('Disponibilidad de equipos', style: kH2), v: 12),
        pad(ClipRRect(borderRadius: BorderRadius.circular(6), child: SizedBox(height: 12, child: Row(children: [Expanded(flex: 16, child: Container(color: C.blue)), Expanded(flex: 6, child: Container(color: C.yellow)), Expanded(flex: 2, child: Container(color: C.grayBg))])))),
        pad(const Column(children: [
          Row(children: [Icon(Icons.square, size: 12, color: C.blue), SizedBox(width: 8), Text('Disponibles'), Spacer(), Text('16', style: TextStyle(fontWeight: FontWeight.w800))]),
          SizedBox(height: 6),
          Row(children: [Icon(Icons.square, size: 12, color: C.yellow), SizedBox(width: 8), Text('Prestados'), Spacer(), Text('6', style: TextStyle(fontWeight: FontWeight.w800))]),
          SizedBox(height: 6),
          Row(children: [Icon(Icons.square, size: 12, color: C.muted), SizedBox(width: 8), Text('Mantenimiento'), Spacer(), Text('2', style: TextStyle(fontWeight: FontWeight.w800))]),
        ])),
        pad(Row(children: [const Text('Solicitudes pendientes', style: kH2), const Spacer(), InkWell(onTap: () => app.setAdminTab(2), child: const Text('Ver todas →', style: TextStyle(color: C.blue, fontWeight: FontWeight.w800)))]), v: 12),
        ...pend.take(3).map((r) => pad(InkWell(
              onTap: () => app.setAdminTab(2),
              child: Box(child: Row(children: [
                Container(width: 40, height: 40, decoration: BoxDecoration(color: C.paleBlue, borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.event_note, color: C.blue)),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(r.estudiante, style: const TextStyle(fontWeight: FontWeight.w800)), Text('${r.equipoCode} · ${r.fecha}', style: kMuted)])),
                const Icon(Icons.chevron_right, color: C.blue),
              ])),
            ))),
        if (pend.isNotEmpty) pad(Btn('Revisar ${pend.length} solicitudes', () => app.setAdminTab(2), kind: BKind.yellow, icon: Icons.arrow_forward), v: 10),
        pad(const Box(color: C.paleBlue, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Mañana · 07 de octubre', style: TextStyle(color: C.navy, fontWeight: FontWeight.w800)), SizedBox(height: 4), Text('10:00 · MIC-012, Sofía Rojas'), Text('12:00 · MUL-018, Andrés Vega')]))),
      ],
    );
  }
}

class PrestamosPage extends StatefulWidget {
  const PrestamosPage({super.key});
  @override
  State<PrestamosPage> createState() => _PrestamosPageState();
}

class _PrestamosPageState extends State<PrestamosPage> {
  String q = '';

  Future<void> recibir(Prestamo p) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Recibir equipo'),
        content: Text('${p.equipo} (${p.code})\nDevuelto por ${p.estudiante}.\n\nVerifica código, accesorios y estado físico.'),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')), TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Confirmar recepción', style: TextStyle(fontWeight: FontWeight.w800)))],
      ),
    );
    if (ok == true) {
      app.recibir(p);
      if (mounted) snack(context, 'Equipo ${p.code} recibido.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final all = app.prestamos;
    final list = all.where((p) => '${p.equipo}${p.estudiante}${p.code}'.toLowerCase().contains(q.toLowerCase())).toList();
    int n(String e) => all.where((p) => p.estado == e).length;
    return ScreenBody(
      header: const Header(kicker: 'ESPACIO DEL ADMINISTRADOR', title: 'Préstamos y devoluciones', initials: 'CM'),
      children: [
        Container(
          color: C.paleBlue,
          padding: const EdgeInsets.all(14),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Control de préstamos activos', style: TextStyle(color: C.navy, fontWeight: FontWeight.w800)),
            const Text('Registra devoluciones en recepción B-204.', style: TextStyle(color: C.blue, fontSize: 13)),
            gap(10),
            Row(children: [StatCard('${all.length}', 'Prestados'), StatCard('${n('Vencido')}', 'Vencidos', color: C.red), StatCard('${n('Vence hoy')}', 'Hoy', color: C.amber), StatCard('${n('En plazo')}', 'Mañana', color: C.blue)]),
          ]),
        ),
        pad(SearchField('Buscar equipo, estudiante...', (v) => setState(() => q = v)), v: 12),
        pad(Text('${list.length} préstamos activos', style: kMuted)),
        ...list.map((p) => pad(Box(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [statusTag(p.estado), const Spacer(), Text('${p.code} · ${p.id}', style: kMuted)]),
                gap(8),
                Text(p.equipo, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                Text('${p.estudiante} · Mat. ${p.matricula}', style: const TextStyle(color: C.muted)),
                const Divider(height: 20),
                Row(children: [
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('RETIRO', style: kLabel), Text(p.retiro, style: const TextStyle(fontWeight: FontWeight.w800))])),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('DEVOLUCIÓN', style: kLabel), Text(p.devolucion, style: TextStyle(fontWeight: FontWeight.w800, color: p.estado == 'Vencido' ? C.red : (p.estado == 'Vence hoy' ? C.amber : C.text))), Text(p.nota, style: TextStyle(fontSize: 12, color: p.estado == 'Vencido' ? C.red : C.muted))])),
                ]),
                gap(12),
                Row(children: [
                  Expanded(child: Btn('Recibir equipo', () => recibir(p))),
                  if (p.estado == 'Vencido') ...[const SizedBox(width: 10), Expanded(child: Btn('Recordatorio', () => snack(context, 'Recordatorio enviado a ${p.estudiante}.'), kind: BKind.soft))],
                ]),
              ]),
            ))),
      ],
    );
  }
}

class SolicitudesPage extends StatelessWidget {
  const SolicitudesPage({super.key});

  Future<void> rechazar(BuildContext context, Reserva r) async {
    final m = await pickFromList(context, 'Motivo de rechazo de ${r.id}', ['Equipo en mantenimiento', 'Horario no disponible', 'Cuenta con devolución vencida', 'Otro motivo']);
    if (m == null) return;
    app.setStatus(r, 'Rechazada', nota: m);
    if (context.mounted) snack(context, '${r.id} rechazada. El estudiante podrá consultar el motivo.');
  }

  void aprobar(BuildContext context, Reserva r) {
    app.setStatus(r, 'Aprobada');
    snack(context, '${r.id} aprobada. Se notificará al correo institucional del estudiante.');
  }

  @override
  Widget build(BuildContext context) {
    final pend = app.pendientes;
    final warn = pend.where((r) => r.conflicto).toList();
    final first = pend.isEmpty ? null : pend.first;
    return ScreenBody(
      header: const Header(kicker: 'ADMINISTRACIÓN', title: 'Reservaciones pendientes', initials: 'CM'),
      children: [
        Container(
          color: C.paleBlue,
          padding: const EdgeInsets.all(14),
          child: Row(children: [StatCard('${pend.length}', 'Pendientes'), StatCard('${pend.length - warn.length}', 'Horarios OK', color: C.green), StatCard('${warn.length}', 'Advertencia', color: C.amber)]),
        ),
        if (warn.isNotEmpty)
          pad(Box(color: C.amberBg, border: C.yellow, child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [const Icon(Icons.warning_amber_rounded, color: C.amber), const SizedBox(width: 8), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Devolución vencida', style: TextStyle(color: C.amber, fontWeight: FontWeight.w800)), Text('${warn.first.estudiante} (${warn.first.id}) tiene una devolución pendiente. Revisa antes de aprobar.', style: const TextStyle(color: C.amber, fontSize: 13))]))])), v: 12),
        pad(Text('${pend.length} solicitudes · más antiguas primero', style: kMuted)),
        if (pend.isEmpty) pad(const Padding(padding: EdgeInsets.all(30), child: Center(child: Text('No hay solicitudes pendientes. ¡Todo al día!', style: kMuted)))),
        ...pend.map((r) => pad(Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: r.conflicto ? C.yellow : C.border, width: r.conflicto ? 2 : 1)),
              clipBehavior: Clip.antiAlias,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(
                  color: C.navy,
                  padding: const EdgeInsets.all(12),
                  child: Row(children: [
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(r.id, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 17)), Text('${r.equipo} · ${r.equipoCode}', style: const TextStyle(color: Color(0xFFD6E4F7), fontSize: 13))])),
                    r.conflicto ? Tag('Revisar cuenta', C.amber, C.amberBg) : Tag('Sin conflicto', Colors.white, C.green),
                  ]),
                ),
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [const Icon(Icons.person_outline, size: 18, color: C.muted), const SizedBox(width: 6), Text(r.estudiante, style: const TextStyle(fontWeight: FontWeight.w800))]),
                    Text('${r.matricula} · ${r.carrera}', style: kMuted),
                    gap(6),
                    Row(children: [const Icon(Icons.calendar_month_outlined, size: 18, color: C.muted), const SizedBox(width: 6), Text(r.fecha, style: const TextStyle(fontWeight: FontWeight.w800))]),
                    Text(r.solicitada, style: kMuted),
                    if (r.materia.isNotEmpty) Text('${r.materia}${r.docente.isEmpty ? '' : ' · Docente: ${r.docente}'}', style: kMuted),
                    gap(12),
                    Row(children: [
                      Expanded(child: Btn('Aprobar', () => aprobar(context, r), icon: Icons.check)),
                      const SizedBox(width: 10),
                      Expanded(child: Btn('Rechazar', () => rechazar(context, r), kind: BKind.danger, icon: Icons.close)),
                    ]),
                  ]),
                ),
              ]),
            ))),
        if (first != null) ...[
          pad(Row(children: [Text('Revisión de ${first.id}', style: kH2)]), v: 12),
          pad(Box(
            color: C.bg,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              if (first.materia.isNotEmpty) Text(first.materia, style: const TextStyle(fontWeight: FontWeight.w800)),
              if (first.motivo.isNotEmpty) Text('"${first.motivo}"', style: const TextStyle(color: C.muted)),
              gap(10),
              Row(children: [const Icon(Icons.check_circle_outline, color: C.green, size: 18), const SizedBox(width: 8), Expanded(child: Text('${first.estudiante} · Matrícula ${first.matricula} verificada'))]),
              gap(6),
              Row(children: [const Icon(Icons.check_circle_outline, color: C.green, size: 18), const SizedBox(width: 8), Expanded(child: Text('${first.equipoCode} disponible el ${first.fecha}'))]),
              gap(6),
              Row(children: [Icon(first.conflicto ? Icons.warning_amber_rounded : Icons.check_circle_outline, color: first.conflicto ? C.amber : C.green, size: 18), const SizedBox(width: 8), Expanded(child: Text(first.conflicto ? 'Tiene una devolución vencida' : 'Sin devoluciones vencidas ni sanciones'))]),
            ]),
          )),
          pad(Btn('Aprobar ${first.id}', () => aprobar(context, first), kind: BKind.yellow, icon: Icons.check), v: 8),
          pad(const Center(child: Text('Se notificará al correo institucional del estudiante.', style: kMuted))),
        ],
      ],
    );
  }
}

class AdminPerfilPage extends StatelessWidget {
  const AdminPerfilPage({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenBody(
      header: const Header(kicker: 'ESPACIO DEL ADMINISTRADOR', title: 'Mi perfil', initials: 'CM'),
      children: [
        Container(
          color: C.paleBlue,
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          child: const Column(children: [
            CircleAvatar(radius: 38, backgroundColor: Colors.white, child: Text('CM', style: TextStyle(color: C.blue, fontSize: 26, fontWeight: FontWeight.w800))),
            SizedBox(height: 10),
            Text('Carlos M.', style: TextStyle(color: C.navy, fontSize: 22, fontWeight: FontWeight.w800)),
            Text('Administrador de laboratorio', style: kMuted),
          ]),
        ),
        pad(const Column(children: [
          SizedBox(height: 8),
          ReadField('Código de administrador', 'ADM001', lock: true),
          ReadField('Laboratorio', 'Recepción B-204', lock: true),
          ReadField('Horario de atención', 'Lun–vie · 08:00–18:00', lock: true),
        ])),
        pad(Btn('Cerrar sesión', app.logout, kind: BKind.danger, icon: Icons.logout), v: 12),
      ],
    );
  }
}
