import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sutura/widget/dashboard_widget.dart';

class BarChartSample2 extends StatefulWidget {
  BarChartSample2({super.key});
  final Color leftBarColor = Colors.blue;
  final Color rightBarColor = Colors.green;
  final Color avgColor = const Color.fromARGB(255, 17, 12, 4);
  @override
  State<StatefulWidget> createState() => BarChartSample2State();
}

class BarChartSample2State extends State<BarChartSample2> {
  final String fournisseurId = FirebaseAuth.instance.currentUser?.uid ?? '';
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bar Chart Sample'),
        backgroundColor: Colors.deepPurple,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: getDashboardData(fournisseurId),
        builder: (context, snapshot) {
         if (snapshot.connectionState == ConnectionState.waiting) {
  return const Center(child: CircularProgressIndicator());
} else if (snapshot.hasError) {
  return Center(child: Text('Erreur : ${snapshot.error}'));
} else if (!snapshot.hasData) {
  return const Center(child: Text("Aucune donnée disponible"));
}


          final data = snapshot.data!;
          final ventesParJour = data['ventesParJour'] as Map<String, dynamic>;
          final jours = ventesParJour.keys.toList();
          final barGroups = <BarChartGroupData>[];
          
final totalCommandes = data['totalCommandes'] as int;
final totalUsers = data['totalUsers'] as int;
final totalArticles = data['totalArticles'] as int;
final totalVentes = data['totalVentes'] as double;
          for (int i = 0; i < jours.length; i++) {
            final total = (ventesParJour[jours[i]]['total'] as num?)?.toDouble() ?? 0.0;
            final valide = (ventesParJour[jours[i]]['valide'] as num?)?.toDouble() ?? 0.0;
            barGroups.add(
              BarChartGroupData(
                x: i,
                barRods: [
                  BarChartRodData(toY: total, color: widget.leftBarColor, width: 7),
                  BarChartRodData(toY: valide, color: widget.rightBarColor, width: 7),
                ],
              ),
            );
          }

          final maxY = ventesParJour.values
                  .map((e) => (e['total'] as num?)?.toDouble() ?? 0.0)
                  .fold<double>(0.0, (a, b) => a > b ? a : b) +
              10;

          // for (int i = 0; i < jours.length; i++) {
          //   final total = data[jours[i]]!['total']!;
          //   final valide = data[jours[i]]!['valide']!;
          //   barGroups.add(
          //     BarChartGroupData(
          //       x: i,
          //       barRods: [
          //         BarChartRodData(toY: total, color: widget.leftBarColor, width: 7),
          //         BarChartRodData(toY: valide, color: widget.rightBarColor, width: 7),
          //       ],
          //     ),
          //   );
          // }

          // final maxY = data.values
          //         .map((e) => e['total'] ?? 0)
          //         .fold<double>(0.0, (a, b) => a > b ? a : b) +
          //     10;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    makeTransactionsIcon(),
                    const SizedBox(width: 38),
                    const Text(
                      'Commande ',
                      style: TextStyle(color: Color(0xff77839a), fontSize: 22),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      'par jour',
                      style: TextStyle(color: Color(0xff77839a), fontSize: 22),
                    ),
                  ],
                ),
                const SizedBox(height: 38),
                const SizedBox(height: 12),
                Expanded(
                  child: BarChart(
                    BarChartData(
                      maxY: maxY,
                      barGroups: barGroups,
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: false,
                          
          
                        
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 42,
                            getTitlesWidget: (value, meta) {
                              final index = value.toInt();
                              if (index >= 0 && index < jours.length) {
                                final date = jours[index];
                                return Text(date.substring(5)); // MM-DD
                              }
                              return const Text('');
                            },
                          ),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      gridData: const FlGridData(show: false),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child:  
                 Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: GridView.count(
                    crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    children: [
  DashboardCard(title: "Utilisateurs", value: totalUsers.toString()),
  DashboardCard(title: "Articles", value: totalArticles.toString()),
  DashboardCard(title: "Commandes", value: totalCommandes.toString()),
  DashboardCard(title: "Ventes", value: "${totalVentes.toStringAsFixed(2)}€"),
],

                  
                  ),
                ),                  
          ),
                
              ],
            ),
          );
        },
      ),
    );
  }

Future<Map<String, dynamic>> getDashboardData(String fournisseurId) async {
  // Ventes par jour (pour le BarChart)
  final snapshot = await FirebaseFirestore.instance.collection('commande')
      .orderBy('date')
      .get();

  Map<String, double> totalParJour = {};
  Map<String, double> validesParJour = {};
  double totalVentes = 0;

  for (final doc in snapshot.docs) {
    final data = doc.data();
   final rawDate = data['date'];
   final timestamp = rawDate is Timestamp ? rawDate.toDate() : DateTime.parse(rawDate);

    final total = (data['total'] as num?)?.toDouble() ?? 0.0;
    final status = data['status'];

    final jour = "${timestamp.year}-${timestamp.month.toString().padLeft(2, '0')}-${timestamp.day.toString().padLeft(2, '0')}";
    totalParJour[jour] = (totalParJour[jour] ?? 0.0) + total;

    if (status == 'validée') {
      validesParJour[jour] = (validesParJour[jour] ?? 0.0) + total;
      totalVentes += total;
    }
  }

  Map<String, Map<String, double>> ventesParJour = {};
  for (var jour in totalParJour.keys) {
    ventesParJour[jour] = {
      'total': totalParJour[jour] ?? 0,
      'valide': validesParJour[jour] ?? 0,
    };
  }

  // Autres statistiques
  final totalCommandes = snapshot.size;

  final usersSnapshot = await FirebaseFirestore.instance.collection('users').get();
  final totalUsers = usersSnapshot.size;

  final articlesSnapshot = await FirebaseFirestore.instance.collection('articles').get();
  final totalArticles = articlesSnapshot.size;

  return {
    'ventesParJour': ventesParJour,
    'totalCommandes': totalCommandes,
    'totalUsers': totalUsers,
    'totalArticles': totalArticles,
    'totalVentes': totalVentes,
  };
}


  

  Widget makeTransactionsIcon() {
    const width = 4.5;
    const space = 3.5;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(width: width, height: 10, color: const Color(0xFFBD1818).withOpacity(0.4)),
        const SizedBox(width: space),
        Container(width: width, height: 28, color: const Color(0xFFA80D0D).withOpacity(0.8)),
        const SizedBox(width: space),
        Container(width: width, height: 42, color: const Color(0xFFF81414)),
        const SizedBox(width: space),
        Container(width: width, height: 28, color: const Color(0xFFAD0D0D).withOpacity(0.8)),
        const SizedBox(width: space),
        Container(width: width, height: 10, color: const Color(0xFFC91010).withOpacity(0.4)),
      ],
    );
  }
}

