// es un modelos que maneja la informacion de band .

class Band {
  String id;
  String name;
  // va ser cantidades de votos que va tener instancia banda
  int? votes;

  // construstor - {...} arg por nombre - existe args por posicion en otros casos
  Band({required this.id, required this.name, this.votes});

  // cuando connectamos con back-server - va responder mapa , No string - porque vamos a implementar comunicacion por Socket .

  // Factory Constructor : no es ada mas que es un constructor que recibe cierta data y regresa nueva Instancia de mi Band o de mi class - Nombre de este Factory is : fromMap
  factory Band.fromMap(Map<String, dynamic> obj) =>
      Band(id: obj['id'], name: obj['name'], votes: obj['votes']);
  // {return Band(etc)} sustituido por funcion de flecha
}
